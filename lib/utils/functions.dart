import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCallbacks {
  Future<bool> createGroup(String groupName, String adminMail) {
    HttpsCallable createGroupCallable = FirebaseFunctions.instance
        .httpsCallable('createGroup', options: HttpsCallableOptions());
    return createGroupCallable
        .call(<Map>[
          {"groupName": groupName, "adminMail": adminMail}
        ])
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<dynamic> getGroups() async {
    HttpsCallable getGroupsCallable =
        FirebaseFunctions.instance.httpsCallable('getGroups');
    return getGroupsCallable.call().then((value) => value.data);
  }

  Future<dynamic> createUser(String email, String name, String phoneNum) {
    HttpsCallable createUserCallable =
        FirebaseFunctions.instance.httpsCallable('createUser');
    return createUserCallable.call(<Map>[
      {"userEmail": email, "userName": name, "userPhone": phoneNum}
    ]);
  }

  Future<dynamic> getCurrentUser(String userMail) {
    HttpsCallable getCurrentUser =
        FirebaseFunctions.instance.httpsCallable('getCurrentUser');
    return getCurrentUser.call([
      {"userMail": userMail}
    ]).then((value) => value.data);
  }

  void placeOrder(
    String userEmail,
    String userPhno,
    String cafecode,
    String time,
    List<Map> orderItems,
    String paymentId,
  ) {
    HttpsCallable placeOrderCallable =
        FirebaseFunctions.instance.httpsCallable('createOrder');
    placeOrderCallable.call(<Map>[
      {
        "userMail": userEmail,
        "userPhone": userPhno,
        "cafecode": cafecode,
        "orderItems": orderItems,
        "paymentID": paymentId,
        "orderTime": time,
        "orderStatus": "ordered"
      }
    ]).then((value) {});
  }

  Future<dynamic> getCarousels() async {
    HttpsCallable getCarouselCallable =
        FirebaseFunctions.instance.httpsCallable('getCarousels');
    return getCarouselCallable.call().then((value) {
      return value.data;
    });
  }

  Future<dynamic> getTodaysOrders(
    String userEmail,
  ) async {
    DateTime now = DateTime.now();
    String day = '${now.day} : ${now.month} : ${now.year}';
    HttpsCallable currentOrders =
        FirebaseFunctions.instance.httpsCallable('getCurrentOrders');
    return currentOrders.call([
      {"OF": day, "userMail": userEmail}
    ]).then((value) => value.data);
  }

  Future<dynamic> getCafe() async {
    HttpsCallable getAllCafe =
        FirebaseFunctions.instance.httpsCallable('getAllCafe');
    return getAllCafe.call().then((value) {
      return value.data;
    });
  }
}
