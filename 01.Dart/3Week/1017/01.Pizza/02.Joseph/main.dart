
class Pizza{
  Map<int, String> pizzaMaterial = {
    0x01: 'shrimp', 0x02: 'olive', 0x03: 'tomato',
    0x04: 'bulgogi', 0x05: 'pineapple', 0x06: 'onion',
    0x07: 'chicken', 0x08: 'cheese', 0x09: 'sweet potato',
    0x0A: 'potato', 0x0B: 'snack', 0x0C: 'rucola',
    0x0D: 'bacon', 0x0E: 'pepperoni', 0x0F: 'ham',
    0x10: 'sausage', 0x11: 'basil', 0x12: 'bell peppers',
  };

  List<String> cookingPizza = [];

  String? getPizzaMaterial(int tp2){
    return pizzaMaterial[tp2];
  }

  void makingPizza(String? pizzaMat1){
    cookingPizza.add(pizzaMat1!);
  }
  void printPizza(){
    print('** 시그니처 피자 완성 **\n토핑 종류: $cookingPizza\n토핑 개수: ${cookingPizza.length}');
  }
}



void main(){
  List<int> topping = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,
    0x0F, 0x10, 0x11, 0x12, 0x13, 0x14];
  Pizza pizza = Pizza();

  for(int tp2 in topping){
    if((tp2 & 0x01) == 1){
      String? pizzaMat2 = pizza.getPizzaMaterial(tp2);
      if(pizzaMat2 != null){
        pizza.makingPizza(pizzaMat2);
      }
    }
  }
  pizza.printPizza();
}