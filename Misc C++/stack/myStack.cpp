#include <iostream>
#include "myStack.h"

using namespace std;

/*
 * Constructor
 * Usage: myStack(maxSz);
 * -------------------------
 * A new stack variable is initialized.  The initialized
 * stack is made empty.  maxSz is used to determine the
 * maximum number of character that can be held in the
 * stack.
 */

myStack::myStack(int maxSz) {
	// TODO
	maxSize = maxSz;
	contents = new int [maxSize];
	top = -1;
}


/* Destructor
 * Usage: delete ptr
 * -----------------------
 * This frees all memory associated with the stack.
 */

myStack::~myStack() {
	// TODO
	delete[] contents;
}

/*
 * Functions: push, pop
 * Usage: s1.push(element); element = s1.pop();
 * --------------------------------------------
 * These are the fundamental stack operations that add an element to
 * the top of the stack and remove an element from the top of the stack.
 * A call to pop on an empty stack or to push on a full stack
 * is an error.  Make use of isEmpty()/isFull() (see below)
 * to avoid these errors.
 */

void myStack::push(int element) {
	// TODO
	if (!isFull()) {
		top++;
		contents[top] = element;
		// Used for testing that numbers are being added, removed, and operated on apropriately in the stack.
		//for (int i = 0; i < (top + 1); i++) {cout << contents[i] << '\t';}
	}
}

int myStack::pop() {
	// TODO
	if (!isEmpty()) {
		top--;
		return contents[top + 1];
	}
	else { return 0; }
}

/*
 * Functions: isEmpty, isFull
 * Usage: if (s1.isEmpty()) ...
 * -----------------------------------
 * These return a true value if the stack is empty
 * or full (respectively).
 */

bool myStack::isEmpty() const {
	// TODO
	if (top < 0) {
		return true;
	}
	else { return false; }
}

bool myStack::isFull() const {
	// TODO
	if (top >= (maxSize -1) )  {
		return true;
	}
	else { return false; }
}

