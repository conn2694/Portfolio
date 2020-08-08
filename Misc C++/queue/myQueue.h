#ifndef _MYQUEUE_H_
#define _MYQUEUE_H_

using namespace std;

template <class T>
class myQueue {
public:
	myQueue(int maxSz);
	~myQueue();
	void enqueue(T item);
	T dequeue();
    int currentSize();
    bool isEmpty();
    bool isFull();

private:
	T *contents; /*Dynamic initiate (C++ keyword new) the holder array*/
	int front,rear;  /*Index in the array of the front and rear element*/
	int arrayLength;  /*The length of the contents holder array*/
		/* Keep in mind that the Queue will only hold up to (arrayLength - 1) elements*/
};

template <class T>
myQueue<T>::myQueue(int maxSz) {
	// TODO
	arrayLength = maxSz + 1;
	contents = new T [arrayLength];
}

template <class T>
myQueue<T>::~myQueue() {
	// TODO:
	delete[] contents;
}

template <class T>
void myQueue<T>::enqueue(T item) {
	// TODO
	rear = (rear + 1) % (arrayLength);
	contents[rear] = item;
}

template <class T>
T myQueue<T>::dequeue() {
	// TODO
	front = (front + 1) % (arrayLength);
	return contents[front];
}

template <class T>
int myQueue<T>::currentSize() {
	// TODO
	return (rear - front);
}

template <class T>
bool myQueue<T>::isEmpty() {
	// TODO
	if (currentSize() <= 0) { return true; }
	else { return false; }
}

template <class T>
bool myQueue<T>::isFull() {
	// TODO
	if (currentSize() >= arrayLength - 1) { return true; }
	else { return false; }
}

#endif
