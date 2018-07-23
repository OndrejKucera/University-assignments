/**
 * main.cpp
 * Project: Shortest common string (sequence code)
 * Created on: 10.11.2011
 * Authors: Ondrej Kucera, Marcel Syrucek
 */


#include <iostream>
#include <fstream>
#include <string>
#include <list>
#include <sstream>
#include <math.h>

using namespace std;

int main(void) {
	int m=0, k=0, n=0;
	list<string> listStrings;
	list<string> list;
	istringstream is;
	string line;
	string result = "";

	// Load from file
	ifstream myfile ("input.txt");
	if (myfile.is_open()) {
		getline(myfile,line);
		string numbers = line.substr(2,line.size());
		getline(myfile,line);
		numbers += " " + line.substr(2,line.size());
		getline(myfile,line);
		numbers += " " + line.substr(2,line.size());
		istringstream is (numbers,istringstream::in);
		is >> m;
		is >> k;
		is >> n;
		for(int i=0; i<n; i++) {
			getline(myfile,line);
			listStrings.push_front(line);
		}
		myfile.close();
	} else
		cerr << "Unable to open file" << endl;

	// Seed into list
	list.push_front("1");
	list.push_front("0");

	// Breadth-first search
	for(int i=0; i<ldexp(1, m); i++) {
		string item = list.back();
		list.pop_back();

		/* Check upper border */
		if((int)item.size() < m) {
			list.push_front(item+"1");
			list.push_front(item+"0");
		} else {
			list.push_front(item);
		}
	}

	/* Search in space of items (depth-first search) */
	while (!list.empty()) {
		/* Pop string from stack */
		string item = list.front();
		list.pop_front();

		/* Check upper border */
		if((int)item.size() < k) {
			int countIn = 0;

			/* Check if string is ok with conditions */
			for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
				if(item.find(*itList) == string::npos) {
					break;
				} else {
					countIn++;
				}
			}

			if (countIn < n) {
				/* Expand next items */
				list.push_front(item+"1");
				list.push_front(item+"0");
			} else {
				/* If match is found -> don't expand any items */
				if (item.size() < result.size() || result.size() == 0) {
					/* Save new shortest string */
					result = item;

					/* Shift upper border */
					k = item.size();

					/* If upper border is equal lower border*/
					if (k == m) {
						/* Print result */
						cout << "String, which contains all substring EXISTS and its length is " << result.size() << "." << endl;
						cout << "w = " << result << endl;
						cout << "----------- OUTPUT -----------" << endl;
						for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
							int pos = result.find(*itList);
							cout << "    "<< result.substr(0,pos) << "-" << *itList << "-" << result.substr(pos + (*itList).size()) << endl;
						}
						return 0;
					}
				}
			}
		}
	}

	/* Print result */
	if (result.size() > 0) {
		cout << "String, which contains all substring EXISTS and its length is " << result.size() << "." << endl;
		cout << "w = " << result << endl;
		cout << "------------- OUTPUT -------------" << endl;
		for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
			int pos = result.find(*itList);
			cout << result.substr(0,pos) << "-" << *itList << "-" << result.substr(pos + (*itList).size()) << endl;
		}
	} else {
		cout << "String, which contains all substring DON'T EXISTS and its length is." << endl;
		return 0;
	}

	return 0;


}
