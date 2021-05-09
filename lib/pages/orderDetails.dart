import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:treatbees/pages/home.dart';
import 'package:treatbees/pages/menu.dart';
import 'package:treatbees/pages/userDetails.dart';
import 'package:treatbees/utils/functions.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:treatbees/utils/widget.dart';

class Ord extends StatefulWidget {
  final User user;
  final String cafeCode;
  final String userPhone;
  final Selection selection;
  final String cafeName;
  const Ord(
      {Key key,
      this.user,
      this.cafeCode,
      @required this.userPhone,
      @required this.selection,
      @required this.cafeName})
      : super(key: key);
  @override
  _OrdState createState() => _OrdState();
}

class _OrdState extends State<Ord> {

/// Payment code

  Razorpay _razorpay;

  //Widget delivery;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time, _session;
  int _nowHrs, _nowMin;
  TextEditingController _timeController = TextEditingController();
  String ndropdownValue = 'Delivery';
  int paymentType = 0;
  String paymentButtonText = 'Place Order';

  Color delCol;
  double total = 0;
  double paymentCharges = 0.0;
  double completeCharges = 0.0;
  bool isButtonEnabled;
  String docName;
  String orderType;
  String userAddress = '';
  bool showAddress = true;
  String loadingText = 'Loading payment options';

  List<Map<String, String>> orderItems = [];
  List<String> itemsNames = [];
  List<int> itemQuantity = [];
  List<int> price = [];
  List<int> indvPrice = [];
  List<String> collectOptions = [
    'Pre-order',
    'Takeout',
    'Delivery',
  ];

  void generateFinalData() {
    setState(() {
      for (var i = 0; i < itemsNames.length; i++) {
        orderItems.add({
          "ItemName": itemsNames[i].toString(),
          "ItemQuantity": itemQuantity[i].toString(),
          "TotalPrice": price[i].toString()
        });
      }
    });
  }

  void separate() {
    widget.selection.selected.forEach((element) {
      setState(() {
        itemsNames.add(element['DishName']);
        itemQuantity.add(int.parse(element['Quantity']));
        price.add(int.parse(element['Price']));
        indvPrice.add(
            (int.parse(element['Price']) * int.parse(element['Quantity'])));
      });
    });
  }

  void calTotalPrice() {
    setState(() {
      total = 0;
      indvPrice.forEach((element) {
        total += element;
      });
    });
    setState(() {
      paymentCharges = (((total / 0.98) - total)).ceilToDouble();
      completeCharges = total + paymentCharges;
    });
  }

  @override
  void initState() {
    FirebaseCallbacks().getCurrentUser(widget.user.email).then((value) {
      if (value['address'] != 'Not Provided') {
        setState(() {
          isButtonEnabled = true;
        });
      }
      setState(() {
        userAddress = value['address'];
        loadingText = 'We have following address.';
      });
    });
    separate();
    calTotalPrice();
    isButtonEnabled = false;
    delCol = MyColors().alice;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void gotohome() {
    Navigator.of(context).pop(PageRouteBuilder(
      pageBuilder: (a, b, c) {
        return Home(
          sp: null,
          user: widget.user,
          phone: widget.userPhone,
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(curve: Curves.ease, parent: animation);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ));
  }

  void doneDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Collected",
                    style: MyFonts().smallHeadingBold,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Enjoy your meal",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.orange,
                    height: 30,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        gotohome();
                      },
                      child: Text("Okay"),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              widget.selection.selected = [];
              itemsNames = [];
              itemQuantity = [];
              price = [];
              indvPrice = [];
            });
            gotohome();
          },
        ),
        title: Hero(tag: "Title", child: TitleWidget()),
        actions: [
          UserAppBarTile(
            user: widget.user,
          )
        ],
      ),
      body: Container(
        color: MyColors().alice,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: MyColors().shadowDark,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15,
                          spreadRadius: 1),
                      BoxShadow(
                          color: MyColors().shadowLight,
                          offset: Offset(-4.0, -4.0),
                          blurRadius: 15,
                          spreadRadius: 1)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          MyColors().shadowDark,
                          MyColors().alice,
                        ])),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemsNames.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width * 0.5,
                                    child: Wrap(
                                      runSpacing: 5,
                                      children: [
                                        Text('${itemsNames[i]} x '),
                                        Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              color: Colors.orange,
                                              child: RawMaterialButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      itemQuantity[i]++;
                                                      indvPrice[i] += price[i];
                                                    });
                                                    calTotalPrice();
                                                  },
                                                  child: Icon(Icons.add)),
                                            ),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              color: Colors.black,
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${itemQuantity[i].toString()}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              color: Colors.orange,
                                              child: RawMaterialButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (itemQuantity[i] > 1) {
                                                        itemQuantity[i]--;
                                                        indvPrice[i] -=
                                                            price[i];
                                                        calTotalPrice();
                                                      }
                                                    });
                                                  },
                                                  child: Icon(Icons.remove)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('RS ${indvPrice[i]}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey[800],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey[900],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Amount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('RS $total',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Gateway Charge",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        Text('RS $paymentCharges',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Packaging Charges",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        Text('RS 0.00',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Charges",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        Text('RS 0.00',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Divider(
                      color: Colors.black,
                      height: 5.0,
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Payable Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('RS $completeCharges',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[900],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: FirebaseCallbacks().getOneCafe(widget.cafeCode),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    );
                  }

                  if (snapshot.data['isDelivery'] == false) {
                    collectOptions.remove('Delivery');
                    ndropdownValue = 'Pre-order';
                  }
                  if (snapshot.data['isTakeout'] == false) {
                    collectOptions.remove('Takeout');
                  }
                  if (snapshot.data['isPreOrder'] == false) {
                    collectOptions.remove('Pre-order');
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment options',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            snapshot.data['isDelivery']
                                ? ListTile(
                                    title: const Text('Cash or UPI on Delivery - COD'),
                                    leading: Radio(
                                      value: 0,
                                      groupValue: paymentType,
                                      onChanged: (nvalue) {
                                        setState(() {
                                          paymentButtonText = "Place Order";
                                          paymentType = nvalue;
                                          isButtonEnabled = true;
                                          ndropdownValue = 'Delivery';
                                        });
                                        if (userAddress == 'Not Provided') {
                                          setState(() {
                                            isButtonEnabled = false;
                                          });
                                        } else {
                                          setState(() {
                                            isButtonEnabled = true;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                : Text(
                                    "Sorry, this cafe is not providing COD at the moment."),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 5.0),
                        child: Text(
                          'Select Order Type',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Container(
                          child: DropdownButton<String>(
                            value: ndropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.orange,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                ndropdownValue = newValue;
                              });
                            },
                            items: collectOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ndropdownValue == 'Delivery'?
                      Container(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("We have the following Address", style: Theme.of(context).textTheme.subtitle2,),
                            SizedBox(height: 10.0,),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(userAddress.replaceAll(', ', ',\n'), style: TextStyle(
                                  fontSize: 14.0,
                                ),),
                              ),
                            ),
                          ],
                        ),
                      ):Container()
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
              child: Container(
                width: width - 20,
                color: isButtonEnabled ? Colors.orangeAccent : Colors.grey[200],
                child: RawMaterialButton(
                  onPressed: isButtonEnabled
                      ? paymentType == 0
                          ? () {
                    /// COD
                    generateFinalData();
                    FirebaseAnalytics().logEvent(name: "COD-ORDER").then((value){

                      FirebaseCallbacks().placeOrder(
                          docName,
                          widget.user.displayName,
                          widget.user.email,
                          widget.userPhone,
                          widget.cafeCode,
                          DateTime.now().toIso8601String(),
                          orderItems,
                          "COD",
                          ndropdownValue,
                          widget.cafeName);
                    }).then((value){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      child: Icon(
                                        Icons.done_all,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Thanks! Your order was successfully placed.",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text("In case the order status is not updating, Visit the help page from the side menu.",
                                        style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.bold
                                        ), textAlign: TextAlign.center,),
                                    SizedBox(height: 10),
                                    RawMaterialButton(
                                      onPressed: () {
                                        Timer(Duration(seconds: 2),(){
                                          int count = 0;
                                          Navigator.popUntil(context, (route) {
                                            return count++ == 3;
                                          });
                                        });
                                      },
                                      disabledElevation: 0.0,
                                      splashColor:
                                      Colors.orange[50],
                                      shape: StadiumBorder(),
                                      elevation: 0.0,
                                      fillColor:
                                      Colors.orangeAccent,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            7.0),
                                        child: Text("Okay",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight
                                                    .bold)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    });
                            }
                          : () {
                              generateFinalData();
                              FirebaseAnalytics().logEvent(name: "PaymentRedirect").then((value){
                                createOrder(
                                  completeCharges * 100,
                                  widget.user.displayName,
                                  widget.user.email,
                                  widget.userPhone,
                                ).then((value) {
                                  orderItems = [];
                                });
                              });
                            }
                      : null,
                  disabledElevation: 0.0,
                  splashColor: Colors.orange[50],
                  shape: StadiumBorder(),
                  elevation: 0.0,
                  fillColor:
                      isButtonEnabled ? Colors.orangeAccent : Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(paymentButtonText,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }



  Future<void> createOrder(
    double amount,
    String uName,
    String uEmail,
    String userPhone,
  ) {
      var options = {
        'key': 'rzp_test_qZ6mpIbWNzYTaI',
        'amount': amount,
        'name': uName,
        'description': 'Payment',
        'prefill': {'email': uEmail, "phone": userPhone},
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        print(e);
      }
    }

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      FirebaseCallbacks().placeOrder(
          docName,
          widget.user.displayName,
          widget.user.email,
          widget.userPhone,
          widget.cafeCode,
          DateTime.now().toIso8601String(),
          orderItems,
          response.paymentId,
          ndropdownValue,
          widget.cafeName
      ).then((value){
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.done_all,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.green,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Thanks! Your order was successfully placed.",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      RawMaterialButton(
                        onPressed: () {
                          Timer(Duration(seconds: 2), (){
                            int count = 0;
                            Navigator.popUntil(context, (route) {
                              return count++ == 3;
                            });
                          });
                        },
                        disabledElevation: 0.0,
                        splashColor:
                        Colors.orange[50],
                        shape: StadiumBorder(),
                        elevation: 0.0,
                        fillColor:
                        Colors.orangeAccent,
                        child: Padding(
                          padding:
                          const EdgeInsets.all(
                              7.0),
                          child: Text("Okay",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            });
      });
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                width: 200,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Sorry your payment was not successful.",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      disabledElevation: 0.0,
                      splashColor:
                      Colors.orange[50],
                      shape: StadiumBorder(),
                      elevation: 0.0,
                      fillColor:
                      Colors.orangeAccent,
                      child: Padding(
                        padding:
                        const EdgeInsets.all(
                            7.0),
                        child: Text("Okay",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight
                                    .bold)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          });
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      // handle error and success and do the same as Success and Error
      
    }
}
