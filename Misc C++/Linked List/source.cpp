// Fully Featured Linked List by Nicholas Williams

#include "stdafx.h"	// For Visual Studio
#include <iostream>	// Cout and cin
#include <string>	// String class
#include <fstream>	// For opening file
#include <iomanip>	// For formatting output
#include "StudentInfo.h"	// Our Student Class
#include "LinkedList.h"		// Our Linked List
using namespace std;


// Constants
const int NUM_OF_STUDENTS = 15;

int main() {

	// Declare Variables
	fstream studentFile;	// File Object
	StudentInfo student[NUM_OF_STUDENTS];	// Array of Student Objects
	LinkedList list;	// Linked List Object



	// Open file in desktop location
	studentFile.open("../studentInfo.txt", ios::in);
	if (studentFile.fail()) {
		cout << "Error";
	}

	// Reads the file into memory
	for (int i = 0; i < NUM_OF_STUDENTS; i++) {
		string tempName = "";	// for putting in the name of the student in the setter
		int tempId = 0;
		string tempAddress = "";
		double tempGPA = 0.0;

		getline(studentFile, tempName, '\n');	// need to use tempName since getline doesn't take functions
		studentFile >> tempId;
		studentFile.get();
		getline(studentFile, tempAddress, '\n');
		studentFile >> tempGPA;

		// Skip the '\n'
		studentFile.get();
		studentFile.get();


		// Puts the temporary variables into our setters
		student[i].setName(tempName);
		student[i].setId(tempId);
		student[i].setAddress(tempAddress);
		student[i].setGPA(tempGPA);

		// Append our linked list with the data
		list.insertNode(student[i]);

	}
	studentFile.close();	// No longer have use for file object

	cout << "Array of student info (unsorted):\n";
	cout << left << setw(15) << "Name" << setw(15) << "ID" << setw(25) << "Address" << setw(15) << "GPA" << endl;
	cout << "------------------------------------------------------------\n";
	for (int n = 0; n < NUM_OF_STUDENTS; n++) {

			// Display data of our students
			cout << setw(15) << student[n].getName();
			cout << setw(15) << student[n].getId();
			cout << setw(25) << student[n].getAddress();
			cout << setw(15) << fixed << setprecision(2) << student[n].getGPA() << '\n';

	}

	cout << "\nThe Linked List of student info (sorted):\n";
	list.displayList();

	cout << "\nLinked List after deleting Colin:\n";
	list.deleteNode(student[4]);
	list.displayList();

	cout << "\nLinked List after adding new student David:\n";
	StudentInfo newStudent("David", 4045946, "104 Brian Wilson St", 3.7);
	list.insertNode(newStudent);
	list.displayList();




	cin.get();	// Holds on the output
	return 0;

}

