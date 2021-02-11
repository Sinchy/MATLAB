//============================================================================
// Name        : PairDispersion.cpp
// Author      : Shiyong Tan
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
// Note: Remember to add C:\Program Files\MATLAB\R2020a\bin\win64 to environment variable
//============================================================================

#include <iostream>
#include <chrono>
#include <omp.h>
#include <string.h>
#include <vector>
#include <algorithm>
#include <functional>
#include <cmath>
#include "NumMATIO.h"
#include "Array.h"
#include "progressbar.hpp"
#include <Windows.h>
using namespace std;

double VectorNorm(double x, double y, double z) {
	return sqrt(x * x + y * y + z * z);
}

vector<double> Vector2Dnorm(vector<double> X1, vector<double> Y1, vector<double> Z1,
	vector<double> X2, vector<double> Y2, vector<double> Z2) {
	vector<double> vector_norm;
	for (int i = 0; i < X1.size(); ++i) {
		vector_norm.push_back(VectorNorm(X1[i] - X2[i], Y1[i] - Y2[i], Z1[i] - Z2[i]));
	}
	return vector_norm;
}

//void sortrows(std::vector<std::vector<double>>& matrix, int col) {
//    std::sort(matrix.begin(),
//              matrix.end(),
//              [col](const std::vector<double>& lhs, const std::vector<double>& rhs) {
//                  return lhs[col] > rhs[col];
//              });
//}
//
//void transpose(vector<vector<double> >& matrix)
//{
//    if (matrix.size() == 0)
//        return;
//
//    vector<vector<double> > trans_vec(matrix[0].size(), vector<double>());
//
//    for (int i = 0; i < matrix.size(); i++)
//    {
//        for (int j = 0; j < matrix[i].size(); j++)
//        {
//            trans_vec[j].push_back(matrix[i][j]);
//        }
//    }
//
//    matrix = trans_vec;    // <--- reassign here
//}

void SavePairs(char* file_path, vector<vector<vector<int>>>& pairs) {
	// remove the file name in file_path

	string file_path_s(file_path);
	int pos = file_path_s.find_last_of("/\\");
	string save_path0 = file_path_s.substr(0, pos);
	//	cout<<save_path0<<endl;

	NumMATIO mat_io;
	mat_io.SetVarName("pairs");
	int num_gp = pairs.size();
	for (int i = 0; i < num_gp; ++i) {
		int num_rows = pairs[i].size();
		string save_path = save_path0 + "/\\pairs" + to_string(i) + ".mat";
		mat_io.SetFilePath((char*)save_path.c_str());
		mat_io.WriteData(pairs[i]);
	}
}

void SearchPairs(char* file_path) {
	// Read the track data from the .mat file
	NumMATIO mat_io;
	mat_io.SetFilePath(file_path);
	mat_io.SetVarName("tracks");
	vector<int> dim;
	double* data = NULL;
	mat_io.ReadData(data, dim);
	Array track(data, dim);

	//Read the bin information
	mat_io.SetVarName("bin");
	vector<int> bin_dim;
	double* bin_data = NULL;
	mat_io.ReadData(bin_data, bin_dim);
	Array bin(bin_data, bin_dim);

	//Read the minimun pair length
	mat_io.SetVarName("pair_len");
	vector<int> len_dim;
	double* len_data = NULL;
	mat_io.ReadData(len_data, len_dim);
	Array pair_len(len_data, len_dim);

	// Read track info
	mat_io.SetVarName("tr_info");
	vector<int> tr_info_dim;
	double* tr_info_data = NULL;
	mat_io.ReadData(tr_info_data, tr_info_dim);
	Array tr_info(tr_info_data, tr_info_dim);
	vector<double> trID;
	for (int i = 0; i < tr_info_dim[0]; ++i)
		trID.push_back(tr_info(i, 0));

	// Read frame info
	mat_io.SetVarName("frame_info");
	vector<int> frame_info_dim;
	double* frame_info_data = NULL;
	mat_io.ReadData(frame_info_data, frame_info_dim);
	Array frame_info(frame_info_data, frame_info_dim);

	//Obtain unique frame number
	vector<double> frameNo = track.GetColumn(3);

	std::sort(frameNo.begin(), frameNo.end());
	auto last = std::unique(frameNo.begin(), frameNo.end());
	frameNo.erase(last, frameNo.end());
	random_shuffle(frameNo.begin(), frameNo.end());

	////Obtain the end frame of each trajectory which is used to calculat the pair length
	//// NOTE: the track must be sorted according to the track ID.
	//vector<double> trID = track.GetColumn(4);
	//last = std::unique(trID.begin(), trID.end());
	//trID.erase(last, trID.end());
	//vector<double> tr_endframe(trID.size());
	//vector<double> tr_startframe(trID.size());
	//tr_startframe[0] = track(0, 3);
	//int ID = 0;
	//for (int i = 0; i < dim[0]; ++i) {
	//	if (track(i, 4) != trID[ID]) {
	//		tr_endframe[ID] = track(i - 1, 3);
	//		++ID;
	//		tr_startframe[ID] = track(i, 3);
	//	}
	//}
	//tr_endframe[ID] = track(dim[0] - 1, 3);

	// Setting for pair searching
	int max_num_pairs = 1000000;
	int min_pair_length = 50;
	bool* pairs_full = new bool[bin_dim[0]];
	for (int i = 0; i < bin_dim[0]; ++i) pairs_full[i] = false;

	//Obtain pairs within a specific distance
	vector<vector<vector<int>>> pairs(bin_dim[0]); // first dimension: groups of bins;
	//second dimension: number of pairs; third dimension: pair ID and frame no and length

	cout << "Searching pairs..." << endl;
	progressbar bar(frameNo.size());
	bar.set_done_char("-");

#pragma omp parallel shared(pairs) //num_threads(10)
	{
#pragma omp for
		//		for (int i = 0; i < 1000; ++i) {
		for (int i = 0; i < frameNo.size(); ++i) {
#pragma omp critical(bar)
			{
				bar.update();
			}
			//vector<int> index = track.GetElementRowIndex(frameNo[i], 3); // row index of the particles in one frame
			vector<int> frame_index = frame_info.GetElementRowIndex(frameNo[i], 0);
			vector<int> index;
			int start_index = (int) frame_info(frame_index[0], 1);
			for (int j = 0; j < frame_info(frame_index[0], 2); ++j)
				index.push_back(start_index + j);

			int num_point = index.size();
			if (num_point <= 1)
				continue; // skip when there is only one particle in that frame

			vector<double> X = track.GetElement_RowsCol(index, 0);
			vector<double> Y = track.GetElement_RowsCol(index, 1);
			vector<double> Z = track.GetElement_RowsCol(index, 2);

			// calculate the inter-partile distance
	//		int total_combination = num_point * (num_point - 1) / 2;
	//		vector<vector<int>> index_combination(total_combination, vector<int>(2));
	//		vector<double> dist(total_combination);
			double dist = 0;
			vector<int> pair_candidate(5, 0);
			for (int j = 0; j < num_point; ++j) {
				for (int k = j + 1; k < num_point; ++k) {
					//				dist(j * (num_point - 1 - j) + k) = VectorNorm(X[j] - X[k],
					//						Y[j] - Y[k], Z[j] - Z[k]);
					//				index_combination[j * (num_point - 1 - j) + k][0] = j;
					//				index_combination[j * (num_point - 1 - j) + k][1] = k;

					dist = VectorNorm(X[j] - X[k], Y[j] - Y[k], Z[j] - Z[k]);
					if (dist > bin(bin_dim[0] - 1, 1)) // if dist is larger than the largest, then continue
						continue;

					for (int n = 0; n < bin_dim[0]; ++n) {
						if (pairs_full[n] || dist < bin(n, 0)) // NOTE: bin should start from small to large
																// if enough pairs have been found, then skip
							break;
						if (dist > bin(n, 1))
							continue;
						pair_candidate[0] = track(index[j], 4); //get the track ID
						pair_candidate[1] = track(index[k], 4);
						pair_candidate[2] = frameNo[i];  // frame no

						// Get the track length
						// get the time sequence for each particle
	//					vector<double> frame_sequence0 = track.GetElement_RowsCol(track.GetElementRowIndex(pair_candidate[0], 4), 3);
	//					vector<double> frame_sequence1 = track.GetElement_RowsCol(track.GetElementRowIndex(pair_candidate[1], 4), 3);
	//					int end_frame = min(frame_sequence0.back(), frame_sequence1.back());
						int trID_index = distance(trID.begin(), find(trID.begin(), trID.end(), pair_candidate[0]));
						//double start_frame0 = tr_startframe[trID_index];
						//double end_frame0 = tr_endframe[trID_index];
						double start_frame0 = tr_info(trID_index, 1);
						double end_frame0 = start_frame0 + tr_info(trID_index, 2);
						trID_index = distance(trID.begin(), find(trID.begin(), trID.end(), pair_candidate[1]));
						/*double start_frame1 = tr_startframe[trID_index];
						double end_frame1 = tr_endframe[trID_index];*/
						double start_frame1 = tr_info(trID_index, 1);
						double end_frame1 = start_frame1 + tr_info(trID_index, 2);
						double end_frame = min(end_frame0, end_frame1);
						double start_frame = max(start_frame0, start_frame1);
						pair_candidate[3] = end_frame - frameNo[i] + 1;   // forward length of the pair.
						pair_candidate[4] = start_frame - frameNo[i]; // backward length of the pair

#pragma omp critical(pairs)
						{
							if (pair_candidate[3] > pair_len(n,0) || abs(pair_candidate[4]) > pair_len(n, 0)) { // short pairs would be neglected.
								pairs[n].push_back(pair_candidate);
								if (pairs[n].size() > max_num_pairs)
									pairs_full[n] = true;
							}
						}

						//					cout<<n<<" "<<pairs[n][0][0]<<" "<<pairs[n][0][1]<<" "<<pairs[n][0][2]<<" "<<pairs[n][0][3]<<" "<<endl;
					}
				}
			}
		}
	}

	// save pairs to .mat file
	SavePairs(file_path, pairs);

	delete[] pairs_full;
	delete[] data;
	delete[] bin_data;
	delete[] len_data;
	delete[] tr_info_data;
	delete[] frame_info_data;
}

//void CalculateDispersion(char* file_path, int pairID, int direction) {
//	// Read the track data from the .mat file
//	NumMATIO mat_io;
//	mat_io.SetFilePath(file_path);
//	mat_io.SetVarName("filter_data");
//	vector<int> dim;
//	double* data = NULL;
//	mat_io.ReadData(data, dim);
//	Array track(data, dim); // wrap the memory of data as a array
//
//	// Read pair data from the same directory
//	string file_path_s(file_path);
//	int pos = file_path_s.find_last_of("/\\");
//	string pair_path0 = file_path_s.substr(0, pos);
//	string pair_path = pair_path0 + "/\\pairs" + to_string(pairID) + ".mat";
//	mat_io.SetFilePath(pair_path.c_str());
//	mat_io.SetVarName("pairs");
//	vector<int> pairs_dim;
//	double* pairs_data = NULL;
//	mat_io.ReadData(pairs_data, pairs_dim);
//	Array pairs_array(pairs_data, pairs_dim);
//	vector<vector<double>> pairs;
//	// put pairs into 2D vector
//	for(int i = 0; i < pairs_dim[1]; ++i) {
//		vector<double> pair = pairs_array.GetColumn(i);
//		pairs.push_back(pair);
//	}
//	transpose(pairs);
//
//	// sortrows the pairs
//	sortrows(pairs, 2);
//	sortrows(pairs, 1);
//	sortrows(pairs, 0);
//
//
//	vector< vector<double> > pair_label(pairs_dim[0], {0,0});
//	for(int i = 0; i < pairs_dim[0]; ++i){
//		pair_label[i] = {pairs[i][0] * pairs[i][1], pairs[i][0] + pairs[i][1]};
//	}
//
//	delete[] data;
//
//}

void CalculateDispersion(char* file_path, int direction){
	// file_path is the directory where "tracks.mat", "pairs.mat" are saved
	// In order to avoid possible bugs, remember to sort tracks and pairs properly.

	// Read the track data from the .mat file
	NumMATIO mat_io;
	string file(file_path);
	string file1 = file + "/\\tracks.mat";
	mat_io.SetFilePath(file1.c_str());
	mat_io.SetVarName("tracks");
	vector<int> dim;
	double* data = NULL;
	mat_io.ReadData(data, dim);
	Array tracks(data, dim);

	// Read the pairs data
	// Note: pairs: 0. track ID 1; 1 track ID 2; 2. pair start frame; 3. pair length
	string file2 = file + "/\\pairs.mat";
	mat_io.SetFilePath(file2.c_str());
	mat_io.SetVarName("pairs");
	vector<int> pairs_dim;
	double* pairs_data = NULL;
	mat_io.ReadData(pairs_data, pairs_dim);
	Array pairs(pairs_data, pairs_dim);

	// Create an array to save the relative separation for all pairs
	vector<double> pair_len = pairs.GetColumn(3);
	int max_len = *max_element(pair_len.begin(), pair_len.end());
	//double* disp_data = new double[pairs_dim[0] * max_len];
	//vector<int> disp_dim{ pairs_dim[0], max_len };
	//Array disp_matrix(disp_data, disp_dim);
	vector< vector<double> > disp_matrix(pairs_dim[0], vector<double>(max_len, 0));  // create a 2D vector initialized with 0

	progressbar bar(pairs_dim[0]);
	bar.set_done_char("-");

#pragma omp parallel shared(disp_matrix) //num_threads(10)
	{
		//int tid = omp_get_thread_num();
		//printf("Hello world from omp thread %d\n", tid);
#pragma omp for
		// Calculate the relative separation
		for (int i = 0; i < pairs_dim[0]; i++) {
#pragma omp critical(bar)
			{
				bar.update();
			}
			// get the index of tracks in a pair
			vector<int> ind_track1 = tracks.GetElementRowIndex(pairs(i, 0), 4);
			vector<int> ind_track2 = tracks.GetElementRowIndex(pairs(i, 1), 4);

			vector<double> frame_track1 = tracks.GetElement_RowsCol(ind_track1, 3);
			vector<double> frame_track2 = tracks.GetElement_RowsCol(ind_track2, 3);
			// delete index where frame number is smaller than the first frame of a pair
			if (direction == 0) {
				if (frame_track1.front() < pairs(i, 2)) {
					ind_track1.erase(ind_track1.begin(), ind_track1.begin() + (int)(pairs(i, 2) - frame_track1.front()));
					//frame_track1.erase(frame_track1.begin(), frame_track1.begin() + (int)(pairs(i, 2) - frame_track1.front()));
				}
				if (ind_track1.size() > pairs(i, 3)) {
					ind_track1.erase(ind_track1.end() + (int)(pairs(i, 3) - ind_track1.size()), ind_track1.end());
					//frame_track1.erase(frame_track1.end() + (int)(pairs(i, 3) - frame_track1.size()), frame_track1.end());
				}
				if (frame_track2.front() < pairs(i, 2)) {
					ind_track2.erase(ind_track2.begin(), ind_track2.begin() + (int)(pairs(i, 2) - frame_track2.front()));
					//frame_track2.erase(frame_track2.begin(), frame_track2.begin() + (int)(pairs(i, 2) - frame_track2.front()));
				}
				if (ind_track2.size() > pairs(i, 3)) {
					ind_track2.erase(ind_track2.end() + (int)(pairs(i, 3) - ind_track2.size()), ind_track2.end());
					//frame_track2.erase(frame_track2.end() + (int)(pairs(i, 3) - frame_track2.size()), frame_track2.end());
				}
			}
			else {//Backward dispersion
				if (frame_track1.back() > pairs(i, 2))
					ind_track1.erase(ind_track1.end() + (int)(pairs(i, 2) - frame_track1.back()), ind_track1.end());
				if (ind_track1.size() > pairs(i, 3))
					ind_track1.erase(ind_track1.begin(), ind_track1.begin() + (int)(ind_track1.size() - pairs(i, 3)));
				if (frame_track2.back() > pairs(i, 2))
					ind_track2.erase(ind_track2.end() + (int)(pairs(i, 2) - frame_track2.back()), ind_track2.end());
				if (ind_track2.size() > pairs(i, 3))
					ind_track2.erase(ind_track2.begin(), ind_track2.begin() + (int)(ind_track2.size() - pairs(i, 3)));
				reverse(ind_track1.begin(), ind_track1.end());
				reverse(ind_track2.begin(), ind_track2.end());
			}
			if (ind_track1.size() <= 0)
				continue;

			vector<double> X1 = tracks.GetElement_RowsCol(ind_track1, 0),
				Y1 = tracks.GetElement_RowsCol(ind_track1, 1),
				Z1 = tracks.GetElement_RowsCol(ind_track1, 2);
			vector<double> X2 = tracks.GetElement_RowsCol(ind_track2, 0),
				Y2 = tracks.GetElement_RowsCol(ind_track2, 1),
				Z2 = tracks.GetElement_RowsCol(ind_track2, 2);
			vector<double> disp = Vector2Dnorm(X1, Y1, Z1, X2, Y2, Z2);
			for (int j = 1; j < disp.size() - 1; j++)
#pragma omp critical(disp_matrix)
			{
				disp_matrix[i][j - 1] = pow(disp[j] - disp[0], 2);
			}
		}
	}

	// Save disp_matrix

	string file_path_s(file_path);
	//int pos = file_path_s.find_last_of("/\\");
	//string save_path0 = file_path_s.substr(0, pos);
	//	cout<<save_path0<<endl;

	mat_io.SetVarName("disp_matrix");
	string save_path = file_path_s + "/\\disp_matrix.mat";
	mat_io.SetFilePath((char*)save_path.c_str());
	mat_io.WriteData(disp_matrix);

	delete[] data;
	delete[] pairs_data;
	//delete[] disp_data;
}

int main(int argc, char** argv) {
	cout << "!!!Hello World!!!!" << endl;

	//	cout<<"0. Search Pairs, or 1. Calculate dispersion:"<<endl;
	//	int selection = 0;
	//	cin>>selection;
	//	switch (selection)
	//	{
	//	case 0:

	// The following sets the appropriate flags to prevent system to go into sleep mode.
	SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_AWAYMODE_REQUIRED);


	auto start = std::chrono::system_clock::now();
	SearchPairs(argv[1]);
	//CalculateDispersion(argv[1], 1);
	auto end = std::chrono::system_clock::now();
	auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);
	cout << "Total time: " << elapsed.count() << '\n';

	// This clears the flags and allows the system to sleep normally.
	SetThreadExecutionState(ES_CONTINUOUS);
	//		break;
	//
	//	case 1:
	//		cout<<"0. Forward dispersion, or 1. Backward dispersion, or 2. Both:"<<endl;
	//		int option = 0;
	//		cin>>option;
	//		int pairID = 0;
	//		cout<<"Pair ID:"<<endl;
	//		cin>>pairID;
	//		switch (option)
	//		{
	//		case 0:
	//			CalculateDispersion(argv[1], pairID, 0);
	//			break;
	//
	//		case 1:
	//			CalculateDispersion(argv[1], pairID, 1);
	//			break;
	//
	//		case 2:
	//			CalculateDispersion(argv[1], pairID, 0);
	//			CalculateDispersion(argv[1], pairID, 1);
	//			break;
	//
	//		default:
	//			break;
	//		}
	//		break;
	//
	//	default:
	//		break;
	//	}

	return 0;
}
