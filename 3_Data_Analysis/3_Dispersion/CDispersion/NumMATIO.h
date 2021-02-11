#ifndef NUMMATIO_H_
#define NUMMATIO_H_

#include <vector>
#include "mat.h"  //include the inc files, lib files, and set path in environment variable for dll files
using namespace std;

class NumMATIO {
public:
    NumMATIO() {};
    ~NumMATIO() {};

    int WriteData(vector<vector<int>> data);
    int WriteData(vector<vector<double>> data);

    int ReadData(mxDouble*& data, vector<int>& dim); // get the data and its dimension


    void GetDimension(vector<mwSize>& dim);

    void SetFilePath(const char* file_path)
    {
        m_file_path = file_path;
    };

    void SetVarName(const char* varname)
    {
        m_varname = varname;
    };

private:
    const char* m_file_path;
    const char* m_varname;  // the name of variable to be obtained.
};

#endif
