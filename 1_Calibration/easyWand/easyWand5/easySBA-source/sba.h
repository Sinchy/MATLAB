/*
/////////////////////////////////////////////////////////////////////////////////
//// 
////  Prototypes and definitions for sparse bundle adjustment
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
*/

#ifndef _SBA_H_
#define _SBA_H_

/**************************** Start of configuration options ****************************/

/* define the following if a trailing underscore should be appended to lapack functions names */
/* #define SBA_APPEND_UNDERSCORE_SUFFIX // undef this for AIX


/* define this to make linear solver routines use the minimum amount of memory
 * possible. This lowers the memory requirements of large BA problems but will
 * most likely induce a penalty on performance
 */
/*#define SBA_LS_SCARCE_MEMORY */


/* define this to save some memory by storing the weight matrices for the image
 * projections (i.e. wght in the expert drivers) into the memory containing their
 * covariances (i.e. covx arg). Note that this overwrites covx, making changes
 * noticeable by the caller
 */
/*#define SBA_DESTROY_COVS */


/********* End of configuration options, no changes necessary beyond this point *********/

#ifdef __cplusplus
extern "C" {
#endif

#include <mex.h>

#define SBA_MIN_DELTA     1E-06 // finite differentiation minimum delta
#define SBA_DELTA_SCALE   1E-04 // finite differentiation delta scale

#define SBA_OPTSSZ        5
#define SBA_INFOSZ        10
#define SBA_ERROR         -1
#define SBA_INIT_MU       1E-03
#define SBA_STOP_THRESH   1E-12
#define SBA_CG_NOPREC     0
#define SBA_CG_JACOBI     1
#define SBA_CG_SSOR       2
#define SBA_VERSION       "1.6 (Aug. 2009)"


/* Sparse matrix representation using Compressed Row Storage (CRS) format.
 * See http://www.netlib.org/linalg/html_templates/node91.html#SECTION00931100000000000000
 */

struct sba_crsm{
    long int nr, nc;   /* #rows, #cols for the sparse matrix */
    long int nnz;      /* number of nonzero array elements */
    long int *val;     /* storage for nonzero array elements. size: nnz */
    long int *colidx;  /* column indexes of nonzero elements. size: nnz */
    long int *rowptr;  /* locations in val that start a row. size: nr+1.
                   * By convention, rowptr[nr]=nnz
                   */
};

/* sparse LM */

/* simple drivers */
extern long int
sba_motstr_levmar(const long int n, const long int ncon, const long int m, const long int mcon, char *vmask,
           double *p, const long int cnp, const long int pnp, double *x, double *covx, const long int mnp,
           void (*proj)(long int j, long int i, double *aj, double *bi, double *xij, void *adata),
           void (*projac)(long int j, long int i, double *aj, double *bi, double *Aij, double *Bij, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);

extern long int
sba_mot_levmar(const long int n, const long int m, const long int mcon, char *vmask, double *p, const long int cnp,
           double *x, double *covx, const long int mnp,
           void (*proj)(long int j, long int i, double *aj, double *xij, void *adata),
           void (*projac)(long int j, long int i, double *aj, double *Aij, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);

extern long int
sba_str_levmar(const long int n, const long int ncon, const long int m, char *vmask, double *p, const long int pnp,
           double *x, double *covx, const long int mnp,
           void (*proj)(long int j, long int i, double *bi, double *xij, void *adata),
           void (*projac)(long int j, long int i, double *bi, double *Bij, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);


/* expert drivers */
extern long int
sba_motstr_levmar_x(const long int n, const long int ncon, const long int m, const long int mcon, char *vmask, double *p,
           const long int cnp, const long int pnp, double *x, double *covx, const long int mnp,
           void (*func)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *hx, void *adata),
           void (*fjac)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *jac, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);

extern long int
sba_mot_levmar_x(const long int n, const long int m, const long int mcon, char *vmask, double *p, const long int cnp,
           double *x, double *covx, const long int mnp,
           void (*func)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *hx, void *adata),
           void (*fjac)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *jac, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);

extern long int
sba_str_levmar_x(const long int n, const long int ncon, const long int m, char *vmask, double *p, const long int pnp,
           double *x, double *covx, const long int mnp,
           void (*func)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *hx, void *adata),
           void (*fjac)(double *p, struct sba_crsm *idxij, long int *rcidxs, long int *rcsubs, double *jac, void *adata),
           void *adata, const long int itmax, const long int verbose, const double opts[SBA_OPTSSZ], double info[SBA_INFOSZ]);


/* interfaces to LAPACK routines: solution of linear systems, matrix inversion, cholesky of inverse */
extern long int sba_Axb_QR(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_QRnoQ(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_Chol(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_LDLt(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_LU(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_SVD(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_BK(double *A, double *B, double *x, long int m, long int iscolmaj);
extern long int sba_Axb_CG(double *A, double *B, double *x, long int m, long int niter, double eps, long int prec, long int iscolmaj);
extern long int sba_symat_invert_LU(double *A, long int m);
extern long int sba_symat_invert_Chol(double *A, long int m);
extern long int sba_symat_invert_BK(double *A, long int m);
extern long int sba_mat_cholinv(double *A, double *B, long int m);

/* CRS sparse matrices manipulation routines */
extern void sba_crsm_alloc(struct sba_crsm *sm, long int nr, long int nc, long int nnz);
extern void sba_crsm_free(struct sba_crsm *sm);
extern long int sba_crsm_elmidx(struct sba_crsm *sm, long int i, long int j);
extern long int sba_crsm_elmidxp(struct sba_crsm *sm, long int i, long int j, long int jp, long int jpidx);
extern long int sba_crsm_row_elmidxs(struct sba_crsm *sm, long int i, long int *vidxs, long int *jidxs);
extern long int sba_crsm_col_elmidxs(struct sba_crsm *sm, long int j, long int *vidxs, long int *iidxs);
/* extern long int sba_crsm_common_row(struct sba_crsm *sm, long int j, long int k); */

#ifdef __cplusplus
}
#endif

#endif /* _SBA_H_ */
