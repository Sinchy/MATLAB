% 
%  MATLAB Makefile for MATLAB interface to sba
% 

% MEXCFLAGS= -O -largeArrayDims  
% SBASRCS=sba_chkjac.c sba_crsm.c sba_lapack.c sba_levmar.c sba_levmar_wrap.c
% MEXSRCS=easySBA_mex.c;
% LAPACKLIBS=libmwblas.lib libmwlapack.lib

% windows
if ispc & ~isunix
  mex -O -largeArrayDims easySBA_mex.c sba_chkjac.c sba_crsm.c sba_lapack.c sba_levmar.c sba_levmar_wrap.c libmwblas.lib libmwlapack.lib
end

% linux & macos
if isunix
  mex -O -largeArrayDims easySBA_mex.c sba_chkjac.c sba_crsm.c sba_lapack.c sba_levmar.c sba_levmar_wrap.c -lmwblas -lmwlapack
end

