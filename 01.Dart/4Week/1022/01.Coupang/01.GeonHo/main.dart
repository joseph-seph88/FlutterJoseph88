enum ItemStatus { purchased, pending, canceled }

sealed class Item {
  void markAsPurchased();

  void markAsCanceled();
}

class GroceryItem extends Item {
  String name;
  int quantity;
  ItemStatus status = ItemStatus.pending;

  GroceryItem({required this.name, required this.quantity});

  @override
  void markAsPurchased() {
    status = ItemStatus.purchased;
  }

  @override
  void markAsCanceled() {
    status = ItemStatus.canceled;
  }
}

class ShoppingList {
  List<GroceryItem> items = [];

  void addItem(GroceryItem groceryTiem) {
    items.add(groceryTiem);
  }

  List<GroceryItem> getItemsByStatus(ItemStatus status) {
    List<GroceryItem> resultList = [];

    for (GroceryItem item in items) {
      if (item.status == status) {
        resultList.add(item);
      }
    }

    return resultList;
  }
}

void main() {
  late ShoppingList shoppingList;

  shoppingList = ShoppingList();

  shoppingList.addItem(GroceryItem(name: "Apples", quantity: 10));
  shoppingList.addItem(GroceryItem(name: "Bread", quantity: 2));
  shoppingList.addItem(GroceryItem(name: "Milk", quantity: 1));

  shoppingList.items[0].markAsPurchased();
  shoppingList.items[1].markAsPurchased();
  shoppingList.items[2].markAsCanceled();

  print("Purchased Items : ${formatItems(shoppingList.getItemsByStatus(ItemStatus.purchased))}");
  print("Pending Items : ${formatItems(shoppingList.getItemsByStatus(ItemStatus.pending))}");
  print("Canceled Items : ${formatItems(shoppingList.getItemsByStatus(ItemStatus.canceled))}");
}

String formatItems(List<GroceryItem> items) {
  if (items.isEmpty) {
    return "no item";
  }

  String result = "";

  for (GroceryItem item in items) {
    result += "name : ${item.name} / quantity : ${item.quantity}, ";
  }

  return result.substring(0, result.length - 2);
}
