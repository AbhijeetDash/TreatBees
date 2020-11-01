class Selections {
  // This is the View Class out of MVC...
  // This contains all the getter and setter methods for all the variables..
  // Null within an object is allowed//

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
  }

  void popItem(String key, int price) {
    selectedPrice.removeAt(selectedName.indexOf(key));
    numVal.removeAt(selectedName.indexOf(key));
    selectedName.remove(key);
  }

  void update(int no, String key) {
    selectedPrice[selectedName.indexOf(key)] +=
        selectedPrice[selectedName.indexOf(key)];
    numVal[selectedName.indexOf(key)] = no;
  }
}
