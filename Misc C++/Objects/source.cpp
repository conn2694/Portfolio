// Inventory Item by Nicholas Williams

#include "stdafx.h"	// For Visual Studio
#include <iostream>	// Cout and cin
#include <string>	// String class
#include <fstream>	// For opening file
#include <iomanip>	// For formatting output
#include "InventoryItem.h"	// Our Inventory Item Class
using namespace std;

// Prototypes
int binarySearch(InventoryItem[], int, int);

// Reads from file amnd puts it into data and search with it
int main() {

	// Declare Variables
	fstream currInventory;
	InventoryItem * item = nullptr;
	int amountInv;

	// Open File
	currInventory.open("../currentInventory.txt", ios::in);
	if (currInventory.fail()) {
		cout << "Error";
	}

	// See how many items we have
	amountInv = 1;	// Assume we have at least one item
	while (!currInventory.eof()) {

		string line;

		getline(currInventory, line, '\n');

		// Blank Line
		if (line == "") {
			amountInv++;
		}
	}

	// Reset file back to the beginning
	currInventory.clear();
	currInventory.seekg(0, ios::beg);

	item = new InventoryItem[amountInv];

	// Read file into memory
	for (int i = 0; i < amountInv; i++) {

		// Temporary variables that will be set in our objects
		int numTemp;
		int quantityTemp;
		double costTemp;

		currInventory >> numTemp;
		currInventory >> costTemp;
		currInventory >> quantityTemp;



		// Skip the '\n'
		currInventory.get();
		currInventory.get();

		item[i].setItemNumber(numTemp);
		item[i].setCost(costTemp);
		item[i].setQuantity(quantityTemp);
		item[i].setTotalCost();


	}

	// Close the file
	currInventory.close();

	// File Output
	cout << "Full output from the file now in memory:\n";
	for (int i = 0; i < amountInv; i++) {
		cout << item[i].getItemNumber() << '\n';
		cout << item[i].getCost() << '\n';
		cout << item[i].getQuantity() << '\n';
		cout << item[i].getTotalCost() << "\n\n";
	}

	// Searching
	char inputLoop = 'y';
	while (inputLoop == 'y') {

		int searchInt;
		int result;

		cout << "Search by inventory number and we'll return its info: ";
		cin >> searchInt;

		result = binarySearch(item, amountInv, searchInt);

		if (result == -1) {
			cout << "We couldn't find that item.\n";
		}
		else {
			cout << "Here's some info about your item:\n";
			cout << fixed << setprecision(2);
			cout << "Cost: $” << item[result].getCost() << '\n';
			cout << "Quantity: " << item[result].getQuantity() << '\n';
			cout << "Total Cost: $” << item[result].getTotalCost() << '\n';
		}
		cout << "Search again? (y/n): ";
		cin >> inputLoop;
		cout << '\n';

	}

	cout << "Thank you for using the program\n";

	delete[] item;
    return 0;

}

// Binary search through our item numbers
int binarySearch(InventoryItem list[], int elementSize, int value) {

	// Declare Variables
	int first = 0;
	int last = elementSize - 1;
	int middle;
	int position = -1;
	bool found = false;

	while (!found && (first <= last)) {
		middle = (first + last) / 2;	// midpoint calculation
		if (list[middle].getItemNumber() == value) {
			found = true;
			position = middle;
		}

		else if (list[middle].getItemNumber() > value) {
			last = middle - 1;	// we subtract the old middle since we already know that 
								// isn't the answer and there's no reason to waste the calculation
		}

		// implies list[middle] < value
		else {
			first = middle + 1;
		}
	}
	return position;
}
