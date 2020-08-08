// LinkedList specification file

#include "stdafx.h"
#include <iostream>
#include <iomanip>
#include "LinkedList.h"
using namespace std;

void LinkedList::appendNode(StudentInfo newValue) {

	ListNode *newNode;
	ListNode *nodePtr;

	// Creating the new node
	newNode = new ListNode;
	newNode->value = newValue;
	newNode->next = nullptr;

	// If this is the first node
	if (!head) {
		head = newNode;
	}

	// Otherwise place it at the end
	else {
		// Start from beginning
		nodePtr = head;
		
		// Goes until we get an empty next
		while (nodePtr->next) {
			nodePtr = nodePtr->next;
		}

		// Put our new node last
		nodePtr->next = newNode;

	}

}

void LinkedList::insertNode(StudentInfo newValue) {

	ListNode *newNode;
	ListNode *nodePtr;
	ListNode *previousNode = nullptr;

	// Creating the new node
	newNode = new ListNode;
	newNode->value = newValue;

	// If this is the first node
	if (!head) {
		head = newNode;
		newNode->next = nullptr;
	}

	// Otherwise insert node
	else {
		// Start from beginning
		nodePtr = head;

		previousNode = nullptr;

		// Goes until we get an empty next or next is less than our entered object ID
		while ( (nodePtr != nullptr) && (nodePtr->value.getId() < newValue.getId()) ) {
			previousNode = nodePtr;
			nodePtr = nodePtr->next;
		}

		// for if this is the smallest value yet
		if (previousNode == nullptr) {
			head = newNode;
			newNode->next = nodePtr;
		}
		//otherwise insert it between previousNode and nodePtr
		else {
			// Connects our new node to the two nodes it is in between
			previousNode->next = newNode;
			newNode->next = nodePtr;

		}

	}

}

void LinkedList::deleteNode(StudentInfo deleteValue) {


	ListNode *nodePtr;
	ListNode *previousNode = nullptr;

	// Creating the new node

	// If this is the first node
	if (!head) {
		return;
	}

	if (head->value.getId() == deleteValue.getId()) {
		nodePtr = head->next;
		delete head;
		head = nodePtr;
	}


	// Otherwise place it at the end
	else {
		// Start from beginning
		nodePtr = head;


		// Goes until we get an empty next or next the same as our entered object ID
		while (nodePtr != nullptr && nodePtr->value.getId() != deleteValue.getId()) {
			previousNode = nodePtr;
			nodePtr = nodePtr->next;
		}

		
		if (nodePtr) {
			previousNode->next = nodePtr->next;
			delete nodePtr;
		
		}
		

	}

}


void LinkedList::displayList() {
	
	ListNode *nodePtr;

	// Start from beginning
	nodePtr = head;

	cout << left << setw(15) << "Name" << setw(15) << "ID" << setw(25) << "Address" << setw(15) << "GPA" << endl;
	cout << "------------------------------------------------------------\n";
	// While we aren't at the end
	while (nodePtr) {
		// Display data of our students
		cout  << setw(15) << nodePtr->value.getName();
		cout << setw(15) << nodePtr->value.getId();
		cout << setw(25) << nodePtr->value.getAddress();
		cout << setw(15) << fixed << setprecision(2) << nodePtr->value.getGPA() << '\n';

		// Advance to next one
		nodePtr = nodePtr->next;
	}

}



LinkedList::~LinkedList()
{
	ListNode *nextNode;
	ListNode *nodePtr;

	// Start from beginning
	nodePtr = head;

	while (nodePtr != nullptr) {

		// Save position of the next next
		nextNode = nodePtr->next;
		// Delete current node
		delete nodePtr;
		// Assign our node to the saved address
		nodePtr = nextNode;
	}
}
