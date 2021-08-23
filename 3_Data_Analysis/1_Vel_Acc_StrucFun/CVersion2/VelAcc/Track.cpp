/*
 * ----------------------------------------------------------------------------
 * File: Track.cpp
 * ----------------------------------------------------------------------------
 * This is the implementation file for Track objects.
 * ----------------------------------------------------------------------------
 * Created 7/17/03
 * Last updated 7/22/04
 * ----------------------------------------------------------------------------
 * Modified for Yale by NTO on 10/12/11
 * ----------------------------------------------------------------------------
 */

#include <vector>
#include <Track.h>
#include <vector>
//#include <NumDataIO.h>

using namespace std;

//vector<double> conv(vector<double> X, vector<double> kernel) {
//	
//	int nkernel = kernel.size() - 1;
//	int nY = 0;
//	int ix0 = 0;
//	
//	if (kernel.size() == 0) {
//		nY = X.size() - 1;
//	}
//	else if (X.size() >= kernel.size()) {
//		nY = X.size() - kernel.size();
//	}
//	else {
//		nY = -1;
//	}
//
//	vector<double> Y(nY, 0.0);
//	//Y.set_size((nY + 1));
//	//for (ix0 = 0; ix0 <= nC; ix0++) {
//	//	x1[ix0] = 0.0;
//	//}
//
//	if ((X.size() > 0) && (kernel.size() > 0)) {
//		nY = X.size() - kernel.size();
//		for (int k = 0; k <= nkernel; k++) {
//			ix0 = nkernel - k;
//			for (int b_k = 0; b_k <= nY; b_k++) {
//				Y[b_k] = Y[b_k] + kernel[k] * X[ix0 + b_k];
//			}
//		}
//	}
//	return Y;
//}


vector<double> Track::PosAlongAxis(int axis) {
	int len_track = pos.size();
	vector<double> pos_along_axis(len_track, 0);
	switch (axis) {
	case 0:
		for (int i = 0; i < len_track; i++)
			pos_along_axis[i] = pos[i].X();
		break;
	case 1:
		for (int i = 0; i < len_track; i++)
			pos_along_axis[i] = pos[i].Y();
		break;
	case 2:
		for (int i = 0; i < len_track; i++)
			pos_along_axis[i] = pos[i].Z();
		break;
	}
	return pos_along_axis;
}

void Track::AddNext(const Track& t)
{
	pos.insert(pos.end(), t.pos.begin(), t.pos.end());
	time.insert(time.end(), t.time.begin(), t.time.end());
	npoints = pos.size();
	//assert(active = true);
}

void Track::AddFront(const Track& t)
{
	pos.insert(pos.begin(), t.pos.begin(), t.pos.end());
	time.insert(time.begin(), t.time.begin(), t.time.end());
	npoints = pos.size();
	//assert(active = true);
}

int Track::Length() const
{
	if (pos.empty()) {
		return 0;
	}
	// calculate effective size of the track: if the track ends with one or
	// more estimated positions, don't count them
	/*deque<Position>::const_reverse_iterator p_end = pos.rend();
	unsigned int adjust = 0;
	for (deque<Position>::const_reverse_iterator p = pos.rbegin();
		p != p_end; ++p, ++adjust) {
		if (!p->IsFake()) {
			break;
		}
	}
	
	return (npoints - adjust);*/
	return (pos.size());
}

ostream& operator<<(ostream& os, const Track& t)
{
	for (int i = 0; i < t.Length(); ++i) {
		os << t.time[i] << "\t" << t.pos[i] << "\n";
	}

	return os;
}

void Track::PrintEstimates(ostream& os) const
{
	for (int i = 0; i < Length(); ++i) {
		if (pos[i].IsFake()) {
			os << time[i] << "\t" << pos[i] << "\n";
		}
	}
}

int Track::NumFake() const
{
	int count = 0;
	for (int i = 0; i < Length(); ++i) {
		if (pos[i].IsFake()) {
			++count;
		}
	}

	return count;
}

void Track::WriteGDF(ofstream& output, float index, float fps /* = 1 */) const
{
	int len = Length();
	for (int i = 0; i < len; ++i) {
		// Format:
		// Track Index
		// X
		// Y
		// Z
		// Framenumber
		// Camera 1-4 X and Y
		// Info
		// Fake bit
		output.write(reinterpret_cast<const char*>(&index), 4);
		float tmp = pos[i].X();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Y();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Z();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = static_cast<float>(time[i]) / fps;
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].X1();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Y1();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].X2();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Y2();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].X3();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Y3();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].X4();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Y4();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		tmp = pos[i].Info();
		output.write(reinterpret_cast<const char*>(&tmp), 4);
		if (pos[i].IsFake()) {
			tmp = 1;
		}
		else {
			tmp = 0;
		}
		output.write(reinterpret_cast<const char*>(&tmp), 4);
	}
}


//void Track::LoadTrackFromTXT(string path) {
//	NumDataIO<double> data_io;
//	data_io.SetFilePath(path);
//	unsigned int total_num = data_io.GetTotalNumber();
//	unsigned int total_len = total_num / 5;
//	data_io.SetTotalNumber(total_num);
//	double* track_data = new double[total_num];
//	if (total_len != 0) {
//		data_io.ReadData((double*)track_data);
//
//		for (unsigned int i = 0; i < total_num; ) {
//			unsigned int track_no = track_data[i];
//			Track track;
//			while (track_data[i] == track_no) { // for the same track
//				++i;
//				int time = track_data[i];
//				++i;
//				double X = track_data[i];
//				++i;
//				double Y = track_data[i];
//				++i;
//				double Z = track_data[i];
//				++i;
//				Position pos(X, Y, Z);
//				track.AddNext(pos, time);
//			}
//			// after getting the track
//			//switch (trackType)
//			//{
//			//case ActiveLong: activeLongTracks.push_back(track); break;
//			//case ActiveShort: activeShortTracks.push_back(track); break;
//			//case Inactive: inactiveTracks.push_back(track); break;
//			//case Exit: exitTracks.push_back(track); break;
//			//case InactiveLong: inactiveLongTracks.push_back(track); break;
//			//case Buffer: bufferTracks.push_back(track); break;
//			//}
//		}
//	}
//}