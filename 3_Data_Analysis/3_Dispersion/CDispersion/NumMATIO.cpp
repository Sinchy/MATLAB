/*
 * NumMATIO.cpp
 *
 *  Created on: Jul 8, 2020
 *      Author: stan26
 */

#include <iostream>
#include "NumMATIO.h"
#include "mat.h"

using namespace std;

int NumMATIO::WriteData(vector<vector<int>> data) {
	MATFile* pmat = matOpen(m_file_path, "w");

	int rows = data.size();
	if (rows == 0) {
		return 1; // no data to save
	}
	int cols = data[0].size();

	mxArray* pa = mxCreateDoubleMatrix(rows, cols, mxREAL);

	double* ddata = new double[rows * cols];

	for (int j = 0; j < cols; ++j)
		for (int i = 0; i < rows; ++i)
			ddata[j * rows + i] = data[i][j];  // column first

	memcpy((void*)(mxGetPr(pa)), (void*)ddata, rows * cols * sizeof(double));

	matPutVariableAsGlobal(pmat, m_varname, pa); // save pairs

	mxDestroyArray(pa);
	matClose(pmat);
	return 0;
}

int NumMATIO::WriteData(vector<vector<double>> data) {
	MATFile* pmat = matOpen(m_file_path, "w");

	int rows = data.size();
	if (rows == 0) {
		return 1; // no data to save
	}
	int cols = data[0].size();

	mxArray* pa = mxCreateDoubleMatrix(rows, cols, mxREAL);

	double* ddata = new double[rows * cols];

	for (int j = 0; j < cols; ++j)
		for (int i = 0; i < rows; ++i)
			ddata[j * rows + i] = data[i][j];  // column first

	memcpy((void*)(mxGetPr(pa)), (void*)ddata, rows * cols * sizeof(double));

	matPutVariableAsGlobal(pmat, m_varname, pa); // save pairs

	mxDestroyArray(pa);
	matClose(pmat);
	return 0;
}

int NumMATIO::ReadData(mxDouble*& data, vector<int>& dim) { // change int to mwSize
	MATFile* pmat = matOpen(m_file_path, "r");
	if (pmat == NULL) {
		cout << "Could not read files." << endl;
		return 1;
	}

	mxArray* arr = matGetVariable(pmat, m_varname);
	if (arr == NULL) {
		cout << "No data is read." << endl;
	}
	int num_dim = mxGetNumberOfDimensions(arr); // dimension of the array
//	const mwSize *dim_num = mxGetDimensions(arr); // dimension
//
//	dim = new int[num_dim];
//	for (int i = 0; i < num_dim; ++i) {
//		dim[i] = dim_num[i];
//	}

//	int num_dim = mxGetNumberOfDimensions(arr); // dimension of the array
	const mwSize* dim_num = mxGetDimensions(arr); // dimension

	dim.assign(dim_num, dim_num + num_dim);

	//	data = new mxDouble[dim[0] * dim[1]];
	//	data = (mxDouble*) calloc(dim[0] * dim[1], sizeof(mxDouble));
	data = mxGetDoubles(arr);

	//	int num_element = mxGetNumberOfElements(arr);
	//	data.reserve(num_element);
	//	data.assign(arr_num, arr_num + num_element);

	//	switch(num_dim) {
	//	case 0:
	//		cout<<"Nothing in the array!"<<endl;
	//		return 1;
	//		break;
	//	case 1:
	//		data = new double[dim[0]];
	//		for (int i = 0; i < dim[0]; ++i)
	//			data[i] = arr_num[i];
	//		break;
	//	case 2:
	//		data = new double[dim[0]];
	//		for (int i = 0; i < dim[0]; ++i)
	//			data[i] = new double[dim[1]];
	//		for (int i = 0; i < dim[0]; ++i)
	//			for (int j = 0; j < dim[1]; ++j)
	//				data[i][j] = arr_num[i + j * dim[0]];
	//		break;
	//		// can be extend to higher dimension
	//	default:
	//		cout<<"Higher dimension is not available."<<endl;
	//		return 1;
	//		break;
	//	}

	matClose(pmat);
	//	delete pmat;
	//	delete arr;
	//	delete arr_num;
	return 0;

}

void NumMATIO::GetDimension(vector<mwSize>& dim) {
	MATFile* pmat = matOpen(m_file_path, "r");
	if (pmat == NULL) {
		cout << "Could not read files." << endl;
	}

	mxArray* arr = matGetVariable(pmat, m_varname);
	if (arr == NULL) {
		cout << "No data is read." << endl;
	}
	int num_dim = mxGetNumberOfDimensions(arr); // dimension of the array
	const mwSize* dim_num = mxGetDimensions(arr); // dimension

//	vector<mwSize> dim;
	dim.assign(dim_num, dim_num + num_dim);

	matClose(pmat);
	//
	//	return dim;
}


