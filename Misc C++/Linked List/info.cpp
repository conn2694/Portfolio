// StudentInfo specification file

#include "stdafx.h"
#include "StudentInfo.h"
#include <string>
using namespace std;

StudentInfo::StudentInfo() {

	name = "";
	id = 0;
	address = "";
	GPA = 0.0;

}

StudentInfo::StudentInfo(string n, int i, string a, double g) {

	name = n;
	id = i;
	address = a;
	GPA = g;

}