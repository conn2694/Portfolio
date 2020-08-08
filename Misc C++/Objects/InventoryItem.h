// Inventory Item header file

#include <iostream>
#include <iomanip> // for formatting
using namespace std;
class InventoryItem
{
public:
	InventoryItem() {
		itemNumber = 0;
		quantity = 0;
		cost = 0.0;
		totalCost = 0.0;
	}

	InventoryItem(int i, int q, double c);

	void setItemNumber(int i);
	void setQuantity(int q);
	void setCost(double c);
	void setTotalCost() { totalCost = cost * quantity; };

	int getItemNumber() { return itemNumber; };
	int getQuantity() { return quantity; };
	double getCost() { return cost; };
	double getTotalCost() { return totalCost; };



private:
	int itemNumber;
	int quantity;
	double cost;
	double totalCost;
};

