#ifndef _MYSTACK_H_
#define _MYSTACK_H_

class myStack {
public:
	myStack(int maxSz);
	~myStack();
	void push(int element);
	int pop();
	bool isEmpty() const;
	bool isFull() const;

private:
	int *contents; /*Dynamic initiate (C++ keyword new) the holder array*/
	int top;  /*Index in the array of the top element*/
	int maxSize;  /*Max number of elements could be in this stack*/
};

#endif
