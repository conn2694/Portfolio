// LinkedList Header File
#ifndef __LINKEDLIST_H__
#define __LINKEDLIST_H__
#include <string>
#include <iostream>
#include "StudentInfo.h"	// Our Student Class
using namespace std;

class LinkedList
{

private:

	struct ListNode {

		StudentInfo value;
		ListNode *next;

	};
	ListNode *head;

public:
	LinkedList() { head = nullptr; }
	~LinkedList();

	void appendNode(StudentInfo);
	void insertNode(StudentInfo);
	void deleteNode(StudentInfo);
	void displayList();

};
#endif
