#include <iostream>
#include "myStack.h"

using namespace std;

void postfixTest() {
	myStack operandStack(100);
	cout << "Please enter the operands (integers 1~9) and operators (+, -, *, /) one by one..." << endl;
	cout << "and enter '=' to indicate the end of the expression and to output the result." << endl;
			
	while(1){
		char inputHolder;
		cin >> inputHolder;
		// Because we want to start the operation from two down on the stack, we want two variables to hold both pops so we can properly do things like subtract (Kind of hacky, I'm sure there's a better way).
		int numberHolder;
		int numberHolder2;
		
		// TODO
		if (inputHolder == '+') { 
			numberHolder = operandStack.pop();
			if (operandStack.isEmpty()) { 
				cout << "Error! No sufficient operands.\n";
				break;
			}
			numberHolder2 = operandStack.pop();
			numberHolder = numberHolder2 + numberHolder;
			
		}
		else if (inputHolder == '-') {		

			numberHolder = operandStack.pop();
			if (operandStack.isEmpty()) { 
				cout << "Error! No sufficient operands.\n";
				break;
			}
			numberHolder2 = operandStack.pop();
			numberHolder = numberHolder2 - numberHolder;
		}
		else if (inputHolder == '/') {
			numberHolder = operandStack.pop();
			if (operandStack.isEmpty()) { 
				cout << "Error! No sufficient operands.\n";
				break;
			}
			numberHolder2 = operandStack.pop();
			numberHolder = numberHolder2 / numberHolder;
		}
		else if (inputHolder == '*') {	
			numberHolder = operandStack.pop();
			if (operandStack.isEmpty()) { 
				cout << "Error! No sufficient operands.\n";
				break;
			}
			numberHolder2 = operandStack.pop();
			numberHolder = numberHolder2 * numberHolder;
	
		}
		else if (inputHolder == '=') {
			numberHolder = operandStack.pop();
			if (operandStack.isEmpty()) { cout << "The entered post-fix expression results in " <<  numberHolder << '\n'; }
			else { cout << "The entered post fix expression was not a legal one" << '\n'; }
			break;
		}
		else {
			numberHolder = (int)inputHolder - 48; // doing it like this so we don't need to use atoi./Test

		}
		operandStack.push(numberHolder);
	}
}

int main()
{
    cout << "Testing the basic functions of the stack..." << endl;
	cout << "Please enter the max capacity of the testStack: ";
	int testSize;
	cin >> testSize;
	myStack testStack(testSize);
	
	cout << "Testing..." << endl;
	while(1) {
		cout << "Please enter 'p' for push, 'o' for pop, 'e' for exit:  ";
		char userChoice;
		cin >> userChoice;
		
		if(userChoice == 'e')
			break;
		
		switch (userChoice) {
			case 'p':			
				if(!testStack.isFull()) {
					cout << "Please enter the integer you would like to push: ";
					int userInt;
					cin >> userInt;
					testStack.push(userInt);
				}
				else
					cout << "Nothing has been pushed in. The stack is full!" << endl;
				break;
			case 'o':
				if(!testStack.isEmpty())
					cout << testStack.pop() << " has been popped out" << endl;
				else
					cout << "Nothing has been popped out. The stack is empty!" << endl;
				break;
			default:
				cout << "Illegal user-input character. Please try again." << endl;
		}
	}

	cout << "Now, start to use a stack to evaluate postfix expressions..." << endl;
	postfixTest();	
	
	return 0;
}

