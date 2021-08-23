/*
/////////////////////////////////////////////////////////////////////////////////
//// 
////  easySBA Matlab interface for euclidean sparse bundle adjustment 
////  Copyright (C) 2013  Diane H. Theriault (deht@cs.bu.edu)
////  Trustees of Boston University, Boston, MA, USA
////
////  This interface created for sparse bundle adjustment library originally 
////  created by Manolis Lourakis (lourakis at ics forth gr)
////  Institute of Computer Science, Foundation for Research & Technology - Hellas
////  Heraklion, Crete, Greece.
////
////  This program is free software; you can redistribute it and/or modify
////  it under the terms of the GNU General Public License as published by
////  the Free Software Foundation; either version 3 of the License, or
////  (at your option) any later version.
////
////  This program is distributed in the hope that it will be useful,
////  but WITHOUT ANY WARRANTY; without even the implied warranty of
////  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
////  GNU General Public License for more details.
////
///////////////////////////////////////////////////////////////////////////////////
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

#include <time.h>
#include <mex.h>
#include "sba.h"
#include "sba_ImageProjectionAndJacobian.h"


// 
// easySBA_mex
//
// INPUTS
//prhs[0] = number of points
//prhs[1] = number of images/cameras
//prhs[2] = total camera parameters given (7, 12, or 17)
//prhs[3] = number of intrinsic parameters that are fixed (0 - 5)
//              -1: N/A, 0: all free, 1: skew fixed, 2: skew, ar fixed, 4: skew, ar, ppt fixed, 5: all fixed
//prhs[4] = number of distortion parameters that are fixed (-1, 0-5)
//              -9999: N/A
//        The employed distortion model is the one used by Bouguet, see
//        http://www.vision.caltech.edu/bouguetj/calib_doc/htmls/parameters.html.
//        kc[0] is the 2nd order radial distortion coefficient
//        kc[1] is the 4th order radial distortion coefficient
//        kc[2], kc[3] are the tangential distortion coefficients
//        kc[4] is the 6th order radial distortion coefficient
//prhs[5] = number of good image projections (where 3D point is visible in the image)
//prhs[6] = image points (mnp (2) * numCameras x numPoints)
//prhs[7] = visibility mask (numCameras * numPoints)  
//prhs[8] = 3D points (pnp (3) x numPoints)
//prhs[9] = camera parameters (numCameras x numCameraParameters)

// OUTPUTS
// plhs[0] = 3D points
// plhs[1] = camera parameters (all packed together)

#define MAXITER2        150

bool overflowCheck(mwSize input)
{
    return ((mwSize)((int)(input)) == input);
}

double scalarCheck(const mxArray* input, char* errorMessage)
{
   if(!mxIsDouble(input) || mxIsComplex(input) || mxGetM(input)!=1 || mxGetN(input)!=1)
   {
        mexErrMsgTxt(errorMessage);
   }
   return mxGetScalar(input);
}

int scalarIntCheck(const mxArray* input, char* errorMessage)
{
	double output;
   if(mxGetM(input)!=1 || mxGetN(input)!=1 || !mxIsDouble(input))
   {
        mexErrMsgTxt(errorMessage);
   }

	output=mxGetScalar(input);
	if((int)(output) != output)
	{
        mexErrMsgTxt(errorMessage);
	}

   return (int)(output);
}


double positiveScalarCheck(const mxArray* input, char* nonScalarMessage, char* nonPositiveMessage)
{
    double value = scalarCheck(input, nonScalarMessage);
    if (value <= 0)
    {
        mexErrMsgTxt(nonPositiveMessage);
    }
    return value;
}

/* display printf-style error messages in matlab */
static void matlabFmtdErrMsgTxt(char *fmt, ...)
{
char  buf[256];
va_list args;

	va_start(args, fmt);
	vsprintf(buf, fmt, args);
	va_end(args);

  mexErrMsgTxt(buf);
}

/* display printf-style warning messages in matlab */
static void matlabFmtdWarnMsgTxt(char *fmt, ...)
{
char  buf[256];
va_list args;

	va_start(args, fmt);
	vsprintf(buf, fmt, args);
	va_end(args);

  mexWarnMsgTxt(buf);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	const int debug=1;

    //VARIABLE DECLARATIONS
    // constants
    const int pnp = 3; //dimensionality of world points
    const int mnp = 2; //dimensionality of image points
    const int extrinsicParams=7;
    const int intrinsicParams=5;
    const int distortionParams=5;
    
    //parameters
    mwSize numPoints=0;
    mwSize numCameras=0; //cameras, whatever
    int numCameraParameters, internalCameraParameters;
    int intrinsicFixed=0;
    int distortionFixed=0;
    int numGoodProjections=0;
    
    //data
    double* estimatedParameters=NULL;   //both 3D points and camera parameters together
    double* initialCameraRotation=NULL; //initial camera rotation
    double* imagePoints=NULL;           //coordinates of the image points
    mwSize numImageProjections=0;       //number of non-nan entries in imagePoints
    char* visibilityMask=NULL;          //which 3D points can be seen in which cameras
    double* pImg;  //pointer to Matlab's image point data
    double* pVis;  //pointer to Matlab's visibility matrix data
    double* pWorld; //pointer to Matlab's world point data
    double* pCam;  //pointer to Matlab's camera data
    
    //output
    double* outputPoints;
    double* outputCamera;
                      
    //internal variables
	long int ret_val, verbose=0;
    double* covimgpts=NULL;
    double info[SBA_INFOSZ];
    double opts[SBA_OPTSSZ]={SBA_INIT_MU, SBA_STOP_THRESH, SBA_STOP_THRESH, SBA_STOP_THRESH, 0.0};
    struct globs_ processingOptions;
    void (*imageProjectionFn)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *hx, void *adata);
    void (*jacobianFn)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *jac, void *adata);  
    double quatAccumulator;
    
    //index variables
    mwSize i,j;
    mwSize imgPtIdx, vmIdx, pVisIdx, pImgIdx, foundPoints;
    mwSize paramIdx, rotIdx, pCamIdx, pWorldIdx;
    
    
    // make sure we have the right number of input & output arguments
    if (nrhs != 10)
    {
        mexErrMsgTxt("easySBA_mex: incorrect number of input arguments");
    }
    
    if (nlhs == 0)
    {
        mexErrMsgTxt("easySBA_mex: no output arguments");
    }
    if (nlhs > 2)
    {
        mexErrMsgTxt("easySBA_mex: too many output arguments");
    }
    
    // VALIDATE AND INTERPRET INPUTS
    
    // PARAMETERS
    //
    // first argument: number of input points
    numPoints = (mwSize) positiveScalarCheck(prhs[0], 
            "easySBA_mex: first argument (number of points) must be a real scalar.", 
            "easySBA_mex: first argument (number of points) must be positive");
    if (!overflowCheck(numPoints))
	{
		    mexErrMsgTxt("easySBA_mex error: numPoints value overflows 32 bit int\n");
    }
	if(debug)
	{
		mexPrintf("easySBA_mex: %ld points\n", numPoints);
	}
    
    //
    //second argument: number of images / cameras
    numCameras = (mwSize) positiveScalarCheck(prhs[1], 
            "easySBA_mex: second argument (number of images/cameras) must be a real scalar.",
            "easySBA_mex: second argument (number of images/cameras) must be positive");
    if (!overflowCheck(numCameras))
	{
		    mexErrMsgTxt("easySBA_mex error: numCameras value overflows 32 bit int\n");
    }
	if(debug)
	{
		mexPrintf("easySBA_mex: %ld cameras\n", numCameras);
	}
    
    //
    //third argument: number of camera parameters
    numCameraParameters = (int)positiveScalarCheck(prhs[2],
            "easySBA_mex: third argument (number of camera parameters) must be a real scalar.",
            "easySBA_mex: third argument (number of camera parameters) must be positive");

    switch(numCameraParameters)
    {
        case 7: //extrinsics only
        { 
            //do I need to do/assume something about the calibration? I think I do, but I'm not sure what
            imageProjectionFn = img_projsRTS_x;
            jacobianFn = img_projsRTS_jac_x;
            internalCameraParameters=0;
            break;
        }
        case 12: //extrinsics and intrinsics
        {
            imageProjectionFn = img_projsKRTS_x;
            jacobianFn = img_projsKRTS_jac_x;
            internalCameraParameters=intrinsicParams;
            break;
        }
        case 17: //extrinsics, intrinsics, and distortion
        {
            imageProjectionFn = img_projsKDRTS_x;
            jacobianFn = img_projsKDRTS_jac_x;
            internalCameraParameters=intrinsicParams+distortionParams;
            break ;
        }
        default:
            mexErrMsgTxt("easySBA_mex: number of camera parameters must be 7 (position and orientation), \n 13 (with intrinsics), or 17 (with distortion)\n");
    }
	if(debug)
	{
		mexPrintf("easySBA_mex: %d camera parameters\n", numCameraParameters);
	}
    
    //
    //fourth and fifth arguments: codes for which intrinsic/distortion parameters to vary
    intrinsicFixed=scalarIntCheck(prhs[3], "easySBA_mex: fourth argument (code to vary intrinsics) must be a real scalar.");
    distortionFixed=scalarIntCheck(prhs[4], "easySBA_mex: fifth argument (code to vary distortion) must be a real scalar.");
	if(debug)
	{
		mexPrintf("easySBA_mex: intrinsics %d, distortion %d\n", intrinsicFixed, distortionFixed);
	}
 
    //check that the codes are valid
    if( intrinsicFixed < -1 || intrinsicFixed > 5)
    {
        mexErrMsgTxt("easySBA_mex: invalid code given for the number of free intrinsics parameters.");
    }
    if(distortionFixed > 5 || (distortionFixed < -1 && distortionFixed != -9999))
    {
        mexErrMsgTxt("easySBA_mex: invalid code given for the number of free distortion parameters.");
    }

    
    if( (intrinsicFixed>0) && (numCameraParameters < extrinsicParams+intrinsicParams) )
    {
        mexErrMsgTxt("easySBA_mex: initial estimates of intrinsic parameters are missing");
    }
    if( (distortionFixed>0) && (numCameraParameters < extrinsicParams+intrinsicParams+distortionParams) )
    {
        mexErrMsgTxt("easySBA_mex: initial estimates of distortion parameters are missing");
    }
    
    // Print something informative about how many camera parameters were given, 
    // and which camera parameters are free and fixed
	if(debug)
	{
		mexPrintf("easySBA_mex: %d intrinsic parameters fixed. %d distortion parameters fixed", intrinsicFixed, distortionFixed);
	}
    
    //
    // DATA
    //
    
    //
    // number of good image projections
    numGoodProjections = (int)positiveScalarCheck(prhs[5], 
            "easySBA_mex: sixth argument (number of good image projections) must be a scalar",
            "easySBA_mex: sixth argument (number of good image projections) must be positive");
	if(debug)
	{
		mexPrintf("easySBA_mex: %d good projections\n", numGoodProjections);
	}


    //Check All sizes
    
    //prhs[6] = image points (numCameras x numPoints * mnp (2) )
     if(!mxIsDouble(prhs[6]) || mxIsComplex(prhs[6]) || mxGetN(prhs[6])!=numPoints || mxGetM(prhs[6])!=mnp*numCameras)
     {
        matlabFmtdErrMsgTxt("easySBA_mex: seventh argument (image points) is the wrong size. Expecting %d x %d", mnp*numCameras, numPoints);
     }
     pImg=mxGetPr(prhs[6]);

    //prhs[7] = visibility mask (numCameras x numPoints)
     if(!mxIsDouble(prhs[7]) || mxIsComplex(prhs[7]) || mxGetN(prhs[7])!=numPoints || mxGetM(prhs[7])!=numCameras)
     {
        matlabFmtdErrMsgTxt("easySBA_mex: eigth argument (visibility mask) is the wrong size. Expecting %d x %d", numCameras, numPoints);
     }
     pVis=mxGetPr(prhs[7]);
    
    //prhs[8] = 3D points (pnp (3) x numPoints)
    if(!mxIsDouble(prhs[8]) || mxIsComplex(prhs[8]) || mxGetN(prhs[8])!=numPoints || mxGetM(prhs[8])!=pnp)
    {
        matlabFmtdErrMsgTxt("easySBA_mex: ninth argument (image points) is the wrong size. Expecting %d x %d", pnp, numPoints);
    }
    pWorld=mxGetPr(prhs[8]);
    
    //prhs[9] = camera parameters (numCameras x numCameraParameters)
    if(!mxIsDouble(prhs[9]) || mxIsComplex(prhs[9]) || mxGetN(prhs[9])!=numCameras || mxGetM(prhs[9])!=numCameraParameters)
    {
        matlabFmtdErrMsgTxt("easySBA_mex: tenth argument (camera parameters) is the wrong size. Expecting %d x %d", numCameraParameters, numCameras);
    }
    pCam=mxGetPr(prhs[9]);
    
  
    //
    // Copy and format all the data
    //
    
    // image points and visiblity matrix
    imagePoints=mxMalloc(numGoodProjections*mnp*sizeof(double));
    visibilityMask = mxMalloc(numPoints*numCameras*sizeof(char));
    
    //Copy in the image projections and make sure the visibility mask lines up correctly.
    pVisIdx=0;
    pImgIdx=0;
    imgPtIdx=0;
    vmIdx=0;
    foundPoints=0;
    for(i=0; i<numPoints; i++)
    {
        for(j=0; j<numCameras; j++)
        {
            // iff the value is good, then the visibility mask should be good

            //check if both are bad
            if(mxIsNaN(pImg[pImgIdx]) || mxIsNaN(pImg[pImgIdx+1]))
            {
                if(pVis[pVisIdx]==0)
                {
                    visibilityMask[vmIdx]=0;
                    vmIdx++;
                    pVisIdx++;
                    pImgIdx+=mnp; // each image point has u,v coordinates
                    continue;
                }
                else
                {
                    mxFree(imagePoints);
                    mxFree(visibilityMask);
                    matlabFmtdErrMsgTxt("Image projection of point %d in camera %d is NaN, but visibility mask is true\n", i, j);
                }
            }
            else
            {
                if(pVis[pVisIdx]==0)
                {
                    mxFree(imagePoints);
                    mxFree(visibilityMask);
                    matlabFmtdErrMsgTxt("Visibility matrix of point %d in camera %d is false, but the image point is non-NaN\n", i, j);
                }
                else
                {
                    if(foundPoints>=numGoodProjections)
                    {
                        mxFree(imagePoints);
                        mxFree(visibilityMask);
                        matlabFmtdErrMsgTxt("%d image projections promised, but more found\n", i, j);
                    }
                    visibilityMask[vmIdx]=1;
                    imagePoints[imgPtIdx]=pImg[pImgIdx];
                    imagePoints[imgPtIdx+1]=pImg[pImgIdx+1];
                    vmIdx++;
                    pVisIdx++;                    
                    pImgIdx+=mnp; // each image point has u,v coordinates
                    imgPtIdx+=mnp;
                    foundPoints++;
                }
            }
        }
    }
       
    //format the camera parameters and 3D points
    initialCameraRotation = mxMalloc(numCameras*4*sizeof(double));
    estimatedParameters = mxMalloc( (numCameras*(numCameraParameters-1)+numPoints*pnp) * sizeof(double));
    paramIdx=0;
    rotIdx=0;
    pCamIdx=0;
    pWorldIdx=0;
    
    // Copy in the camera parameters
    for(i=0; i<numCameras; i++)
    {
        for(j=0; j<internalCameraParameters; j++)
        {
            estimatedParameters[paramIdx]=pCam[pCamIdx];
            paramIdx++;
            pCamIdx++;
        }

         //copy out the rotation
         // his code expects that you chopped off the constant of the quaternion 
         // in the parameter vector, but not in the initial rotation
        initialCameraRotation[rotIdx]=pCam[pCamIdx];        
        pCamIdx++; 
        rotIdx++;                

        for(j=1; j<4; j++)
        {
            initialCameraRotation[rotIdx]=pCam[pCamIdx];        
			estimatedParameters[paramIdx]=0.0;
            //estimatedParameters[paramIdx]=pCam[pCamIdx]; //line 1505: this is actually zero going in
            rotIdx++;
            paramIdx++;
            pCamIdx++;
        }
        for(j=0; j<3; j++) //copy out the position
        {
            estimatedParameters[paramIdx]=pCam[pCamIdx];
            paramIdx++;
            pCamIdx++;
        }
    }
    
    // Copy in the world points (aka structure parameters)
    pWorldIdx=0;
    for(i=0; i<numPoints; i++)
    {
        for(j=0; j<pnp; j++)
        {
            estimatedParameters[paramIdx]=pWorld[pWorldIdx];
            paramIdx++;
            pWorldIdx++;
        }
    }
    
     /* set up globs structure */ //line 1515
    processingOptions.pnp=pnp; 
	processingOptions.mnp=mnp;
    processingOptions.cnp=numCameraParameters-1; 
    processingOptions.rot0params=initialCameraRotation;
    processingOptions.intrcalib=NULL;
    processingOptions.nccalib=intrinsicFixed;
    processingOptions.ncdist=distortionFixed;
    processingOptions.ptparams=NULL;
    processingOptions.camparams=NULL;


    //call sba_motstr_levmar
 	ret_val=sba_motstr_levmar_x((long int)(numPoints), 0, (long int)(numCameras), 0, visibilityMask, estimatedParameters, 
                          numCameraParameters-1, pnp, imagePoints, NULL, mnp,
                          imageProjectionFn, jacobianFn,
                          (void *)(&processingOptions), MAXITER2, verbose, opts, info);
 
	mexPrintf("SBA returned %d in %g iter, reason %g, error %g [initial %g], %d/%d func/fjac evals, %d lin. systems\n", ret_val,
                    info[5], info[6], info[1]/numGoodProjections, info[0]/numGoodProjections, (long int)info[7], (long int)info[8], (long int)info[9]);

    
    //INTERPRET OUTPUTS
    //everything is in the "estimated parameters" vector, in the same order that it went in.
    
    //we know for sure that there is at least one output argument
    plhs[0]=mxCreateDoubleMatrix((mwSize)(pnp), numPoints, mxREAL);
    outputPoints=mxGetPr(plhs[0]);
    pWorldIdx=0;
    paramIdx=numCameras*(numCameraParameters-1);
    for(i=0;i<numPoints;i++)
    {
        for(j=0; j<pnp; j++)
        {
            outputPoints[pWorldIdx]=estimatedParameters[paramIdx];
            pWorldIdx++;
            paramIdx++;
        }
    }
    
    //subsequent output arguments will be for the camera parameters
    if(nlhs>1)
    {
        plhs[1]=mxCreateDoubleMatrix((mwSize)(numCameraParameters), numCameras, mxREAL);
        outputCamera=mxGetPr(plhs[1]);
        pCamIdx=0;
        paramIdx=0;
        for(i=0; i<numCameras; i++)
        {
            for(j=0; j<internalCameraParameters; j++)
            {
                outputCamera[pCamIdx]=estimatedParameters[paramIdx];
                pCamIdx++;
                paramIdx++;
            }
            
            //Copy out the rotation, but don't forget we chopped off the first element of the quaternion going in
            pCamIdx++; //skip the missing constant of the quaternion
            quatAccumulator=0;
            for(j=1; j<4; j++)
            {
                outputCamera[pCamIdx]=estimatedParameters[paramIdx];
                quatAccumulator += outputCamera[pCamIdx]*outputCamera[pCamIdx];
                pCamIdx++;
                paramIdx++;
            }
            outputCamera[pCamIdx-4]=sqrt(1-quatAccumulator); //fill in the missing constant
            
            //copy out the position
            for(j=0; j<3;j++)
            {
                outputCamera[pCamIdx]=estimatedParameters[paramIdx];
                pCamIdx++;
                paramIdx++;
            }
        }
    }
    
    // CLEAN UP
    mxFree(imagePoints);
    mxFree(visibilityMask);
    mxFree(estimatedParameters);
    mxFree(initialCameraRotation);
    
    return;  
}