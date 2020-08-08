#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void printFrames(int*, int);

int main() {	
	/* Variable declarations */
	int strLength;
	int *str; 
	int i, j, k;
	int numFrames = -1; /* -1 to enter the while loop */
	int *frame; 
	int faultCount = 0;
	int freeSlot = 0;
	int optFault = 0;
	int lruFault = 0;

	printf("String of Pages:\n");
	srand(time(0));
	strLength = 5 + (rand() % 15); /* random number of strings from 5 to strLength */
	str = (int *) malloc(sizeof(int) * strLength);
	for (i = 0; i < strLength; i++) {
		str[i] = rand() % 5 + 1;
		printf("%d  ", str[i]);
	}
	printf("\n");

	/* input validation, gets number of frames */	
	while (numFrames < 0 || numFrames > strLength) {
		
		printf("Please enter the frame size: ");
		scanf("%d", &numFrames);
		
		if (numFrames < 0 || numFrames > strLength) {
			printf("Error: Please enter a number between 0 and strLength\n");
		}
	}

	frame = (int *) malloc(sizeof(int) * numFrames);

	/* Optimal */
	printf("\n**************\nOPTIMAL TEST\n**************\n");
	for (i = 0; i < strLength; i++) {
		int noFault = 0;
		for (j = 0; j < numFrames; j++) {
			if (frame[j] == str[i]) {
				noFault = 1;		
			}
		}

		if (noFault == 0) {
			faultCount++;
			/* Frames aren't filled in yet */
			if (freeSlot < numFrames) {
				frame[freeSlot] = str[i];	
				freeSlot++;
				printf("Fault Found, putting %d into empty frame %d\n", str[i], freeSlot); 
				printFrames(frame, numFrames);
			}
			else {	
				int leastUsed = i; /* where we are currently in the total scan */
				int leastUsefulFrame = 0;
				int noMatch = 0;
				for (j = 0; j < numFrames && noMatch == 0; j++) {
							
					int newReplace = 0;
					int found = 0;
					for (k = i+1; k < strLength && newReplace == 0; k++) {
						/* found a match */
						if (str[k] == frame[j]) {
							/* Only replace if this match is farther away than the previous leastUsed */
							if (k > leastUsed) {
								leastUsed = k;
								leastUsefulFrame = j;
							}
							found = 1;
							newReplace = 1; /*exit loop */
						}
					}
					/* if it's not even found in the future just automatically replace it */
					if (found == 0) {
						printf("Fault Found, No future case for %d in frame %d, replacing with %d \n", frame[j], j+1, str[i]); 
						frame[j] = str[i];
						printFrames(frame, numFrames);
						noMatch = 1; /* exit loop early */
					}
				}
				/* if there is a match for every frame */
				if (noMatch == 0) {

					printf("Fault Found, replacing %d in frame %d with %d \n", frame[leastUsefulFrame], leastUsefulFrame+1, str[i]); 
					frame[leastUsefulFrame] = str[i];
					printFrames(frame, numFrames);

				}
			}	
		}
	
	}
	printf("There were %d faults\n", faultCount);
	optFault = faultCount;

	faultCount = 0;
       	freeSlot = 0; /* Reset for LRU test */
	for (i = 0; i < numFrames; i++) {
		frame[i] = 0;
	}
	/* LRU */
	printf("\n**************\nLRU TEST\n**************\n");
	for (i = 0; i < strLength; i++) {
		int noFault = 0;
		for (j = 0; j < numFrames; j++) {
			if (frame[j] == str[i]) {
				noFault = 1;		
			}
		}

		if (noFault == 0) {
			faultCount++;
			/* Frames aren't filled in yet */
			if (freeSlot < numFrames) {
				frame[freeSlot] = str[i];	
				freeSlot++;
				printf("Fault Found, putting %d into empty frame %d\n", str[i], freeSlot); 
				printFrames(frame, numFrames);
			}
			else {	
				int leastUsed = i; /* where we are currently in the total scan */
				int leastUsefulFrame = 0;
				for (j = 0; j < numFrames; j++) {
							
					int newReplace = 0;
					int found = 0;
					/* goes in past this time, counts backwards */
					for (k = i-1; k >= 0 && newReplace == 0; k--) {
						/* found a match */
						if (str[k] == frame[j]) {
							/* Only replace if this match is farther away than the previous leastUsed */
							if (k < leastUsed) {
								leastUsed = k;
								leastUsefulFrame = j;
							}
							found = 1;
							newReplace = 1; /*exit loop */
						}
					}
				}
				/* When looking at the past there's no need to check for a number never showing up  */
				printf("Fault Found, replacing %d in frame %d with %d \n", frame[leastUsefulFrame], leastUsefulFrame+1, str[i]); 
				frame[leastUsefulFrame] = str[i];
				printFrames(frame, numFrames);
				
			}	
		}
	
	}
	printf("There were %d faults\n", faultCount);
	lruFault = faultCount;

	printf("\n**************\nRESULTS\n**************\n");
	printf("The LRU algorithm had %d faults, %d more than the optimal algorithm, which had %d.\n", lruFault, lruFault - optFault, optFault);
}

void printFrames(int *frame, int numFrames) {

	printf("{");
	int count = 0;
	for (count = 0; count < numFrames; count++) {
		if (frame[count] != 0) {
			printf(" %d ", frame[count]);
		}
	}
        printf("}\n");	
}
