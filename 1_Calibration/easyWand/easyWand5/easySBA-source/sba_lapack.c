/////////////////////////////////////////////////////////////////////////////////
//// 
////  Linear algebra operations for the sba package
////  Copyright (C) 2004-2009 Manolis Lourakis (lourakis at ics forth gr)
////  Institute of Computer Science, Foundation for Research & Technology - Hellas
////  Heraklion, Crete, Greece.
////
////  This program is free software; you can redistribute it and/or modify
////  it under the terms of the GNU General Public License as published by
////  the Free Software Foundation; either version 2 of the License, or
////  (at your option) any later version.
////
////  This program is distributed in the hope that it will be useful,
////  but WITHOUT ANY WARRANTY; without even the implied warranty of
////  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
////  GNU General Public License for more details.
////
////  Adapted to be compatible with Matlab's implementation of LAPACK 
////  by Diane H. Theriault (deht@cs.bu.edu)
///////////////////////////////////////////////////////////////////////////////////

/* A note on memory alignment:
 *
 * Several of the functions below use a piece of dynamically allocated memory
 * to store variables of different size (i.e., ints and doubles). To avoid
 * alignment problems, care must be taken so that elements that are larger
 * (doubles) are stored before smaller ones (ints). This ensures proper
 * alignment under different alignment choices made by different CPUs:
 * For instance, a double variable is aligned on x86 to 4 bytes but
 * aligned to 8 bytes on AMD64 despite having the same size of 8 bytes.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>

#include "compiler.h"
#include "sba.h"

#include <lapack.h> 
//Need Matlab's header file on the include path when building sba.lib

#define emalloc(sz)       emalloc_(__FILE__, __LINE__, sz)
extern void *emalloc_(char *file, long int line, size_t sz);

/*
 * This function returns the solution of Ax = b
 *
 * The function is based on QR decomposition with explicit computation of Q:
 * If A=Q R with Q orthogonal and R upper triangular, the linear system becomes
 * Q R x = b or R x = Q^T b.
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error, 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_QR(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;

double *a, *r, *tau, *work;
ptrdiff_t a_sz, r_sz, tau_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t m;
ptrdiff_t info, worksz, nrhs=1;
register double sum;

printf("sba_Axb_QR\n");

m=iM;

    if(A==NULL){
      if(buf) mxFree(buf);
      buf=NULL;
      buf_sz=0;

      return 1;
    }

    /* calculate required memory size */
    a_sz=(iscolmaj)? 0 : m*m;
    r_sz=m*m; /* only the upper triangular part really needed */
    tau_sz=m;
    if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
      double tmp;

      worksz=-1; // workspace query; optimal size is returned in tmp
      FORTRAN_WRAPPER(dgeqrf)(&m, &m, NULL, &m, NULL, &tmp, &worksz, &info);
      nb=(ptrdiff_t)(tmp/m); // optimal worksize is m*nb
#else
      nb=1; // min worksize is m
#endif /* SBA_LS_SCARCE_MEMORY */
    }
    worksz=nb*m;
    tot_sz=a_sz + r_sz + tau_sz + worksz;

    if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
      if(buf) mxFree(buf); /* free previously allocated memory */

      buf_sz=tot_sz;
      buf=(double *)emalloc(buf_sz*sizeof(double));
      if(!buf){
        fprintf(stderr, "memory allocation in sba_Axb_QR() failed!\n");
        return 0;
      }
    }

    if(!iscolmaj){
    	a=buf;
	    /* store A (column major!) into a */
	    for(i=0; i<m; ++i)
		    for(j=0; j<m; ++j)
			    a[i+j*m]=A[i*m+j];
    }
    else a=A; /* no copying required */

    r=buf+a_sz;
    tau=r+r_sz;
    work=tau+tau_sz;

  /* QR decomposition of A */
  FORTRAN_WRAPPER(dgeqrf)(&m, &m, a, &m, tau, work, &worksz, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dgeqrf in sba_Axb_QR()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "Unknown LAPACK error %d for dgeqrf in sba_Axb_QR()\n", info);
      return 0;
    }
  }

  /* R is now stored in the upper triangular part of a; copy it in r so that dorgqr() below won't destroy it */
  for(i=0; i<r_sz; ++i)
    r[i]=a[i];

  /* compute Q using the elementary reflectors computed by the above decomposition */
  FORTRAN_WRAPPER(dorgqr)(&m, &m, &m, a, &m, tau, work, &worksz, &info);
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dorgqr in sba_Axb_QR()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "Unknown LAPACK error (%d) in sba_Axb_QR()\n", info);
      return 0;
    }
  }

  /* Q is now in a; compute Q^T b in x */
  for(i=0; i<m; ++i){
    for(j=0, sum=0.0; j<m; ++j)
      sum+=a[i*m+j]*B[j];
    x[i]=sum;
  }

  /* solve the linear system R x = Q^t b */
  FORTRAN_WRAPPER(dtrtrs)("U", "N", "N", &m, &nrhs, r, &m, x, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dtrtrs in sba_Axb_QR()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the %d-th diagonal element of A is zero (singular matrix) in sba_Axb_QR()\n", info);
      return 0;
    }
  }

	return 1;
}

/*
 * This function returns the solution of Ax = b
 *
 * The function is based on QR decomposition without computation of Q:
 * If A=Q R with Q orthogonal and R upper triangular, the linear system becomes
 * (A^T A) x = A^T b or (R^T Q^T Q R) x = A^T b or (R^T R) x = A^T b.
 * This amounts to solving R^T y = A^T b for y and then R x = y for x
 * Note that Q does not need to be explicitly computed
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error, 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_QRnoQ(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;
ptrdiff_t m;

double *a, *tau, *work;
ptrdiff_t a_sz, tau_sz, tot_sz;
register long int i, j;
ptrdiff_t info, worksz, nrhs=1;
register double sum;

printf("sba_Axb_QRnoQ\n");
   
m=iM;
    if(A==NULL){
      if(buf) mxFree(buf);
      buf=NULL;
      buf_sz=0;

      return 1;
    }

    /* calculate required memory size */
    a_sz=(iscolmaj)? 0 : m*m;
    tau_sz=m;
    if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
      double tmp;

      worksz=-1; // workspace query; optimal size is returned in tmp
      FORTRAN_WRAPPER(dgeqrf)(&m, &m, NULL, &m, NULL, &tmp, &worksz, &info);
      nb=((long int)tmp)/m; // optimal worksize is m*nb
#else
      nb=1; // min worksize is m
#endif /* SBA_LS_SCARCE_MEMORY */
    }
    worksz=nb*m;
    tot_sz=a_sz + tau_sz + worksz;

    if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
      if(buf) mxFree(buf); /* free previously allocated memory */

      buf_sz=tot_sz;
      buf=(double *)emalloc(buf_sz*sizeof(double));
      if(!buf){
        fprintf(stderr, "memory allocation in sba_Axb_QRnoQ() failed!\n");
        return 0;
      }
    }

    if(!iscolmaj){
    	a=buf;
	/* store A (column major!) into a */
	for(i=0; i<m; ++i)
		for(j=0; j<m; ++j)
			a[i+j*m]=A[i*m+j];
    }
    else a=A; /* no copying required */

    tau=buf+a_sz;
    work=tau+tau_sz;

  /* compute A^T b in x */
  for(i=0; i<m; ++i){
    for(j=0, sum=0.0; j<m; ++j)
      sum+=a[i*m+j]*B[j];
    x[i]=sum;
  }

  /* QR decomposition of A */
  FORTRAN_WRAPPER(dgeqrf)(&m, &m, a, &m, tau, work, &worksz, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dgeqrf in sba_Axb_QRnoQ()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "Unknown LAPACK error %d for dgeqrf in sba_Axb_QRnoQ()\n", info);
      return 0;
    }
  }

  /* R is stored in the upper triangular part of a */

  /* solve the linear system R^T y = A^t b */
  FORTRAN_WRAPPER(dtrtrs)("U", "T", "N", &m, &nrhs, a, &m, x, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dtrtrs in sba_Axb_QRnoQ()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the %d-th diagonal element of A is zero (singular matrix) in sba_Axb_QRnoQ()\n", info);
      return 0;
    }
  }

  /* solve the linear system R x = y */
  FORTRAN_WRAPPER(dtrtrs)("U", "N", "N", &m, &nrhs, a, &m, x, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dtrtrs in sba_Axb_QRnoQ()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the %d-th diagonal element of A is zero (singular matrix) in sba_Axb_QRnoQ()\n", info);
      return 0;
    }
  }

	return 1;
}

/*
 * This function returns the solution of Ax=b
 *
 * The function assumes that A is symmetric & positive definite and employs
 * the Cholesky decomposition:
 * If A=U^T U with U upper triangular, the system to be solved becomes
 * (U^T U) x = b
 * This amounts to solving U^T y = b for y and then U x = y for x
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error, 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_Chol(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0;

double *a, *w;
ptrdiff_t a_sz, tot_sz;
ptrdiff_t i, j;
ptrdiff_t info, nrhs=1;
ptrdiff_t m;
   
m=iM;
    if(A==NULL){
      if(buf) mxFree(buf);
      buf=NULL;
      buf_sz=0;

      return 1;
    }
    /* calculate required memory size */
    a_sz=(iscolmaj)? 0 : m*m;
    tot_sz=a_sz;
    if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
      if(buf) mxFree(buf); /* free previously allocated memory */

      buf_sz=tot_sz;
      buf=(double *)emalloc(buf_sz*sizeof(double));
      if(!buf){
        fprintf(stderr, "memory allocation in sba_Axb_Chol() failed!\n");
        return 0;
      }
    }
    if(!iscolmaj){
    	a=buf;

      /* store A into a and B into x; A is assumed to be symmetric, hence
       * the column and row major order representations are the same
       */
      for(i=0; i<m; ++i){
        a[i]=A[i];
        x[i]=B[i];
      }
      for(j=m*m; i<j; ++i) // copy remaining rows; note that i is not re-initialized
        a[i]=A[i];
    }
    else{ /* no copying is necessary for A */
      a=A;
      for(i=0; i<m; ++i)
        x[i]=B[i];
    }
  /* Cholesky decomposition of A */
  FORTRAN_WRAPPER(dpotrf)("U", &m, a, &m, &info);
  
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dpotf2/dpotrf in sba_Axb_Chol()\n", -info);
      //return 0;
	  return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the leading minor of order %d is not positive definite,\nthe factorization could not be completed for dpotf2/dpotrf in sba_Axb_Chol()\n", info);
      return 0;
    }
  }

  /* below are two alternative ways for solving the linear system: */
#if 1
  /* use the computed Cholesky in one lapack call */
  FORTRAN_WRAPPER(dpotrs)("U", &m, &nrhs, a, &m, x, &m, &info);
  if(info<0){
    fprintf(stderr, "LAPACK error: illegal value for argument %d of dpotrs in sba_Axb_Chol()\n", -info);
    return 0;
  }
#else
  /* solve the linear systems U^T y = b, U x = y */
  FORTRAN_WRAPPER(dtrtrs)("U", "T", "N", &m, &nrhs, a, &m, x, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dtrtrs in sba_Axb_Chol()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the %d-th diagonal element of A is zero (singular matrix) in sba_Axb_Chol()\n", info);
      return 0;
    }
  }

  /* solve U x = y */
  FORTRAN_WRAPPER(dtrtrs)("U", "N", "N", &m, &nrhs, a, &m, x, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dtrtrs in sba_Axb_Chol()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the %d-th diagonal element of A is zero (singular matrix) in sba_Axb_Chol()\n", info);
      return 0;
    }
  }
#endif /* 1 */
	return 1;
}

/*
 * This function returns the solution of Ax = b
 *
 * The function employs LU decomposition:
 * If A=L U with L lower and U upper triangular, then the original system
 * amounts to solving
 * L y = b, U x = y
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error,
 * 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_LU(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0;

ptrdiff_t a_sz, ipiv_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t info, *ipiv, nrhs=1;
ptrdiff_t m;
double *a;

printf("sba_Axb_LU\n");

m=iM;
    if(A==NULL){
      if(buf) mxFree(buf);
      buf=NULL;
      buf_sz=0;

      return 1;
    }

    /* calculate required memory size */
    ipiv_sz=m;
    a_sz=(iscolmaj)? 0 : m*m;
    tot_sz=a_sz*sizeof(double) + ipiv_sz*sizeof(int); /* should be arranged in that order for proper doubles alignment */

    if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
      if(buf) mxFree(buf); /* free previously allocated memory */

      buf_sz=tot_sz;
      buf=(double *)emalloc(buf_sz);
      if(!buf){
        fprintf(stderr, "memory allocation in sba_Axb_LU() failed!\n");
        return 0;
      }
    }

    if(!iscolmaj){
      a=buf;
      ipiv=((ptrdiff_t *)(a+a_sz));

      /* store A (column major!) into a and B into x */
	    for(i=0; i<m; ++i){
		    for(j=0; j<m; ++j)
          a[i+j*m]=A[i*m+j];

        x[i]=B[i];
      }
    }
    else{ /* no copying is necessary for A */
      a=A;
      for(i=0; i<m; ++i)
        x[i]=B[i];
      ipiv=((ptrdiff_t *)(buf));
    }

  /* LU decomposition for A */
	FORTRAN_WRAPPER(dgetrf)(&m, &m, a, &m, ipiv, &info);  
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetrf illegal in sba_Axb_LU()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular matrix A for dgetrf in sba_Axb_LU()\n");
			return 0;
		}
	}

  /* solve the system with the computed LU */
  FORTRAN_WRAPPER(dgetrs)("N", &m, &nrhs, a, &m, ipiv, x, &m, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetrs illegal in sba_Axb_LU()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "unknown error for dgetrs in sba_Axb_LU()\n");
			return 0;
		}
	}

	return 1;
}

/*
 * This function returns the solution of Ax = b
 *
 * The function is based on SVD decomposition:
 * If A=U D V^T with U, V orthogonal and D diagonal, the linear system becomes
 * (U D V^T) x = b or x=V D^{-1} U^T b
 * Note that V D^{-1} U^T is the pseudoinverse A^+
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error, 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_SVD(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0;
static double eps=-1.0;

register ptrdiff_t i, j;
double *a, *u, *s, *vt, *work;
ptrdiff_t a_sz, u_sz, s_sz, vt_sz, tot_sz;
double thresh, one_over_denom;
register double sum;
ptrdiff_t info, rank, worksz, *iwork, iworksz;
ptrdiff_t m;

printf("sba_Axb_SVD\n");

m=iM;
  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate required memory size */
#ifndef SBA_LS_SCARCE_MEMORY
  worksz=-1; // workspace query. Keep in mind that dgesdd requires more memory than dgesvd
  /* note that optimal work size is returned in thresh */
  FORTRAN_WRAPPER(dgesdd)("A", &m, &m, NULL, &m, NULL, NULL, &m, NULL, &m,
          (double *)&thresh, &worksz, NULL, &info);
  /* FORTRAN_WRAPPER(dgesvd)("A", "A", (long int *)&m, (long int *)&m, NULL, (long int *)&m, NULL, NULL, (long int *)&m, NULL, (long int *)&m,
          (double *)&thresh, (long int *)&worksz, &info); */
  worksz=(long int)thresh;
#else
  worksz=m*(7*m+4); // min worksize for dgesdd
  //worksz=5*m; // min worksize for dgesvd
#endif /* SBA_LS_SCARCE_MEMORY */
  iworksz=8*m;
  a_sz=(!iscolmaj)? m*m : 0;
  u_sz=m*m; s_sz=m; vt_sz=m*m;

  tot_sz=(a_sz + u_sz + s_sz + vt_sz + worksz)*sizeof(double) + iworksz*sizeof(int); /* should be arranged in that order for proper doubles alignment */

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz);
    if(!buf){
      fprintf(stderr, "memory allocation in sba_Axb_SVD() failed!\n");
      return 0;
    }
  }

  if(!iscolmaj){
    a=buf;
    u=a+a_sz;
    /* store A (column major!) into a */
    for(i=0; i<m; ++i)
      for(j=0; j<m; ++j)
        a[i+j*m]=A[i*m+j];
  }
  else{
    a=A; /* no copying required */
    u=buf;
  }

  s=u+u_sz;
  vt=s+s_sz;
  work=vt+vt_sz;
  iwork=(ptrdiff_t *)(work+worksz);

  /* SVD decomposition of A */
  FORTRAN_WRAPPER(dgesdd)("A", &m, &m, a, &m, s, u, &m, vt, &m, work, &worksz, iwork, &info);
  //FORTRAN_WRAPPER(dgesvd)("A", "A", (int *)&m, (int *)&m, a, (int *)&m, s, u, (int *)&m, vt, (int *)&m, work, (int *)&worksz, &info);

  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dgesdd/dgesvd in sba_Axb_SVD()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: dgesdd (dbdsdc)/dgesvd (dbdsqr) failed to converge in sba_Axb_SVD() [info=%d]\n", info);

      return 0;
    }
  }

  if(eps<0.0){
    double aux;

    /* compute machine epsilon. DBL_EPSILON should do also */
    for(eps=1.0; aux=eps+1.0, aux-1.0>0.0; eps*=0.5)
                              ;
    eps*=2.0;
  }

  /* compute the pseudoinverse in a */
  memset(a, 0, m*m*sizeof(double)); /* initialize to zero */
  for(rank=0, thresh=eps*s[0]; rank<m && s[rank]>thresh; ++rank){
    one_over_denom=1.0/s[rank];

    for(j=0; j<m; ++j)
      for(i=0; i<m; ++i)
        a[i*m+j]+=vt[rank+i*m]*u[j+rank*m]*one_over_denom;
  }

	/* compute A^+ b in x */
	for(i=0; i<m; ++i){
	  for(j=0, sum=0.0; j<m; ++j)
      sum+=a[i*m+j]*B[j];
    x[i]=sum;
  }

	return 1;
}

/*
 * This function returns the solution of Ax = b for a real symmetric matrix A
 *
 * The function is based on UDUT factorization with the pivoting
 * strategy of Bunch and Kaufman:
 * A is factored as U*D*U^T where U is upper triangular and
 * D symmetric and block diagonal (aka spectral decomposition,
 * Banachiewicz factorization, modified Cholesky factorization)
 *
 * A is mxm, b is mx1. Argument iscolmaj specifies whether A is
 * stored in column or row major order. Note that if iscolmaj==1
 * this function modifies A!
 *
 * The function returns 0 in case of error,
 * 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_BK(double *A, double *B, double *x, long int iM, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;

ptrdiff_t a_sz, ipiv_sz, work_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t m, info, *ipiv, nrhs=1;
double *a, *work;
   
printf("sba_Axb_BK\n");
m=iM;

    if(A==NULL){
      if(buf) mxFree(buf);
      buf=NULL;
      buf_sz=0;

      return 1;
    }

    /* calculate required memory size */
    ipiv_sz=m;
    a_sz=(iscolmaj)? 0 : m*m;
    if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
      double tmp;

      work_sz=-1; // workspace query; optimal size is returned in tmp
      FORTRAN_WRAPPER(dsytrf)("U", &m, NULL, &m, NULL, (double *)&tmp, &work_sz, &info);
      nb=((long int)tmp)/m; // optimal worksize is m*nb
#else
      nb=-1; // min worksize is 1
#endif /* SBA_LS_SCARCE_MEMORY */
    }
    work_sz=(nb!=-1)? nb*m : 1;
    tot_sz=(a_sz + work_sz)*sizeof(double) + ipiv_sz*sizeof(int); /* should be arranged in that order for proper doubles alignment */

    if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
      if(buf) mxFree(buf); /* free previously allocated memory */

      buf_sz=tot_sz;
      buf=(double *)emalloc(buf_sz);
      if(!buf){
        fprintf(stderr, "memory allocation in sba_Axb_BK() failed!\n");
        return 0;
      }
    }

    if(!iscolmaj){
      a=buf;
    	work=a+a_sz;

      /* store A into a and B into x; A is assumed to be symmetric, hence
       * the column and row major order representations are the same
       */
      for(i=0; i<m; ++i){
        a[i]=A[i];
        x[i]=B[i];
      }
      for(j=m*m; i<j; ++i) // copy remaining rows; note that i is not re-initialized
        a[i]=A[i];
    }
    else{ /* no copying is necessary for A */
      a=A;
      for(i=0; i<m; ++i)
        x[i]=B[i];
      work=buf;
    }
    ipiv=(ptrdiff_t *)(work+work_sz);

  /* factorization for A */
	FORTRAN_WRAPPER(dsytrf)("U", &m, a, &m, ipiv, work, &work_sz, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dsytrf illegal in sba_Axb_BK()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular block diagonal matrix D for dsytrf in sba_Axb_BK() [D(%d, %d) is zero]\n", info, info);
			return 0;
		}
	}

  /* solve the system with the computed factorization */
  FORTRAN_WRAPPER(dsytrs)("U", &m, &nrhs, a, &m, ipiv, x, &m, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dsytrs illegal in sba_Axb_BK()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "unknown error for dsytrs in sba_Axb_BK()\n");
			return 0;
		}
	}

	return 1;
}

/*
 * This function computes the inverse of a square matrix whose upper triangle
 * is stored in A into its lower triangle using LU decomposition
 *
 * The function returns 0 in case of error (e.g. A is singular),
 * 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_symat_invert_LU(double *A, long int iM)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;

ptrdiff_t a_sz, ipiv_sz, work_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t m, info, *ipiv;
double *a, *work;
printf("sba_symat_invert_LU\n");
m=iM;
  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate required memory size */
  ipiv_sz=m;
  a_sz=m*m;
  if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
    double tmp;

    work_sz=-1; // workspace query; optimal size is returned in tmp
    FORTRAN_WRAPPER(dgetri)(&m, NULL, &m, NULL, (double *)&tmp, &work_sz, &info);
    nb=((long int)tmp)/m; // optimal worksize is m*nb
#else
    nb=1; // min worksize is m
#endif /* SBA_LS_SCARCE_MEMORY */
  }
  work_sz=nb*m;
  tot_sz=(a_sz + work_sz)*sizeof(double) + ipiv_sz*sizeof(int); /* should be arranged in that order for proper doubles alignment */

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz);
    if(!buf){
      fprintf(stderr, "memory allocation in sba_symat_invert_LU() failed!\n");
      return 0;
    }
  }

  a=buf;
  work=a+a_sz;
  ipiv=(ptrdiff_t *)(work+work_sz);

  /* store A (column major!) into a */
	for(i=0; i<m; ++i)
		for(j=i; j<m; ++j)
			a[i+j*m]=a[j+i*m]=A[i*m+j]; // copy A's upper part to a's upper & lower

  /* LU decomposition for A */
	FORTRAN_WRAPPER(dgetrf)(&m, &m, a, &m, ipiv, &info);  
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetrf illegal in sba_symat_invert_LU()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular matrix A for dgetrf in sba_symat_invert_LU()\n");
			return 0;
		}
	}

  /* (A)^{-1} from LU */
	FORTRAN_WRAPPER(dgetri)(&m, a, &m, ipiv, work, &work_sz, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetri illegal in sba_symat_invert_LU()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular matrix A for dgetri in sba_symat_invert_LU()\n");
			return 0;
		}
	}

	/* store (A)^{-1} in A's lower triangle */
	for(i=0; i<m; ++i)
		for(j=0; j<=i; ++j)
      A[i*m+j]=a[i+j*m];

	return 1;
}

/*
 * This function computes the inverse of a square symmetric positive definite 
 * matrix whose upper triangle is stored in A into its lower triangle using
 * Cholesky factorization
 *
 * The function returns 0 in case of error (e.g. A is not positive definite or singular),
 * 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_symat_invert_Chol(double *A, long int iM)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0;

ptrdiff_t a_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t m, info;
double *a;
printf("sba_symat_invert_Chol\n");
m=iM;

  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate required memory size */
  a_sz=m*m;
  tot_sz=a_sz; 

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz*sizeof(double));
    if(!buf){
      fprintf(stderr, "memory allocation in sba_symat_invert_Chol() failed!\n");
      return 0;
    }
  }

  a=(double *)buf;

  /* store A into a; A is assumed symmetric, hence no transposition is needed */
  for(i=0, j=a_sz; i<j; ++i)
    a[i]=A[i];

  /* Cholesky factorization for A; a's lower part corresponds to A's upper */
  //FORTRAN_WRAPPER(dpotrf)("L", (long int *)&m, a, (long int *)&m, (long int *)&info);
  FORTRAN_WRAPPER(dpotf2)("L", &m, a, &m, &info);
  /* error treatment */
  if(info!=0){
    if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dpotrf in sba_symat_invert_Chol()\n", -info);
      return 0;
    }
    else{
      fprintf(stderr, "LAPACK error: the leading minor of order %d is not positive definite,\nthe factorization could not be completed for dpotrf in sba_symat_invert_Chol()\n", info);
      return 0;
    }
  }

  /* (A)^{-1} from Cholesky */
  FORTRAN_WRAPPER(dpotri)("L", &m, a, &m, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dpotri illegal in sba_symat_invert_Chol()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "the (%d, %d) element of the factor U or L is zero, singular matrix A for dpotri in sba_symat_invert_Chol()\n", info, info);
			return 0;
		}
	}

	/* store (A)^{-1} in A's lower triangle. The lower triangle of the symmetric A^{-1} is in the lower triangle of a */
	for(i=0; i<m; ++i)
		for(j=0; j<=i; ++j)
      A[i*m+j]=a[i+j*m];

	return 1;
}

/*
 * This function computes the inverse of a symmetric indefinite 
 * matrix whose upper triangle is stored in A into its lower triangle
 * using LDLT factorization with the pivoting strategy of Bunch and Kaufman
 *
 * The function returns 0 in case of error (e.g. A is singular),
 * 1 if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_symat_invert_BK(double *A, long int iM)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;

ptrdiff_t a_sz, ipiv_sz, work_sz, tot_sz;
register ptrdiff_t i, j;
ptrdiff_t m, info, *ipiv;
double *a, *work;
//printf("sba_symat_invert_BK\n");
//printf("%d\n", sizeof(long int));
m=iM;
   
  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate required memory size */
  ipiv_sz=m;
  a_sz=m*m;
  if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
    double tmp;

    work_sz=-1; // workspace query; optimal size is returned in tmp
    FORTRAN_WRAPPER(dsytrf)("L", &m, NULL, &m, NULL, (double *)&tmp, &work_sz, &info);
    nb=((long int)tmp)/m; // optimal worksize is m*nb
#else
    nb=-1; // min worksize is 1
#endif /* SBA_LS_SCARCE_MEMORY */
  }
  work_sz=(nb!=-1)? nb*m : 1;
  work_sz=(work_sz>=m)? work_sz : m; /* ensure that work is at least m elements long, as required by dsytri */
  tot_sz=(a_sz + work_sz)*sizeof(double) + ipiv_sz*sizeof(int); /* should be arranged in that order for proper doubles alignment */

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz);
    if(!buf){
      fprintf(stderr, "memory allocation in sba_symat_invert_BK() failed!\n");
      return 0;
    }
  }

  a=buf;
  work=a+a_sz;
  ipiv=(ptrdiff_t *)(work+work_sz);

  /* store A into a; A is assumed symmetric, hence no transposition is needed */
  for(i=0, j=a_sz; i<j; ++i)
    a[i]=A[i];

  /* LDLT factorization for A; a's lower part corresponds to A's upper */
	FORTRAN_WRAPPER(dsytrf)("L", &m, a, &m, ipiv, work, &work_sz, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dsytrf illegal in sba_symat_invert_BK()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular block diagonal matrix D for dsytrf in sba_symat_invert_BK() [D(%d, %d) is zero]\n", info, info);
			return 0;
		}
	}

  /* (A)^{-1} from LDLT */
  FORTRAN_WRAPPER(dsytri)("L", &m, a, &m, ipiv, work, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dsytri illegal in sba_symat_invert_BK()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "D(%d, %d)=0, matrix is singular and its inverse could not be computed in sba_symat_invert_BK()\n", info, info);
			return 0;
		}
	}

	/* store (A)^{-1} in A's lower triangle. The lower triangle of the symmetric A^{-1} is in the lower triangle of a */
	for(i=0; i<m; ++i)
		for(j=0; j<=i; ++j)
      A[i*m+j]=a[i+j*m];

	return 1;
}


#define __CG_LINALG_BLOCKSIZE           8

/* Dot product of two vectors x and y using loop unrolling and blocking.
 * see http://www.abarnett.demon.co.uk/tutorial.html
 */

inline static double dprod(const long int n, const double *const x, const double *const y)
{
register long int i, j1, j2, j3, j4, j5, j6, j7; 
long int blockn;
register double sum0=0.0, sum1=0.0, sum2=0.0, sum3=0.0,
                sum4=0.0, sum5=0.0, sum6=0.0, sum7=0.0;
printf("dprod\n");

  /* n may not be divisible by __CG_LINALG_BLOCKSIZE, 
  * go as near as we can first, then tidy up.
  */ 
  blockn = (n / __CG_LINALG_BLOCKSIZE) * __CG_LINALG_BLOCKSIZE; 

  /* unroll the loop in blocks of `__CG_LINALG_BLOCKSIZE' */ 
  for(i=0; i<blockn; i+=__CG_LINALG_BLOCKSIZE){
            sum0+=x[i]*y[i];
    j1=i+1; sum1+=x[j1]*y[j1];
    j2=i+2; sum2+=x[j2]*y[j2];
    j3=i+3; sum3+=x[j3]*y[j3];
    j4=i+4; sum4+=x[j4]*y[j4];
    j5=i+5; sum5+=x[j5]*y[j5];
    j6=i+6; sum6+=x[j6]*y[j6];
    j7=i+7; sum7+=x[j7]*y[j7];
  } 

 /* 
  * There may be some left to do.
  * This could be done as a simple for() loop, 
  * but a switch is faster (and more interesting) 
  */ 

  if(i<n){ 
    /* Jump into the case at the place that will allow
    * us to finish off the appropriate number of items. 
    */ 

    switch(n - i){ 
      case 7 : sum0+=x[i]*y[i]; ++i;
      case 6 : sum1+=x[i]*y[i]; ++i;
      case 5 : sum2+=x[i]*y[i]; ++i;
      case 4 : sum3+=x[i]*y[i]; ++i;
      case 3 : sum4+=x[i]*y[i]; ++i;
      case 2 : sum5+=x[i]*y[i]; ++i;
      case 1 : sum6+=x[i]*y[i]; ++i;
    }
  } 

  return sum0+sum1+sum2+sum3+sum4+sum5+sum6+sum7;
}


/* Compute z=x+a*y for two vectors x and y and a scalar a; z can be one of x, y.
 * Similarly to the dot product routine, this one uses loop unrolling and blocking
 */

inline static void daxpy(const long int n, double *const z, const double *const x, const double a, const double *const y)
{ 
register long int i, j1, j2, j3, j4, j5, j6, j7; 
long int blockn;
printf("daxpy\n");

  /* n may not be divisible by __CG_LINALG_BLOCKSIZE, 
  * go as near as we can first, then tidy up.
  */ 
  blockn = (n / __CG_LINALG_BLOCKSIZE) * __CG_LINALG_BLOCKSIZE; 

  /* unroll the loop in blocks of `__CG_LINALG_BLOCKSIZE' */ 
  for(i=0; i<blockn; i+=__CG_LINALG_BLOCKSIZE){
            z[i]=x[i]+a*y[i];
    j1=i+1; z[j1]=x[j1]+a*y[j1];
    j2=i+2; z[j2]=x[j2]+a*y[j2];
    j3=i+3; z[j3]=x[j3]+a*y[j3];
    j4=i+4; z[j4]=x[j4]+a*y[j4];
    j5=i+5; z[j5]=x[j5]+a*y[j5];
    j6=i+6; z[j6]=x[j6]+a*y[j6];
    j7=i+7; z[j7]=x[j7]+a*y[j7];
  } 

 /* 
  * There may be some left to do.
  * This could be done as a simple for() loop, 
  * but a switch is faster (and more interesting) 
  */ 

  if(i<n){ 
    /* Jump into the case at the place that will allow
    * us to finish off the appropriate number of items. 
    */ 

    switch(n - i){ 
      case 7 : z[i]=x[i]+a*y[i]; ++i;
      case 6 : z[i]=x[i]+a*y[i]; ++i;
      case 5 : z[i]=x[i]+a*y[i]; ++i;
      case 4 : z[i]=x[i]+a*y[i]; ++i;
      case 3 : z[i]=x[i]+a*y[i]; ++i;
      case 2 : z[i]=x[i]+a*y[i]; ++i;
      case 1 : z[i]=x[i]+a*y[i]; ++i;
    }
  } 
}

/*
 * This function returns the solution of Ax = b where A is posititive definite,
 * based on the conjugate gradients method; see "An intro to the CG method" by J.R. Shewchuk, p. 50-51
 *
 * A is mxm, b, x are is mx1. Argument niter specifies the maximum number of 
 * iterations and eps is the desired solution accuracy. niter<0 signals that
 * x contains a valid initial approximation to the solution; if niter>0 then 
 * the starting point is taken to be zero. Argument prec selects the desired
 * preconditioning method as follows:
 * 0: no preconditioning
 * 1: jacobi (diagonal) preconditioning
 * 2: SSOR preconditioning
 * Argument iscolmaj specifies whether A is stored in column or row major order.
 *
 * The function returns 0 in case of error,
 * the number of iterations performed if successfull
 *
 * This function is often called repetitively to solve problems of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 */
long int sba_Axb_CG(double *A, double *B, double *x, long int m, long int niter, double eps, long int prec, long int iscolmaj)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0;

register long int i, j;
register double *aim;
long int iter, a_sz, res_sz, d_sz, q_sz, s_sz, wk_sz, z_sz, tot_sz;
double *a, *res, *d, *q, *s, *wk, *z;
double delta0, deltaold, deltanew, alpha, beta, eps_sq=eps*eps;
register double sum;
long int rec_res;
printf("sba_Axb_CG\n");

  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate required memory size */
  a_sz=(iscolmaj)? m*m : 0;
	res_sz=m; d_sz=m; q_sz=m;
  if(prec!=SBA_CG_NOPREC){
    s_sz=m; wk_sz=m;
    z_sz=(prec==SBA_CG_SSOR)? m : 0;
  }
  else
    s_sz=wk_sz=z_sz=0;
 
	tot_sz=a_sz+res_sz+d_sz+q_sz+s_sz+wk_sz+z_sz;

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz*sizeof(double));
    if(!buf){
		  fprintf(stderr, "memory allocation request failed in sba_Axb_CG()\n");
		  return 0;
	  }
  }

  if(iscolmaj){ 
    a=buf;
    /* store A (row major!) into a */
    for(i=0; i<m; ++i)
      for(j=0, aim=a+i*m; j<m; ++j)
        aim[j]=A[i+j*m];
  }
  else a=A; /* no copying required */

	res=buf+a_sz;
	d=res+res_sz;
	q=d+d_sz;
  if(prec!=SBA_CG_NOPREC){
	  s=q+q_sz;
    wk=s+s_sz;
    z=(prec==SBA_CG_SSOR)? wk+wk_sz : NULL;

    for(i=0; i<m; ++i){ // compute jacobi (i.e. diagonal) preconditioners and save them in wk
      sum=a[i*m+i];
      if(sum>DBL_EPSILON || -sum<-DBL_EPSILON) // != 0.0
        wk[i]=1.0/sum;
      else
        wk[i]=1.0/DBL_EPSILON;
    }
  }
  else{
    s=res;
    wk=z=NULL;
  }

  if(niter>0){
	  for(i=0; i<m; ++i){ // clear solution and initialize residual vector:  res <-- B
		  x[i]=0.0;
      res[i]=B[i];
    }
  }
  else{
    niter=-niter;

	  for(i=0; i<m; ++i){ // initialize residual vector:  res <-- B - A*x
      for(j=0, aim=a+i*m, sum=0.0; j<m; ++j)
        sum+=aim[j]*x[j];
      res[i]=B[i]-sum;
    }
  }

  switch(prec){
    case SBA_CG_NOPREC:
      for(i=0, deltanew=0.0; i<m; ++i){
        d[i]=res[i];
        deltanew+=res[i]*res[i];
      }
      break;
    case SBA_CG_JACOBI: // jacobi preconditioning
      for(i=0, deltanew=0.0; i<m; ++i){
        d[i]=res[i]*wk[i];
        deltanew+=res[i]*d[i];
      }
      break;
    case SBA_CG_SSOR: // SSOR preconditioning; see the "templates" book, fig. 3.2, p. 44
      for(i=0; i<m; ++i){
        for(j=0, sum=0.0, aim=a+i*m; j<i; ++j)
          sum+=aim[j]*z[j];
        z[i]=wk[i]*(res[i]-sum);
      }

      for(i=m-1; i>=0; --i){
        for(j=i+1, sum=0.0, aim=a+i*m; j<m; ++j)
          sum+=aim[j]*d[j];
        d[i]=z[i]-wk[i]*sum;
      }
      deltanew=dprod(m, res, d);
      break;
    default:
      fprintf(stderr, "unknown preconditioning option %d in sba_Axb_CG\n", prec);
      return 0;
  }

  delta0=deltanew;

	for(iter=1; deltanew>eps_sq*delta0 && iter<=niter; ++iter){
    for(i=0; i<m; ++i){ // q <-- A d
      aim=a+i*m;
/***
      for(j=0, sum=0.0; j<m; ++j)
        sum+=aim[j]*d[j];
***/
      q[i]=dprod(m, aim, d); //sum;
    }

/***
    for(i=0, sum=0.0; i<m; ++i)
      sum+=d[i]*q[i];
***/
    alpha=deltanew/dprod(m, d, q); // deltanew/sum;

/***
    for(i=0; i<m; ++i)
      x[i]+=alpha*d[i];
***/
    daxpy(m, x, x, alpha, d);

    if(!(iter%50)){
	    for(i=0; i<m; ++i){ // accurate computation of the residual vector
        aim=a+i*m;
/***
        for(j=0, sum=0.0; j<m; ++j)
          sum+=aim[j]*x[j];
***/
        res[i]=B[i]-dprod(m, aim, x); //B[i]-sum;
      }
      rec_res=0;
    }
    else{
/***
	    for(i=0; i<m; ++i) // approximate computation of the residual vector
        res[i]-=alpha*q[i];
***/
      daxpy(m, res, res, -alpha, q);
      rec_res=1;
    }

    if(prec){
      switch(prec){
      case SBA_CG_JACOBI: // jacobi
        for(i=0; i<m; ++i)
          s[i]=res[i]*wk[i];
        break;
      case SBA_CG_SSOR: // SSOR
        for(i=0; i<m; ++i){
          for(j=0, sum=0.0, aim=a+i*m; j<i; ++j)
            sum+=aim[j]*z[j];
          z[i]=wk[i]*(res[i]-sum);
        }

        for(i=m-1; i>=0; --i){
          for(j=i+1, sum=0.0, aim=a+i*m; j<m; ++j)
            sum+=aim[j]*s[j];
          s[i]=z[i]-wk[i]*sum;
        }
        break;
      }
    }

    deltaold=deltanew;
/***
	  for(i=0, sum=0.0; i<m; ++i)
      sum+=res[i]*s[i];
***/
    deltanew=dprod(m, res, s); //sum;

    /* make sure that we get around small delta that are due to
     * accumulated floating point roundoff errors
     */
    if(rec_res && deltanew<=eps_sq*delta0){
      /* analytically recompute delta */
	    for(i=0; i<m; ++i){
        for(j=0, aim=a+i*m, sum=0.0; j<m; ++j)
          sum+=aim[j]*x[j];
        res[i]=B[i]-sum;
      }
      deltanew=dprod(m, res, s);
    }

    beta=deltanew/deltaold;

/***
	  for(i=0; i<m; ++i)
      d[i]=s[i]+beta*d[i];
***/
    daxpy(m, d, s, beta, d);
  }

	return iter;
}

/*
 * This function computes the Cholesky decomposition of the inverse of a symmetric
 * (covariance) matrix A into B, i.e. B is s.t. A^-1=B^t*B and B upper triangular.
 * A and B can coincide
 *
 * The function returns 0 in case of error (e.g. A is singular),
 * 1 if successfull
 *
 * This function is often called repetitively to operate on matrices of identical
 * dimensions. To avoid repetitive malloc's and free's, allocated memory is
 * retained between calls and free'd-malloc'ed when not of the appropriate size.
 * A call with NULL as the first argument forces this memory to be released.
 *
 */
#if 0
long int sba_mat_cholinv(double *A, double *B, long int iM)
{
static double *buf=NULL;
static ptrdiff_t buf_sz=0, nb=0;

ptrdiff_t m, a_sz, ipiv_sz, work_sz, tot_sz;
register long int i, j;
long int info, *ipiv;
double *a, *work;
m = iM;
printf("sba_mat_cholinv\n");
   
  if(A==NULL){
    if(buf) mxFree(buf);
    buf=NULL;
    buf_sz=0;

    return 1;
  }

  /* calculate the required memory size */
  ipiv_sz=m;
  a_sz=m*m;
  if(!nb){
#ifndef SBA_LS_SCARCE_MEMORY
    double tmp;

    work_sz=-1; // workspace query; optimal size is returned in tmp
    FORTRAN_WRAPPER(dgetri)(&m, NULL, &m, NULL, &tmp, &work_sz, &info);
    nb=((long int)tmp)/m; // optimal worksize is m*nb
#else
    nb=1; // min worksize is m
#endif /* SBA_LS_SCARCE_MEMORY */
  }
  work_sz=nb*m;
  tot_sz=(a_sz + work_sz)*sizeof(double) + ipiv_sz*sizeof(long int); /* should be arranged in that order for proper doubles alignment */

  if(tot_sz>buf_sz){ /* insufficient memory, allocate a "big" memory chunk at once */
    if(buf) mxFree(buf); /* free previously allocated memory */

    buf_sz=tot_sz;
    buf=(double *)emalloc(buf_sz);
    if(!buf){
      fprintf(stderr, "memory allocation in sba_mat_cholinv() failed!\n");
      return 0;
    }
  }

  a=buf;
  work=a+a_sz;
  ipiv=(long int *)(work+work_sz);

  /* step 1: invert A */
  /* store A into a; A is assumed symmetric, hence no transposition is needed */
  for(i=0; i<m*m; ++i)
    a[i]=A[i];

  /* LU decomposition for A (Cholesky should also do) */
	FORTRAN_WRAPPER(dgetf2)(&m, &m, a, &m, ipiv, &info);  
	//FORTRAN_WRAPPER(dgetrf)((long int *)&m, (long int *)&m, a, (long int *)&m, ipiv, (long int *)&info);  
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetf2/dgetrf illegal in sba_mat_cholinv()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular matrix A for dgetf2/dgetrf in sba_mat_cholinv()\n");
			return 0;
		}
	}

  /* (A)^{-1} from LU */
	FORTRAN_WRAPPER(dgetri)(&m, a, &m, ipiv, work, &work_sz, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dgetri illegal in sba_mat_cholinv()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "singular matrix A for dgetri in sba_mat_cholinv()\n");
			return 0;
		}
	}

  /* (A)^{-1} is now in a (in column major!) */

  /* step 2: Cholesky decomposition of a: A^-1=B^t B, B upper triangular */
  FORTRAN_WRAPPER(dpotf2)("U", &m, a, &m, &info);
  /* error treatment */
  if(info!=0){
		if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dpotf2 in sba_mat_cholinv()\n", -info);
		  return 0;
		}
		else{
			fprintf(stderr, "LAPACK error: the leading minor of order %d is not positive definite,\n%s\n", info,
						  "and the Cholesky factorization could not be completed in sba_mat_cholinv()");
			return 0;
		}
  }

  /* the decomposition is in the upper part of a (in column-major order!).
   * copying it to the lower part and zeroing the upper transposes
   * a in row-major order
   */
  for(i=0; i<m; ++i)
    for(j=0; j<i; ++j){
      a[i+j*m]=a[j+i*m];
      a[j+i*m]=0.0;
    }
  for(i=0; i<m*m; ++i)
    B[i]=a[i];

	return 1;
}
#endif

long int sba_mat_cholinv(double *A, double *B, long int iM)
{
ptrdiff_t a_sz;
register long int i, j;
ptrdiff_t m, info;
double *a;
printf("sba_mat_cholinv\n");
m=iM;
   
  if(A==NULL){
    return 1;
  }

  a_sz=m*m;
  a=B; /* use B as working memory, result is produced in it */

  /* step 1: invert A */
  /* store A into a; A is assumed symmetric, hence no transposition is needed */
  for(i=0; i<a_sz; ++i)
    a[i]=A[i];

  /* Cholesky decomposition for A */
  FORTRAN_WRAPPER(dpotf2)("U", &m, a, &m, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dpotf2 illegal in sba_mat_cholinv()\n", -info);
			return 0;
		}
		else{
			fprintf(stderr, "LAPACK error: the leading minor of order %d is not positive definite,\n%s\n", info,
						  "and the Cholesky factorization could not be completed in sba_mat_cholinv()");
			return 0;
		}
	}

  /* (A)^{-1} from Cholesky */
	FORTRAN_WRAPPER(dpotri)("U", &m, a, &m, &info);
	if(info!=0){
		if(info<0){
			fprintf(stderr, "argument %d of dpotri illegal in sba_mat_cholinv()\n", -info);
			return 0;
		}
		else{
      fprintf(stderr, "the (%d, %d) element of the factor U or L is zero, singular matrix A for dpotri in sba_mat_cholinv()\n", info, info);
			return 0;
		}
	}

  /* (A)^{-1} is now in a (in column major!) */

  /* step 2: Cholesky decomposition of a: A^-1=B^t B, B upper triangular */
  FORTRAN_WRAPPER(dpotf2)("U", &m, a, &m, &info);
  /* error treatment */
  if(info!=0){
		if(info<0){
      fprintf(stderr, "LAPACK error: illegal value for argument %d of dpotf2 in sba_mat_cholinv()\n", -info);
		  return 0;
		}
		else{
			fprintf(stderr, "LAPACK error: the leading minor of order %d is not positive definite,\n%s\n", info,
						  "and the Cholesky factorization could not be completed in sba_mat_cholinv()");
			return 0;
		}
  }

  /* the decomposition is in the upper part of a (in column-major order!).
   * copying it to the lower part and zeroing the upper transposes
   * a in row-major order
   */
  for(i=0; i<m; ++i)
    for(j=0; j<i; ++j){
      a[i+j*m]=a[j+i*m];
      a[j+i*m]=0.0;
    }

	return 1;
}
