#include <stdio.h>
#include <pthread.h>
#define _GNU_SOURCE /* Needed this on my machine for the program to compile properly */

void *thread1();
void *thread2();

pthread_mutex_t mutex;
pthread_cond_t thread1Go;
pthread_cond_t thread2Go;


int main() {

	pthread_t tid;
	pthread_setconcurrency(2);

	/* Create threads */
	pthread_create(&tid, NULL, (void *(*)(void *))thread1, NULL);
	pthread_create(&tid, NULL, (void *(*)(void *))thread2, NULL);

	pthread_exit(0);

}

void *thread1() {
	pthread_mutex_lock(&mutex);
	int i;
	int j;
	for (i = 0; i < 10; i++) {
		for (j = 0; j < 5; j++) {
			printf("%d: AAAAAAAAA \n", i+1); 
		}
		printf("\n");
		/* Continue thread2 */
		pthread_cond_broadcast(&thread2Go);
		if (i < 9) { /* Prevents a loop */
			pthread_cond_wait(&thread1Go, &mutex);
		}	
	}
	pthread_mutex_unlock(&mutex);
}

void *thread2() {
	pthread_mutex_lock(&mutex);
	int i;
	int j;
	for (i = 0; i < 10; i++) {
		for (j = 0; j < 5; j++) {
			printf("%d: BBBBBBBBB \n", i+1); 
		}
		printf("\n");
		pthread_cond_broadcast(&thread1Go);
		if (i < 9) {
			pthread_cond_wait(&thread2Go, &mutex);
		}	
	}
	pthread_mutex_unlock(&mutex);
}
