import 'package:treatbees/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class Payments {

  String userEmail, cafecode, time, userPhno, userName, docName, type, cafeName;
  List<Map<String, dynamic>> orderItems = [];
  String paymentId;
  BuildContext context;

  Payments(
      String docName,
      String userName,
      String userEmail,
      String cafecode,
      String time,
      String userPhno,
      List<Map<String, dynamic>> orderItems,
      BuildContext context,
      String type,
      String cafeName
      ) {
    this.docName = docName;
    this.userName = userName;
    this.userEmail = userEmail;
    this.cafecode = cafecode;
    this.time = time;
    this.orderItems = orderItems;
    this.userPhno = userPhno;
    this.context = context;
    this.type = type;
    this.cafeName = cafeName;

  }

}
