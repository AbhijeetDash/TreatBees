import 'package:flutter/foundation.dart';

class Selections {
  List<String> selectedName = [];
  List<int> selectedPrice = [];
  List<int> numVal = [];

  bool contains(String key) {
    selectedName.forEach((element) {
      if (element == key) {
        return true;
      }
    });
    return false;
  }

  void pushItem(String key, int price) {
    selectedName.add(key);
    selectedPrice.add(price);
    numVal.add(1);
    print(selectedName);
    print(selectedPrice);
  }

  bool popItem(String key, int price) {
    selectedPrice.removeAt(selectedName.indexOf(key));
    numVal.remove(selectedName.indexOf(key));
    selectedName.remove(key);
    print(selectedName);
    print(selectedPrice);
  }

  void update(int no, String key) {
    selectedPrice[selectedName.indexOf(key)] +=
        selectedPrice[selectedName.indexOf(key)];
    numVal[selectedName.indexOf(key)] = no;
    print(selectedName);
    print(selectedPrice);
    print(numVal);
  }
}
