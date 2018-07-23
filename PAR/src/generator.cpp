/**
 * main.cpp
 * Project: Shortest common string (generate random string and bounder)
 * Created on: 10.11.2011
 * Authors: Ondrej Kucera, Marcel Syrucek
 */

#include <iostream>
#include <list>
#include <cstdlib>
#include <math.h>
#include <cstring>
#include <fstream>

using namespace std;

void print_help() {
	cout << "########################################################" << endl;
	cout << "# Shortest common string                               #" << endl;
	cout << "########################################################" << endl;
	cout << "# Parameters:                                          #" << endl;
	cout << "#  -n        (number of strings)                       #" << endl;
	cout << "#  -z        (maximum length of string)                #" << endl;
	cout << "#  --help    (output with help instruction)            #" << endl;
	cout << "########################################################" << endl;
	return;
}

string generatorString(int lenght) {
	string binaryString = "";

	for(int i=0; i<lenght; i++) {
		if ((rand() % 2) == 1)
			binaryString += "1";
		else {
			binaryString += "0";
		}
	}

	return binaryString;
}

int main(int argc, char* argv[]) {
	string result = "";
	std::list<std::string> listString;
	int numberStrings = 0, maxLenght = 0;
	int k = 0, maxString = 0;

	// Arguments of program
	for(int i = 0; i<argc; i ++ ) {
		if(!strcmp(argv[i], "-n"))
			numberStrings = atoi(argv[i + 1]);
		if(!strcmp(argv[i], "-z"))
			maxLenght = atoi(argv[i + 1]);
		if(!strcmp(argv[i], "--help")) {
			print_help();
			return 0;
		}
	}

	// Check arguments
	if(numberStrings < 10) {
		cerr << "Error: Number of string must be bigger than 10." << endl;
		return -1;
	}
	if(maxLenght <= log(numberStrings)) {
		cerr << "Error: Maximum of string must be bigger then log(n)=" << log(numberStrings) << endl;
		return -1;
	}

	int sum = 0;
	int logN = round(log(numberStrings));

	/* Initialize random seed */
	srand(time(NULL));

	/* Generate binary string */
	for (int i=0; i<numberStrings; i++) {
		int n = rand() % (maxLenght-logN+1) + logN;
		sum +=n;
		if (n > maxString) maxString = n;

		listString.push_front(generatorString(n));
	}

	/* Count of upper bounder */
	k = rand() % (sum/2 - maxString-1) + maxString +1;

	/* Output to the file*/
	ofstream myfile;
	myfile.open ("input.txt");
	if (myfile.is_open()) {
		myfile << "m=" << maxString << endl;		// maximum length of string
		myfile << "k=" << k << endl;				// upper bounder
		myfile << "n=" << numberStrings << endl;	// count of strings
		for(int i=0; i<numberStrings; i++) {
			myfile << listString.front() << endl;	// string
			listString.pop_front();
		}
	} else {
		cerr << "Unable to open file" << endl;
		return 0;
	}
	myfile.close();
}
