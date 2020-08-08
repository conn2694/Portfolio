#include <iostream>
#include "myQueue.h"

using namespace std;

int main() {
	cout << "Testing the template myQueue, try an integer queue as an example..." << endl;
	cout << "Please enter the max size of the int queue: ";
	int capacity;
	cin >> capacity;
	
	myQueue<int> testIntQ(capacity);
	
	while(1) {
		cout << "Please enter 'e' for enqueue, 'd' for dequeue, and 's' for stop." << endl;
		char userOption;
		cin >> userOption;
		
		if(userOption == 's')
			break;
			
		switch(userOption) {
			case 'e':
				if(!testIntQ.isFull()) {
					cout << "Please enter the integer you want to enqueue: ";
					int val;
					cin >> val;
					testIntQ.enqueue(val);
				}
				else
					cout << "Cannot enqueue. The queue is full." << endl;
				break;
			case 'd':
				if(!testIntQ.isEmpty())
					cout << testIntQ.dequeue() << " has been popped out." << endl;
				else
					cout << "Cannot pop. The queue is empty." << endl;
				break;
			default:
				cout << "Illegal input character for options." << endl;
		}
	}	
	
	return 0;
}
