
#ifndef MATIO_H_
#define MATIO_H_

#include <string>

// This class is used to get the mat file into C++

template <class T> class MATIO {
public:
	MATIO();
	virtual ~MATIO();

	//virtual int WriteData(T* data) = 0;

	virtual int ReadData(T* data) = 0;

	void SetFilePath(char* file_path)
	{
		m_file_path = file_path;
	};

	void SetVarName(char* varname)
	{
		m_varname = varname;
	};

protected:
	const char* m_file_path;
	const char* m_varname;  // the name of variable to be obtained.
};

#endif /* MATIO_H_ */
