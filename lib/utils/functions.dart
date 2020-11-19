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

  void placeOrder(
    String userEmail,
    cafename,
    time,
    List<Map> orderItems,
    String paymentId,
  ) {
    HttpsCallable placeOrderCallable =
        FirebaseFunctions.instance.httpsCallable('createOrder');
    //[{"ItemName":,"ItemQuantity":,"TotalPrice":,"OptionalAddons":,}]
    placeOrderCallable.call(<Map>[
      {
        "userMail": userEmail,
        "cafeName": cafename,
        "orderItems": orderItems,
        "paymentID": paymentId,
        "orderTime": time,
        "orderStatus": "ordered"
      }
    ]).then((value) {
      print(value);
    });
  }
}
