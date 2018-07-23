/**
 * main.cpp
 * Project: Shortest common string (sequence code)
 * Created on: 10.11.2011
 * Authors: Ondrej Kucera, Marcel Syrucek
 */

#include <mpi.h>
#include <iostream>
#include <fstream>
#include <string>
#include <list>
#include <sstream>
#include <math.h>

using namespace std;

/* Constants */
const int CHECK_MSG_AMOUNT = 70;
const int MSG_WORK_REQUEST = 1000;
const int MSG_WORK_SENT = 1001;
const int MSG_WORK_NOWORK = 1002;
const int MSG_TOKEN = 1003;
const int MSG_FINISH = 1004;
const int MSG_K_HIGHER = 1005;
const int MSG_K_EQUAL_M = 1006;
const int LENGTH = 100;


int main(int argc, char **argv) {
	int m=0, k=0, n=0;
	list<string> listStrings;
	list<string> list;
	istringstream is;
	string line = "";
	string result = "";

	/* For MPI */
	int p = 0;
	int my_rank = 0;
	int counter = 0;
	int flag = 0;
	int tag = 1;
	MPI_Status status;
	char buffer[LENGTH];
	int position = 0;
	int number;
	bool flagForToken = false;
	int countFinish = 1;

	/* Start up MPI */
	MPI_Init(&argc, &argv);

	/* Find out process rank */
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	/* Find out number of processes*/
	MPI_Comm_size(MPI_COMM_WORLD, &p);

	/* Each process loads data from file */
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
	} else {
		cerr << "Unable to open file" << endl;
		return 0;
	}

	/* Process 0 load stack of item */
	if(my_rank == 0) {
		/* Seed into list */
		list.push_front("1");
		list.push_front("0");

		/* Breadth-first search */
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

		/* Divide stack */
		int partOfStack = list.size()/p;
		int rest = list.size() % p;

		/* Send part of stack */
		for(int dest=1; dest<p; dest++) {
			// count of items
			if (rest <= 0) {
				number = partOfStack;
			} else {
				number = partOfStack+1;
				rest--;
			}

			// number of loops
			int loop = (number/((LENGTH-4)/(m+1)))+1;
			MPI_Send(&loop, 1, MPI_INT, dest, tag, MPI_COMM_WORLD);
			for (int j=0; j<loop; j++) {
				position = 0;
				
				int n = (LENGTH-4)/(m+1);
				if(number < n)
					n = number;
				/* Packing data */
				MPI_Pack(&n, 1, MPI_INT, buffer, LENGTH, &position, MPI_COMM_WORLD);
				for (int i=0; i<n; i++) {
					/* Convert string to char* */
					string str = list.front();
					list.pop_front();
					char* message = new char[m+1];
					strcpy(message,str.c_str());
					message[m] = '\0';
					/* Packing string */
					MPI_Pack(message, m+1, MPI_CHAR, buffer, LENGTH, &position, MPI_COMM_WORLD);
					delete []message;
					number--;
				}
				/* Send data */
				MPI_Send(buffer, position, MPI_PACKED, dest, tag, MPI_COMM_WORLD);
			}
			//cout << dest << " Send OK" << endl;
		}
		//cout << my_rank << "      OK = " << list.size() << endl;
	} else {
		// Recieving number of loop
		int loop = 0;
		MPI_Recv(&loop, 1, MPI_INT, 0, tag, MPI_COMM_WORLD, &status);
		for (int j=0; j<loop; j++) {
			// Recieving data
			MPI_Recv(buffer, LENGTH, MPI_PACKED, 0, tag, MPI_COMM_WORLD, &status);
			// Unpacking data
			int position = 0;
			int n = 0;
			MPI_Unpack(buffer, LENGTH, &position, &n, 1, MPI_INT, MPI_COMM_WORLD);
			for (int i=0; i<n; i++) {
				char* message = new char[m+1];
				MPI_Unpack(buffer, LENGTH, &position, message, m+1, MPI_CHAR, MPI_COMM_WORLD);
				list.push_front(message);
				delete []message;
			}
		}
		//cout << my_rank << " Unpack OK = " << list.size() << endl;
	}


	//-- zde by asi mela by BARIERA pro mereni casu

	// Start searching
	int dest_process = 0;
	int message = 0;
	// Search in space of items
	while (true) {
	
		// (depth-first search)
		if (!list.empty()) {
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
					// Expand next items
					list.push_front(item+"1");
					list.push_front(item+"0");
				} else {
					//cout << my_rank << " shoda = " << item << endl;
					// If match is found -> don't expand any items 
					if (item.size() < result.size() || result.size() == 0) {
						// Save new shortest string
						result = item;
						
						// Shift upper border
						k = item.size();
						
						// If upper border is equal lower border
						if (k == m) {
							// Convert string to char*
							string str = result;
							int stringLength = str.length()+1;
							char* stringMessage = new char[stringLength];
							strcpy(stringMessage,str.c_str());
							stringMessage[str.length()] = '\0';
							// Packing string
							position = 0;
							MPI_Pack(&stringLength, 1, MPI_INT, buffer, LENGTH, &position, MPI_COMM_WORLD);
							MPI_Pack(stringMessage, stringLength, MPI_CHAR, buffer, LENGTH, &position, MPI_COMM_WORLD);
							//cout << "!!!M=K v procesu " << my_rank << ", " << stringMessage << ", m=" << m << endl;
							delete []stringMessage;
							// Send data
							MPI_Send(buffer, position, MPI_PACKED, 0, MSG_K_EQUAL_M, MPI_COMM_WORLD);
							// Delete all list of items
							list.clear();
						}
						
						// Send new k
						for (int i=0; i<p; i++) {
							if(i == my_rank)
								continue;
							MPI_Send(&k, 1, MPI_INT, i, MSG_K_HIGHER, MPI_COMM_WORLD);
							//cout << my_rank << " SEND NEW K = " << k << "to " << i << endl;
						}
					}
				}
			}
			
			if (list.empty()) {
				// If is single process
				if (p == 1) {
					break;
				// else send request for work
				} else if ((dest_process = my_rank-1) < 0) {
					dest_process = p-1;
				}
				MPI_Send(&dest_process, 1, MPI_INT, dest_process, MSG_WORK_REQUEST, MPI_COMM_WORLD);
				//cout << my_rank << " PRVNI dotaz pro praci na " << dest_process << endl;
			}
		}

		/* Check if message is received */
		counter++;
		if((counter % CHECK_MSG_AMOUNT) == 0) {
			MPI_Iprobe(MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &flag, &status);
			if(flag) {
				bool sendWork = false;
				//cout << "Flag je... " << my_rank << "flag =" << flag <<" tag= " << status.MPI_TAG << " od " << status.MPI_SOURCE << endl;
				switch(status.MPI_TAG) {
					case MSG_WORK_REQUEST:  // Request for work
						MPI_Recv(&message, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
						// Check upper bounder (k-3)
						for (std::list<string>::reverse_iterator iter = list.rbegin(); iter!=list.rend(); iter++) {
							string s = *iter;
							if (s.size() < k-3) {
								sendWork = true;
								break;
							}
						}
						// Nothing for sending
						if (!sendWork) {
							MPI_Send(&message, 1, MPI_INT, status.MPI_SOURCE, MSG_WORK_NOWORK, MPI_COMM_WORLD);
							//cout << my_rank << " REQUEST nemuzu poslat praci " << status.MPI_SOURCE << endl;
						// Sending part of stack
						} else {
							int index = 0;
							int count = 0;
							int size = list.size();
							std::list<string> mList;
							for (std::list<string>::reverse_iterator iter = list.rbegin(); index < size-1; index++) {
								// Load strings
								string s1 = *iter;
								++iter;
								string s2 = *iter;
								// Compare strings
								if (s1.size() == s2.size()) {
									if (count % 2 == 0) {
										mList.push_front(*iter);
										list.remove(*iter);
										count++;
										iter--;
									}
								} else {
									if(count == 0) {
										--iter;
										mList.push_front(*iter);
										list.remove(*iter);
									}
									break;
								}
							}
							// Packing data
							position = 0;
							size = mList.size();
							MPI_Pack(&size, 1, MPI_INT, buffer, LENGTH, &position, MPI_COMM_WORLD);
							for (int i=0; i<size; i++) {
								// Convert string to char*
								string str = mList.front();
								mList.pop_front();
								int stringLength = str.length()+1;
								char* stringMessage = new char[stringLength];
								strcpy(stringMessage,str.c_str());
								stringMessage[str.length()] = '\0';
								// Packing string
								MPI_Pack(&stringLength, 1, MPI_INT, buffer, LENGTH, &position, MPI_COMM_WORLD);
								MPI_Pack(stringMessage, stringLength, MPI_CHAR, buffer, LENGTH, &position, MPI_COMM_WORLD);
								//cout << "REQUEST " << status.MPI_SOURCE << " posilam na " << my_rank << ", " << stringMessage << " = " << stringLength << endl;
								delete []stringMessage;
							}
							// Send data
							MPI_Send(buffer, position, MPI_PACKED, status.MPI_SOURCE, MSG_WORK_SENT, MPI_COMM_WORLD);
							// Flag for token
							if (my_rank > status.MPI_SOURCE) {
								flagForToken = true;
							}
						}
						break;
					case MSG_WORK_SENT: // Recieved part of stack
						position = 0;
						/* Recieving data */
						MPI_Recv(buffer, LENGTH, MPI_PACKED, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
						/* Unpacking data */
						MPI_Unpack(buffer, LENGTH, &position, &number, 1, MPI_INT, MPI_COMM_WORLD);
						for (int i=0; i<number; i++) {
							int stringLength = 0;
							MPI_Unpack(buffer, LENGTH, &position, &stringLength, 1, MPI_INT, MPI_COMM_WORLD );
							char* stringMessage = new char[stringLength];
							MPI_Unpack(buffer, LENGTH, &position, stringMessage, stringLength, MPI_CHAR, MPI_COMM_WORLD);
							list.push_front(stringMessage);
							//cout << "SENT, " << my_rank  << "obdrzel data od " << status.MPI_SOURCE << "=" << list.front() << " = " << stringLength << endl;
							delete []stringMessage;
						}
						break;
					case MSG_WORK_NOWORK: // odmitnuta zadost o praci
						MPI_Recv(&message, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
						if ((--dest_process) < 0) {
							dest_process = p-1;
						}
						
						if (dest_process != my_rank) {
							MPI_Send(&dest_process, 1, MPI_INT, dest_process, MSG_WORK_REQUEST, MPI_COMM_WORLD);
							//cout << my_rank << " NOWORK, ptam se dal procesu " << dest_process << endl;
						} else {
							//cout << my_rank << " NOWORK... break!" << endl;
							if (my_rank != 0) {
								break; // Passive mode... waiting for TOKEN
							} else {
								int token = 1; // 1 = white / 0 = black
								MPI_Send(&token, 1, MPI_INT, 1, MSG_TOKEN, MPI_COMM_WORLD);
							}
						}
						break;
					case MSG_TOKEN: // ukoncovaci token, prijmout a nasledne preposle (bily, cerny)
						// Recieve token
						int token;
						MPI_Recv(&token, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
						
						//cout << my_rank << " TOKEN = " << token << " flag =" << flagForToken << endl;
						
						// Send token
						if (my_rank != 0) {
							int dest_process = (my_rank+1)%p;
							if (token == 1 && list.empty()) {
								if(flagForToken == false) {
									MPI_Send(&token, 1, MPI_INT, dest_process, MSG_TOKEN, MPI_COMM_WORLD);
								} else {
									flagForToken = false;
									token = 0; // token is set black
									MPI_Send(&token, 1, MPI_INT, dest_process, MSG_TOKEN, MPI_COMM_WORLD);
								}
							} else {
								flagForToken = false;
								token = 0; // token is set black
								MPI_Send(&token, 1, MPI_INT, dest_process, MSG_TOKEN, MPI_COMM_WORLD);
								
							}
						} else {
							if (token == 1) { // 1 = white
								// Send finish message all of process
								for (int dest_process=1; dest_process<p; dest_process++) {
									MPI_Send(&token, 1, MPI_INT, dest_process, MSG_FINISH, MPI_COMM_WORLD);
								}
							} else { // 0 = black
								token = 1;
								MPI_Send(&token, 1, MPI_INT, 1, MSG_TOKEN, MPI_COMM_WORLD);
							}
						}
						break;
					case MSG_FINISH: //konec vypoctu (proces 0 zjistil ze nikdonema pracio), ???bariera???
						if(my_rank != 0) {
							MPI_Recv(&token, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
							
							// String to char*
							int stringLength = result.length()+1;
							char* stringMessage = new char[stringLength];
							strcpy(stringMessage,result.c_str());
							stringMessage[result.length()] = '\0';
							// Packing string
							position = 0;
							MPI_Pack(&stringLength, 1, MPI_INT, buffer, LENGTH, &position, MPI_COMM_WORLD);
							if (stringLength > 1)
								MPI_Pack(stringMessage, stringLength, MPI_CHAR, buffer, LENGTH, &position, MPI_COMM_WORLD);
							delete []stringMessage;
							// Send data
							MPI_Send(buffer, position, MPI_PACKED, 0, MSG_FINISH, MPI_COMM_WORLD);
							// Shut down MPI
							MPI_Finalize();
							
							//cout << "FINISH " << my_rank << endl;
							return 0;
						} else {
							/* Recieving data */
							MPI_Recv(buffer, LENGTH, MPI_PACKED, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
							//cout << "almostFINISH " << my_rank << "od " << status.MPI_SOURCE << endl;
							/* Unpacking data */
							position = 0;
							int stringLength = 0;
							MPI_Unpack(buffer, LENGTH, &position, &stringLength, 1, MPI_INT, MPI_COMM_WORLD);
							if (stringLength > 1) {
								char* stringMessage = new char[stringLength];
								MPI_Unpack(buffer, LENGTH, &position, stringMessage, stringLength, MPI_CHAR, MPI_COMM_WORLD);
								string s(stringMessage);
								if (result.length() > s.length() || result.length() == 0)
									result = s;
								delete []stringMessage;
							}
							// Count finished processes
							countFinish++;
							
							if (countFinish == p) {
								// Finish zero process
								//cout << "FINISH " << my_rank << endl;
								if (result.size() > 0) {
									cout << "String, which contains all substring EXISTS and its length is " << result.size() << "." << endl;
									cout << "w = " << result << endl;
									cout << "------------- OUTPUT -------------" << endl;
									for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
										int pos = result.find(*itList);
										cout << result.substr(0,pos) << "-" << *itList << "-" << result.substr(pos + (*itList).size()) << endl;
									}
								} else
									cout << "String, which contains all substring DON'T EXISTS and its length is." << endl;
								
								// Shut down MPI
								MPI_Finalize();
								return 0;
							}
						}
						break;
					case MSG_K_HIGHER:
						int new_k;
						MPI_Recv(&new_k, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
						// Change k
						if (k > new_k) {
						    //cout << my_rank << " HIGHER K = " << new_k << " (old=" << k << ")" << endl;
						    k = new_k;
						}
						break;
					case MSG_K_EQUAL_M:
						if (my_rank == 0) {
							// Recieving data
							MPI_Recv(buffer, LENGTH, MPI_PACKED, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
							// Unpacking data
							position = 0;
							int stringLength = 0;
							MPI_Unpack(buffer, LENGTH, &position, &stringLength, 1, MPI_INT, MPI_COMM_WORLD);
							char* stringMessage = new char[stringLength];
							MPI_Unpack(buffer, LENGTH, &position, stringMessage, stringLength, MPI_CHAR, MPI_COMM_WORLD);
							string s(stringMessage);
							result = s;
							delete []stringMessage;
							
							// Sent all process 
							for (int dest_process=1; dest_process<p; dest_process++) {
								MPI_Send(&k, 1, MPI_INT, dest_process, MSG_K_EQUAL_M, MPI_COMM_WORLD);
							}
							
							// Print out reuslt
							//cout << "k=m FINISH " << my_rank << endl;
							cout << "String, which contains all substring EXISTS and its length is " << result.size() << "." << endl;
							cout << "w = " << result << endl;
							cout << "------------- OUTPUT -------------" << endl;
							for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
								int pos = result.find(*itList);
								cout << result.substr(0,pos) << "-" << *itList << "-" << result.substr(pos + (*itList).size()) << endl;
							}
							
							/* Shut down MPI */
							MPI_Finalize();
							return 0;
						} else {
							MPI_Recv(&k, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
							// Shut down MPI
							MPI_Finalize();
							//cout << "FINISH " << my_rank << endl;
							return 0;
						}
						break;
					default: // error
						break;
				}
			}
		}
	}

	// Print result (only if is single process)
	if (result.size() > 0) {
		cout << "String, which contains all substring EXISTS and its length is " << result.size() << "." << endl;
		cout << "w = " << result << endl;
		cout << "------------- OUTPUT -------------" << endl;
		for (std::list<string>::iterator itList = listStrings.begin(); itList!=listStrings.end(); itList++) {
			int pos = result.find(*itList);
			cout << result.substr(0,pos) << "-" << *itList << "-" << result.substr(pos + (*itList).size()) << endl;
		}
	} else
		cout << "String, which contains all substring DON'T EXISTS and its length is." << endl;

	/* Shut down MPI */
	MPI_Finalize();
	return 0;
}
