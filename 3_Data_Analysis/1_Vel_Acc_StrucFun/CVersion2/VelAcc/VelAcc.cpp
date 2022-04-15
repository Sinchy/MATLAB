#include <iostream>
#include <fstream>
#include <string>
#include <omp.h>
#include "NumDataIO.h"
#include "Track.h"
#include <dirent.h>
#include <filesystem>

#include <stdio.h>
#include <string.h> /* For strcmp() */
#include <stdlib.h> /* For EXIT_FAILURE, EXIT_SUCCESS */
//#include "mat.h"


using namespace std;
namespace fs = std::filesystem;

deque<string> SplitFilename(const std::string& str)
{
	deque<string> path_file;
	//std::cout << "Splitting: " << str << '\n';
	std::size_t found = str.find_last_of("/\\");
	//std::cout << " path: " << str.substr(0, found) << '\n';
	//std::cout << " file: " << str.substr(found + 1) << '\n';
	path_file.push_back(str.substr(0, found));
	path_file.push_back(str.substr(found + 1));
	return path_file;
}

void LoadTrackFromTXT(string path, deque<Track>& tracks) noexcept {
	NumDataIO<double> data_io;
	data_io.SetFilePath(path);
	unsigned int total_num = data_io.GetTotalNumber();
	unsigned int total_len = total_num / 5;
	data_io.SetTotalNumber(total_num);
	double* track_data = new double[total_num];
	int num_previous_tracks = tracks.size();
	if (total_len != 0) {
		data_io.ReadData((double*)track_data);
		for (unsigned int i = 0; i < total_num; ) {
			int track_no = (int) track_data[i];
			//cout << track_no << endl;
			Track track;
			//track.SetTrID(track_no);
			while (track_data[i] == track_no) { // for the same track
				++i;
				int time = track_data[i];
				++i;
				double X = track_data[i];
				++i;
				double Y = track_data[i];
				++i;
				double Z = track_data[i];
				++i;
				Position pos(X, Y, Z);
				track.AddNext(pos, time);
			}
			tracks.push_back(track);
			(tracks.end() - 1)->SetTrID(track_no + num_previous_tracks);
			

			// after getting the track
			//switch (trackType)
			//{
			//case ActiveLong: activeLongTracks.push_back(track); break;
			//case ActiveShort: activeShortTracks.push_back(track); break;
			//case Inactive: inactiveTracks.push_back(track); break;
			//case Exit: exitTracks.push_back(track); break;
			//case InactiveLong: inactiveLongTracks.push_back(track); break;
			//case Buffer: bufferTracks.push_back(track); break;
			//}
		}
		
	}
	delete[] track_data;

	//int num_load_track = tracks.size() - num_previous_tracks;

		// Read radius if there are radius files
	deque<string> path_file = SplitFilename(path);
	string radius_path = path_file[0] + "/Radius" + path_file[1];
	if (std::filesystem::exists(radius_path)) {
		data_io.SetFilePath(radius_path);
		unsigned int total_num = data_io.GetTotalNumber();
		int num_tracks = tracks.size() - num_previous_tracks;
		//unsigned int total_len = num_load_track;
		unsigned int num_cam = total_num / num_tracks - 1;
		data_io.SetTotalNumber(total_num);
		double* radius_data = new double[total_num];
		
		if (num_tracks != 0 ) {
			data_io.ReadData((double*)radius_data);
			
			for (unsigned int i = 0; i < num_tracks; ++ i) {
				vector<double> r;
				for (unsigned int j = 0; j < num_cam; ++j) {
					r.push_back(radius_data[(num_cam + 1) * i + j + 1]);
				}
				tracks[num_previous_tracks + i].SetR(r);
			}
		}
		delete[] radius_data;
	}

}


void SaveTrackToTXT(deque<Track>& tracks, string address) {
	//size_t num_track = tracks.size(); // number of tracks
	//unsigned int total_len = 0; // Total length of all the tracks
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	total_len = total_len + tracks.at(i).Length();
	//}
	//double* track_data = new double[total_len * 5];

	//unsigned int index = 0;
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	unsigned int len = tracks.at(i).Length();
	//	unsigned int start_time = tracks.at(i).GetTime(0);
	//	for (unsigned int j = 0; j < len; ++j) {
	//		track_data[index] = i; // the track NO.
	//		++index;
	//		track_data[index] = j + start_time; // the current frame
	//		++index;
	//		track_data[index] = tracks.at(i)[j].X();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Y();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Z();
	//		++index;
	//	}
	//}

	int num_track = tracks.size(); // number of tracks
	unsigned int total_len = 0; // Total length of all the tracks
	for (unsigned int i = 0; i < num_track; ++i) {
		if (tracks[i].IsProcessed())
			total_len = total_len + tracks.at(i).Length();
	}
	int num_element = 11; // X, Y, Z, frame No, track ID, vx, vy, vz, ax, ay, az

	//MATFile* matfile_w = matOpen(address, "w");
	//mxArray* array_w = mxCreateDoubleMatrix(total_len, num_element, mxREAL);
	//size_t dims[2] = { total_len, num_element };
	//mxArray* array_w = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);

	//double* tr_data = (double*)(mxGetPr(array_w));
	//double* track_data = tr_data;
	double* track_data = new double[total_len * num_element];
	unsigned int index = 0;
	int i = 0;
	deque<Track>::iterator it = tracks.begin();
	//std::cout << "Moving data to mat file buffer." << endl;
	while (it != tracks.end()) {
		if (it->IsProcessed()) {
			unsigned int len = it->Length();
			unsigned int start_time = it->GetTime(0);
			for (unsigned int j = 0; j < len; ++j) {
				Position pos = it->GetPos(j);
				track_data[index] = pos.X(); ++index;
				track_data[index] = pos.Y(); ++index;
				track_data[index] = pos.Z(); ++index;
				track_data[index] = j + start_time; ++index;// the track NO.
				track_data[index] = i; ++index;// the current frame
				Position vel = it->GetVel(j); 
				track_data[index] = vel.X(); ++index;
				track_data[index] = vel.Y(); ++index;
				track_data[index] = vel.Z(); ++index;
				Position acc = it->GetAcc(j);
				track_data[index] = acc.X(); ++index;
				track_data[index] = acc.Y(); ++index;
				track_data[index] = acc.Z(); ++index;
			}
			//index = index + len;
			i++;
		}
		it = tracks.erase(it); // destroy while saving
	}

	//std::cout << "Saving buffer to data." << endl;


	NumDataIO<double> data_io;
	data_io.SetFilePath(address);
	data_io.SetTotalNumber(total_len * num_element);
	data_io.WriteData((double*)track_data);

	delete[] track_data;
}

void SaveTrackToGDF(deque<Track>& tracks, string address) {
	//size_t num_track = tracks.size(); // number of tracks
	//unsigned int total_len = 0; // Total length of all the tracks
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	total_len = total_len + tracks.at(i).Length();
	//}
	//double* track_data = new double[total_len * 5];

	//unsigned int index = 0;
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	unsigned int len = tracks.at(i).Length();
	//	unsigned int start_time = tracks.at(i).GetTime(0);
	//	for (unsigned int j = 0; j < len; ++j) {
	//		track_data[index] = i; // the track NO.
	//		++index;
	//		track_data[index] = j + start_time; // the current frame
	//		++index;
	//		track_data[index] = tracks.at(i)[j].X();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Y();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Z();
	//		++index;
	//	}
	//}
	ofstream outfile;

	int num_track = tracks.size(); // number of tracks
	unsigned int total_len = 0; // Total length of all the tracks
	for (unsigned int i = 0; i < num_track; ++i) {
		if (tracks[i].IsProcessed())
			total_len = total_len + tracks.at(i).Length();
	}
	int num_element = 11; // X, Y, Z, frame No, track ID, vx, vy, vz, ax, ay, az

	// Header file
	outfile.open(address, ios::out | ios::trunc | ios::binary);
	int magic = 82991;  // file ID as a track file
	outfile.write(reinterpret_cast<const char*>(&magic), 4);
	// number of dimensions
	int tmpi = 2;
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);
	// number of columns
	//tmpi = 6;
	outfile.write(reinterpret_cast<const char*>(&num_element), 4);
	// number of rows: we don't know this yet!
	//tmpi = 0;
	outfile.write(reinterpret_cast<const char*>(&total_len), 4);
	// a 4 means floating point numbers
	tmpi = sizeof(double);
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);
	// number of total points
	tmpi = num_element * total_len;
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);


	//MATFile* matfile_w = matOpen(address, "w");
	//mxArray* array_w = mxCreateDoubleMatrix(total_len, num_element, mxREAL);
	//size_t dims[2] = { total_len, num_element };
	//mxArray* array_w = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);

	//double* tr_data = (double*)(mxGetPr(array_w));
	//double* track_data = tr_data;
	//double* track_data = new double[total_len * num_element];
	//unsigned int index = 0;
	int i = 0;
	deque<Track>::iterator it = tracks.begin();
	//std::cout << "Moving data to mat file buffer." << endl;
	while (it != tracks.end()) {
		if (it->IsProcessed()) {
			unsigned int len = it->Length();
			unsigned int start_time = it->GetTime(0);
			int trID = it->GetTrID();
			for (unsigned int j = 0; j < len; ++j) {
				Position pos = it->GetPos(j);
				double val = pos.X();
				outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = pos.Y(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = pos.Z(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = j + start_time; outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = trID; outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));

				Position vel = it->GetVel(j);
				val = vel.X(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = vel.Y(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = vel.Z(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				Position acc = it->GetAcc(j);
				val = acc.X(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = acc.Y(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
				val = acc.Z(); outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
			}
			//index = index + len;
			i++;
		}
		it = tracks.erase(it); // destroy while saving
	}

	outfile.close();

	//std::cout << "Saving buffer to data." << endl;


	//NumDataIO<double> data_io;
	//data_io.SetFilePath(address);
	//data_io.SetTotalNumber(total_len * num_element);
	//data_io.WriteData((double*)track_data);

	//delete[] track_data;
}

void SaveRadiusToGDF(deque<Track>& tracks, string address) {
	//size_t num_track = tracks.size(); // number of tracks
	//unsigned int total_len = 0; // Total length of all the tracks
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	total_len = total_len + tracks.at(i).Length();
	//}
	//double* track_data = new double[total_len * 5];

	//unsigned int index = 0;
	//for (unsigned int i = 0; i < num_track; ++i) {
	//	unsigned int len = tracks.at(i).Length();
	//	unsigned int start_time = tracks.at(i).GetTime(0);
	//	for (unsigned int j = 0; j < len; ++j) {
	//		track_data[index] = i; // the track NO.
	//		++index;
	//		track_data[index] = j + start_time; // the current frame
	//		++index;
	//		track_data[index] = tracks.at(i)[j].X();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Y();
	//		++index;
	//		track_data[index] = tracks.at(i)[j].Z();
	//		++index;
	//	}
	//}
	ofstream outfile;

	int num_track = tracks.size(); // number of tracks
	unsigned int total_len = 0; // Total length of all the tracks
	for (unsigned int i = 0; i < num_track; ++i) {
		if (tracks[i].IsProcessed())
			total_len ++;
	}
	int num_cam = tracks.begin()->GetR().size();
	int num_element = 1 + num_cam; // track ID, radius for num_cam cameras

	// Header file
	outfile.open(address, ios::out | ios::trunc | ios::binary);
	int magic = 82991;  // file ID as a track file
	outfile.write(reinterpret_cast<const char*>(&magic), 4);
	// number of dimensions
	int tmpi = 2;
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);
	// number of columns
	//tmpi = 6;
	outfile.write(reinterpret_cast<const char*>(&num_element), 4);
	// number of rows: we don't know this yet!
	//tmpi = 0;
	outfile.write(reinterpret_cast<const char*>(&total_len), 4);
	// a 4 means floating point numbers
	tmpi = sizeof(double);
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);
	// number of total points
	tmpi = num_element * total_len;
	outfile.write(reinterpret_cast<const char*>(&tmpi), 4);


	//MATFile* matfile_w = matOpen(address, "w");
	//mxArray* array_w = mxCreateDoubleMatrix(total_len, num_element, mxREAL);
	//size_t dims[2] = { total_len, num_element };
	//mxArray* array_w = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);

	//double* tr_data = (double*)(mxGetPr(array_w));
	//double* track_data = tr_data;
	//double* track_data = new double[total_len * num_element];
	//unsigned int index = 0;
	int i = 0;
	deque<Track>::iterator it = tracks.begin();
	//std::cout << "Moving data to mat file buffer." << endl;
	for (;it != tracks.end(); it++) {
		if (it->IsProcessed()) {
			//unsigned int len = it->Length();
			//unsigned int start_time = it->GetTime(0);
			int trID = it->GetTrID();
			double val = trID; 
			outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
			vector<double> r = it->GetR();
			for (int j = 0; j < r.size(); ++j) {
				val = r[j];
				outfile.write(reinterpret_cast<const char*>(&val), sizeof(double));
			}
			
			//index = index + len;
			i++;
		}
		
		//it = tracks.erase(it); // destroy while saving
	}

	outfile.close();

	//std::cout << "Saving buffer to data." << endl;


	//NumDataIO<double> data_io;
	//data_io.SetFilePath(address);
	//data_io.SetTotalNumber(total_len * num_element);
	//data_io.WriteData((double*)track_data);

	//delete[] track_data;
}


//int SaveTrackToMat(deque<Track>& tracks, char* address) {
//
//	// get the total length of points in tracks
//	int num_track = tracks.size(); // number of tracks
//	unsigned int total_len = 0; // Total length of all the tracks
//	for (unsigned int i = 0; i < num_track; ++i) {
//		if (tracks[i].IsProcessed())
//			total_len = total_len + tracks.at(i).Length();
//	}
//	int num_element = 11; // X, Y, Z, frame No, track ID, vx, vy, vz, ax, ay, az
//
//	MATFile* matfile_w = matOpen(address, "w");
//	mxArray* array_w = mxCreateDoubleMatrix(total_len, num_element, mxREAL);
//	//size_t dims[2] = { total_len, num_element };
//	//mxArray* array_w = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);
//	
//	double* tr_data = (double*)(mxGetPr(array_w));
//	double* track_data = tr_data;
//	//double* track_data = new double[total_len * num_element];
//	unsigned int index = 0;
//	int i = 0;
//	deque<Track>::iterator it = tracks.begin();
//	std::cout << "Moving data to mat file buffer." << endl;
//	while (it != tracks.end()) {
//		if (it->IsProcessed()) {
//			unsigned int len = it->Length();
//			unsigned int start_time = it->GetTime(0);
//			for (unsigned int j = 0; j < len; ++j) {
//				Position pos = it->GetPos(j);
//				track_data[(j + index)] = pos.X();
//				track_data[(j + index) + total_len * 1] = pos.Y();
//				track_data[(j + index) + total_len * 2] = pos.Z();
//				track_data[(j + index) + total_len * 3] = j + start_time; // the track NO.
//				track_data[(j + index) + total_len * 4] = i; // the current frame
//				Position vel = it->GetVel(j);
//				track_data[(j + index) + total_len * 5] = vel.X();
//				track_data[(j + index) + total_len * 6] = vel.Y();
//				track_data[(j + index) + total_len * 7] = vel.Z();
//				Position acc = it->GetAcc(j);
//				track_data[(j + index) + total_len * 8] = acc.X();
//				track_data[(j + index) + total_len * 9] = acc.Y();
//				track_data[(j + index) + total_len * 10] = acc.Z();
//			}
//			index = index + len;
//			i++;
//		}
//		it = tracks.erase(it); // destroy while saving
//	}
//
//	std::cout << "Saving buffer to data." << endl;
//	//for (unsigned int i = 0; i < num_track; ++i) {
//	//	if (tracks[i].IsProcessed()) {
//	//		unsigned int len = tracks[i].Length();
//	//		unsigned int start_time = tracks[i].GetTime(0);
//	//		for (unsigned int j = 0; j < len; ++j) {
//	//			Position pos = tracks[i].GetPos(j);
//	//			track_data[(j + index)] = pos.X();
//	//			track_data[(j + index) + total_len * 1] = pos.Y();
//	//			track_data[(j + index) + total_len * 2] = pos.Z();
//	//			track_data[(j + index) + total_len * 3] = j + start_time; // the track NO.
//	//			track_data[(j + index) + total_len * 4] = i; // the current frame
//	//			Position vel = tracks[i].GetVel(j);
//	//			track_data[(j + index) + total_len * 5] = vel.X();
//	//			track_data[(j + index) + total_len * 6] = vel.Y();
//	//			track_data[(j + index) + total_len * 7] = vel.Z();
//	//			Position acc = tracks[i].GetAcc(j);
//	//			track_data[(j + index) + total_len * 8] = acc.X();
//	//			track_data[(j + index) + total_len * 9] = acc.Y();
//	//			track_data[(j + index) + total_len * 10] = acc.Z();
//	//		}
//	//		index = index + len;
//	//	}
//	//}
//
//	//memcpy(mxGetPr(array_w), track_data, total_len * num_element * sizeof(double));
//	int status = matPutVariable(matfile_w, "tracks", array_w);
//	if (status != 0) {
//		printf("%s :  Error using matPutVariable on line %d\n", __FILE__, __LINE__);
//		return(EXIT_FAILURE);
//	}
//
//	mxDestroyArray(array_w);
//	matClose(matfile_w);
//	delete[] track_data;
//	return 0;
//}

//void writeGDFHeader(std::string outname, ofstream* outfile, int sizeofdatatype, int rows, int cols)
//{
//	// open the output file with a temporary header
//	outfile->open(outname.c_str(), ios::out | ios::trunc | ios::binary);
//	int magic = 82991;  // file ID as a track file
//	outfile->write(reinterpret_cast<const char*>(&magic), 4);
//	// number of dimensions
//	int tmpi = 2;
//	outfile->write(reinterpret_cast<const char*>(&tmpi), 4);
//	// number of columns
//	//tmpi = 6;
//	outfile->write(reinterpret_cast<const char*>(&cols), 4);
//	// number of rows: we don't know this yet!
//	//tmpi = 0;
//	outfile->write(reinterpret_cast<const char*>(&rows), 4);
//	// a 4 means floating point numbers
//	tmpi = sizeofdatatype;
//	outfile->write(reinterpret_cast<const char*>(&tmpi), 4);
//	// number of total points: we don't know this yet!
//	tmpi = cols * rows;
//	outfile->write(reinterpret_cast<const char*>(&tmpi), 4);
//
//	std::cout << "\nHeader information written..." << endl;
//
//}

//void fixHeader(int nr, int cols, ofstream* outfile) {
//
//	// now fix up the header with the proper sizes
//	outfile->seekp(8, ios::beg);
//	outfile->write(reinterpret_cast<const char*>(&cols), 4);
//	outfile->write(reinterpret_cast<const char*>(&nr), 4);
//	outfile->seekp(4, ios::cur);
//	int tmpi = cols * nr;
//	outfile->write(reinterpret_cast<const char*>(&tmpi), 4);
//	std::cout << "\nHeader information updated!" << endl;
//}

vector<double> conv(vector<double> x, vector<double> h) {
	int sample_count = x.size();
	int kernel_count = h.size(); // h is a kernel symmetric at 0, so kernel_count is an odd number
	vector<double> y(sample_count, 0);
	for (int i = (kernel_count - 1) / 2; i < sample_count - (kernel_count - 1) / 2; i++)
	{
		for (int j = 0; j < kernel_count; j++)
		{
			y[i] += x[i + j - (kernel_count - 1) / 2] * h[j];    // convolve: multiply and accumulate
		}
	}
	return y;
}


void main(int argc, char** argv) {

	// Key information: track path, frame rate, filter width, filter length
	//					number of bins
	if (argc < 2) {
		cerr << "Usage: " << argv[0] << " <project path>" << "<frame rate, optional, default (5000)>" 
			<< "<filter width, optional, default (3)>" << "filter length, optional, default (14)" << "number of bins for SF, optional, default (10)" << endl;
		exit(1);
	}

	char* file_path = nullptr;
	int frame_rate = 5000, filter_width = 3, filter_length = 14, nbin = 10;

	switch (argc) {
	case 2:
		file_path = argv[1];
		break;
	case 3: 
		file_path = argv[1];
		frame_rate = stoi(argv[2]);
		break;
	case 4:
		file_path = argv[1];
		frame_rate = stoi(argv[2]);
		filter_width = stoi(argv[3]);
		break;
	case 5:
		file_path = argv[1];
		frame_rate = stoi(argv[2]);
		filter_width = stoi(argv[3]);
		filter_length = stoi(argv[4]);
		break;
	case 6:
		file_path = argv[1];
		frame_rate = stoi(argv[2]);
		filter_width = stoi(argv[3]);
		filter_length = stoi(argv[4]);
		nbin = stoi(argv[5]);
		break;
	}

	// Read tracks
	char* track_path = new char[strlen(file_path)];//strcat(file_path, "/Tracks/ConvergedTracks/");
	std::strcpy(track_path, file_path);
	std::strcat(track_path, "/Tracks/ConvergedTracks/");
	//cout << "start!" << endl;
	//deque<Track> tracks;

	//DIR* dir = opendir(track_path);
	//struct dirent* entry;
	//std::cout << "Loading txt track files ..." << endl;
	//while ((entry = readdir(dir)) != NULL) {
	//	char* file_name = entry->d_name;
	//	cout<<file_name<<endl;
	//	string file_name_s(file_name);
	//	if (strcmp(file_name, ".") == 0 || strcmp(file_name, "..") == 0 || 
	//		file_name_s.find("ActiveShortTracks") != std::string::npos || file_name_s.find(".txt") == std::string::npos)
	//		continue;
	//	char* track_file = new char[strlen(track_path)];
	//	std::strcpy(track_file, track_path);
	//	std::strcat(track_file, file_name);
	//	//LoadTrackFromTXT((string)track_file, tracks);
	//}
	//closedir(dir);
	std::cout << "Program started." << endl;
	deque<Track> tracks;
	std::cout << "Loading txt track files ..." << endl;
	for (const auto& entry : fs::directory_iterator(track_path)) {
		string file_name = entry.path().string();
		if (file_name.find("ActiveShortTracks") != std::string::npos ||
			file_name.find("Radius") != std::string::npos ||
			file_name.find(".txt") == std::string::npos)
			continue;
		cout << "Reading:" << file_name << endl;
		LoadTrackFromTXT((string)file_name, tracks);
	}
	std::cout << "Load files done." << endl
		<< "Start to filter tracks..." << endl;
	//exit(0);
	
	//deque<Track> tracks;
	// Filter each tracks
	int num_tracks = tracks.size();
	//vector<int> label_shrt_tr;
	//vector<bool> process_label(num_tracks, false); // label to show whether the track has been filtered.

	// position kernel
	double int_exp = 0;
	for (int int_range = 1; int_range <= filter_length; int_range++)
		int_exp = int_exp + exp(-pow(int_range, 2) / pow(filter_width, 2));
	double Av = 1 / (2 * int_exp + 1);
	vector<double> rkernel(2 * filter_length + 1, 0); // kernel for position
	for (int j = 0; j < 2 * filter_length + 1; j++)
		rkernel[j] = Av * exp(-pow(j - filter_length, 2) / pow(filter_width, 2));


	//velocity kernel
	int_exp = 0;
	for (int int_range = 1; int_range <= filter_length; int_range++)
		int_exp = int_exp + pow(int_range, 2) * exp(-pow(int_range, 2) / pow(filter_width, 2));
	Av = 1 / (2 * int_exp);
	vector<double> vkernel(2 * filter_length + 1, 0); // kernel for velocity
	for (int j = 0; j < 2 * filter_length + 1; j++)
		vkernel[j] = Av * (j - filter_length) * exp(-pow(j - filter_length, 2) / pow(filter_width, 2));


	//acceleration kernel
	double coef = 2 / (sqrt(3.14159) * pow(filter_width, 3));
	double sum_tsq = 0;
	for (int j = -filter_length; j <= filter_length; j++) sum_tsq = sum_tsq + j * j;
	double sum_k = 0;
	for (int j = -filter_length; j <= filter_length; j++)
		sum_k = sum_k + coef * (2 * j * j / pow(filter_width, 2) - 1) / exp(j * j / pow(filter_width, 2));
	double sum_ktsq = 0;
	for (int j = -filter_length; j <= filter_length; j++)
		sum_ktsq = sum_ktsq + j * j * coef * (2 * j * j / pow(filter_width, 2) - 1) / exp(j * j / pow(filter_width, 2));

	double A = 2 / (sum_ktsq - sum_k * sum_tsq / (2 * filter_length));
	double B = -A * sum_k / (2 * filter_length);

	vector<double> akernel(2 * filter_length + 1, 0); // kernel for velocity
	for (int j = 0; j < 2 * filter_length + 1; j++)
		akernel[j] = A * coef * (2 * pow(j - filter_length, 2) / pow(filter_width, 2) - 1) / exp(pow(j - filter_length, 2) / pow(filter_width, 2)) + B;

#pragma omp parallel //shared(label_shrt_tr)
	{
#pragma omp for
		for (int i = 0; i < num_tracks; i++) {
			int len_track = tracks[i].Length();
			if (len_track < 2 * filter_length + 10) {
//#pragma omp critical(label_shrt_tr) 
//				{
//					label_shrt_tr.push_back(i);
//				}
				continue;  // skip short tracks
			}

			// filter position
			deque<Position> pos_filtered(tracks[i].Length() - 2 * filter_length, Position(0, 0, 0));
			vector<double> positions_X = tracks[i].PosAlongAxis(0);
			vector<double> positions_filtered = conv(positions_X, rkernel);
			for (int j = 0; j < positions_filtered.size() - 2 * filter_length; j++)
				pos_filtered[j].Set_X(positions_filtered[j + filter_length]);
			vector<double> positions_Y = tracks[i].PosAlongAxis(1);
			positions_filtered.clear();
			positions_filtered = conv(positions_Y, rkernel);
			for (int j = 0; j < positions_filtered.size() - 2 * filter_length; j++)
				pos_filtered[j].Set_Y(positions_filtered[j + filter_length]);
			vector<double> positions_Z = tracks[i].PosAlongAxis(2);
			positions_filtered.clear();
			positions_filtered = conv(positions_Z, rkernel);
			for (int j = 0; j < positions_filtered.size() - 2 * filter_length; j++)
				pos_filtered[j].Set_Z(positions_filtered[j + filter_length]);
			positions_filtered.clear();

			// filter velocity
			vector<double> vel_filtered = conv(positions_X, vkernel);
			deque<Position> vel(tracks[i].Length() - 2 * filter_length, Position(0, 0, 0));
			for (int j = 0; j < vel_filtered.size() - 2 * filter_length; j++)
				vel[j].Set_X(vel_filtered[j + filter_length] * frame_rate);
			vel_filtered.clear();
			vel_filtered = conv(positions_Y, vkernel);
			for (int j = 0; j < vel_filtered.size() - 2 * filter_length; j++)
				vel[j].Set_Y(vel_filtered[j + filter_length] * frame_rate);
			vel_filtered.clear();
			vel_filtered = conv(positions_Z, vkernel);
			for (int j = 0; j < vel_filtered.size() - 2 * filter_length; j++)
				vel[j].Set_Z(vel_filtered[j + filter_length] * frame_rate);
			vel_filtered.clear();

			// filter acceleration
			vector<double> acc_filtered = conv(positions_X, akernel);
			deque<Position> acc(tracks[i].Length() - 2 * filter_length, Position(0, 0, 0));
			for (int j = 0; j < acc_filtered.size() - 2 * filter_length; j++)
				acc[j].Set_X(acc_filtered[j + filter_length] * frame_rate * frame_rate);
			acc_filtered.clear();
			acc_filtered = conv(positions_Y, akernel);
			for (int j = 0; j < acc_filtered.size() - 2 * filter_length; j++)
				acc[j].Set_Y(acc_filtered[j + filter_length] * frame_rate * frame_rate);
			acc_filtered.clear();
			acc_filtered = conv(positions_Z, akernel);
			for (int j = 0; j < acc_filtered.size() - 2 * filter_length; j++)
				acc[j].Set_Z(acc_filtered[j + filter_length] * frame_rate * frame_rate);
			acc_filtered.clear();

			deque<int> time;
			int start_frame = tracks[i].GetTime(0);
			int end_frame = tracks[i].GetTime(positions_X.size() - 1);
			for (int j = start_frame + filter_length; j < end_frame - filter_length + 1; j++)
				time.push_back(j);

			tracks[i].SetPos(pos_filtered);
			tracks[i].SetVel(vel);
			tracks[i].SetAcc(acc);
			tracks[i].SetTime(time);

			tracks[i].Processed();
			//process_label[i] = 1;
		}
	}
	std::cout << "Filter Done." << endl;
		//<< "Preparing data..." << endl;
	// remove unprocessed tracks
	//int shift = 0;
	//for (std::deque<Track>::iterator it = tracks.begin(); it != tracks.end(); ) {
	//	//deque<Track>::iterator tr = tracks.begin();
	//	/*if (!process_label[i]) {
	//		tracks.erase(tracks.begin() + i - shift);
	//		++shift;
	//	}*/
	//	if (! (*it).IsProcessed()) {
	//		it = tracks.erase(it);
	//		continue;
	//	}
	//	++it;
	//}
	//int ind = 0;
	//deque<Track>::iterator it = tracks.begin();
	//for (int i = 0; i < label_shrt_tr.size(); i++) {
	//	int rel_ind = label_shrt_tr[i] - ind;
	//	it = tracks.erase(it + rel_ind);
	//	ind = label_shrt_tr[i] + 1;
	//}

	std::cout << "Saving data..." << endl;

	char* save_file = new char[strlen(track_path)];
	std::strcpy(save_file, file_path);
	//std::strcat(save_file, "/tracks.mat");
	//SaveTrackToMat(tracks, save_file);
	//std::strcat(save_file, "/tracks.txt");
	//cout << "Saving data to: " << save_file << endl;
	//SaveTrackToTXT(tracks, save_file);

	std::strcat(save_file, "/tracks.gdf");
	cout << "Saving data to: " << save_file << endl;
	// save radius before tracks!
	if (tracks[0].GetR().size() > 0) {
		char* save_file2 = new char[strlen(track_path)];
		std::strcpy(save_file2, file_path);
		std::strcat(save_file2, "/radius.gdf");
		SaveRadiusToGDF(tracks, save_file2);
	} 
	SaveTrackToGDF(tracks, save_file);
	
		
	std::cout << "Save done." << endl;
}


