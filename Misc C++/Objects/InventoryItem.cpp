// Inventory Item specification file

#include "stdafx.h"
#include "InventoryItem.h"
#include <string>
using namespace std;

InventoryItem::InventoryItem(int i, int q, double c) {
	itemNumber = i;
	while (i < 0) {
		cout << "The inventory number can only be a positive value, please enter again with a positive value: ";
		cin >> i;
		itemNumber = i;
	}
	quantity = q;
	while (q < 0) {
		cout << "The quantity amount can only be a positive value, please enter again with a positive value: ";
		cin >> q;
		quantity = q;
	}
	cost = c;
	while (c < 0) {
		cout << "The cost can only be a positive value, please enter again with a positive value: ";
		cin >> c;
		cost = c;
	}
	totalCost = q * c;
}

void InventoryItem::setItemNumber(int i) {
	itemNumber = i;
	while (i < 0) {
		cout << "The inventory number can only be a positive value, please enter again with a positive value: ";
		cin >> i;
		itemNumber = i;
	}

}
void InventoryItem::setQuantity(int q) {
	quantity = q;
	while (q < 0) {
		cout << "The quantity amount can only be a positive value, please enter again with a positive value: ";
		cin >> q;
		quantity = q;
	}
}
void InventoryItem::setCost(double c) {
	cost = c;
	while (c < 0) {
		cout << "The cost can only be a positive value, please enter again with a positive value: ";
		cin >> c;
		cost = c;
	}
}