#ifndef ARRAY_H_
#define ARRAY_H_

#include <vector>
#include "mat.h"
using namespace std;

class Array {
public:
	Array(double* array, vector<int>& dim) { m_array = array; m_dim = dim; };
	~Array() {};

	double operator()(int row, int col) {
		//		-- row; //transform to C++ index
		//		-- col;
		return *(m_array + col * m_dim[0] + row);
	};

	void set(int row, int col, double value) { // write a value into an element of row and col
		*(m_array + col * m_dim[0] + row) = value;
	}

	vector<double> GetColumn(int col) {
		vector<double> data;
		data.reserve(m_dim[0]);
		data.assign(m_array + col * m_dim[0], m_array + col * m_dim[0] + m_dim[0]);
		return data;
	}

	// get the index of the elements in col column which equal to value.
	vector<int> GetElementRowIndex(double value, int col) {
		vector<int> index;


		for (int i = 0; i < m_dim[0]; ++i) {
			if (*(m_array + col * m_dim[0] + i) == value)
				index.push_back(i);
		}
		return index;
	}

	// get the element in column at specific rows.
	vector<double> GetElement_RowsCol(vector<int> rows, int col) {
		vector<double> elements;
		for (int i = 0; i < rows.size(); ++i) {
			elements.push_back(*(m_array + col * m_dim[0] + rows[i]));
		}
		return elements;
	}

private:
	double* m_array; // 2 dimension array
	vector<int> m_dim; // dimension
};

#endif
