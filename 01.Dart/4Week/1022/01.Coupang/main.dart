// 지시사항 1: ItemStatus enum을 정의하세요.
enum ItemStatus {
  pending,
  purchased,
  canceled,
}

// 지시사항 2: Item sealed class를 정의하세요.
sealed class Item {
  String name;
  int quantity;
  ItemStatus status;

  Item(this.name, this.quantity, this.status);

  void markAsPurchased() {
    status = ItemStatus.purchased;
  }

  void markAsCanceled() {
    status = ItemStatus.canceled;
  }
}

// 지시사항 3: GroceryItem 클래스를 정의하고 Item 클래스로부터 상속받으세요.
class GroceryItem extends Item {
  GroceryItem({required String name, required int quantity}) : super(name, quantity, ItemStatus.pending);
}

class ShoppingList {
  final List<Item> _items = [];

  List<Item> get items => _items;

  //  [{
  //       name : '', quatity : , status :
  //     },
  //     {
  //       name : '', quatity : , status :
  //     },
  //     {
  //       name : '', quatity : , status :
  //     }
  //   ];

  // 아이템을 스테이터스로 필터해서 해당하는 스테이터스만 가져와야한다

  List<Item> getItemsByStatus(ItemStatus status) {
    // map : 리스트 안에 요소를 변경해야하는경우
    // where : 요소를 변경하지 않지만 특정 조건으로 필터할때
    // every
    // reduce

    // return _items.reduce( (acc, cur) => { acc = cur.where( itm.sttus == status)})
    return _items.where((item) => item.status == status).toList();
    // return _items.firstWhere((item) => item.status == status).
  }

  // 지시사항 4: ShoppingList 클래스에 필요한 메서드를 추가하세요.
  void addItem(Item item) {
    _items.add(item);
  }

  void removeItem(Item item) {
    _items.remove(item);
  }
}

// 각 아이템을 문자열로 포맷합니다.
String formatItems(List<Item> items) {
  return items.map((item) => '${item.name} (${item.quantity}) - ${item.status}').join(', ');
}

void main() {
  late ShoppingList shoppingList;

  shoppingList = ShoppingList();
  shoppingList.addItem(GroceryItem(name: 'Apples', quantity: 10));
  shoppingList.addItem(GroceryItem(name: 'Bread', quantity: 2));
  shoppingList.addItem(GroceryItem(name: 'Milk', quantity: 1));

  shoppingList.items[0].markAsPurchased();
  shoppingList.items[1].markAsCanceled();

  print('Purchased Items: ${formatItems(shoppingList.getItemsByStatus(ItemStatus.purchased))}');
  print('Pending Items: ${formatItems(shoppingList.getItemsByStatus(ItemStatus.pending))}');
  print('Canceled Items: ${formatItems(shoppingList.getItemsByStatus(ItemStatus.canceled))}');
}
