import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/utils/payment.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ord extends StatefulWidget {
  final User user;
  final String cafeCode;
  final String userPhone;
  final Selection selection;
  const Ord(
      {Key key,
      this.user,
      this.cafeCode,
      @required this.userPhone,
      @required this.selection})
      : super(key: key);
  @override
  _OrdState createState() => _OrdState();
}

class _OrdState extends State<Ord> {
  //Widget delivery;
  Color delCol;
  int total = 0;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time, _session;
  TextEditingController _timeController = TextEditingController();
  bool isButtonEnabled;
  String docName;

  List<Map<String, String>> orderItems = [];
  List<String> itemsNames = [];
  List<int> itemQuantity = [];
  List<int> price = [];
  List<int> indvPrice = [];

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

  void seperate() {
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
  }

  @override
  void initState() {
    seperate();
    calTotalPrice();
    isButtonEnabled = false;
    delCol = MyColors().alice;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    super.initState();
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: DateTime.now().minute > 30
              ? DateTime.now().hour + 1
              : DateTime.now().hour,
          minute: DateTime.now().minute > 30
              ? DateTime.now().minute + 30 - 60
              : DateTime.now().minute + 30),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
      double newSelectedTime = selectedTime.hour + selectedTime.minute / 60.0;
      double nowTime = TimeOfDay.now().hour + TimeOfDay.now().minute / 60.0;
      if (newSelectedTime > nowTime) {
        setState(() {
          isButtonEnabled = true;
          _minute = selectedTime.minute.toString();
          _session = selectedTime.period.toString().split('.')[1];
          _hour = _session == 'pm'
              ? (12 - selectedTime.hour)
              : selectedTime.hour.toString();
          if (_hour == '0') {
            _hour = '12';
          }
          if (_minute == '0') {
            _minute = '00';
          }
          _time = _hour + ' : ' + _minute + ' ' + _session;
          _timeController.text = _time;
        });
      } else {
        invalidTimeDialog(context);
      }
    }
  }

  void gotohome() {
    Navigator.of(context).push(PageRouteBuilder(
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
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                  child: FlatButton(
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
        ));
  }

  void invalidTimeDialog(BuildContext context) {
    showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                  "Invalid Time",
                  style: MyFonts().smallHeadingBold,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Please enter a valid time\nwe can't do time travel.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.orange,
                  height: 30,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
        ));
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${itemsNames[i]} x '),
                                    SizedBox(
                                      width: 5,
                                    ),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                                    indvPrice[i] -= price[i];
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
                                height: 30,
                              ),
                              Text('${indvPrice[i]}')
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30.0, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('RS $total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 20),
              child: Container(
                width: width - 20,
                color: Colors.orangeAccent,
                child: RawMaterialButton(
                  onPressed: () {
                    _selectTime(context).then((value) => {});
                  },
                  splashColor: Colors.orange[50],
                  shape: StadiumBorder(),
                  elevation: 0.0,
                  fillColor: Colors.orangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                        _time == null ? "Choose Pick-up/Delivery Time" : _time,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Don't Delete this code..
            // Padding(
            //   padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            //   child: Container(
            //     width: width - 20,
            //     color: delCol,
            //     child: RawMaterialButton(
            //       onPressed: () {
            //         setState(() {
            //           delCol == Colors.greenAccent
            //               ? delCol = MyColors().alice
            //               : delCol = Colors.greenAccent;
            //           if (delCol == Colors.greenAccent) {
            //             delivery = Padding(
            //               padding: const EdgeInsets.all(18.0),
            //               child: Container(
            //                 width: width,
            //                 child: Column(
            //                   children: [
            //                     Text(
            //                       "Enter Delivery Details",
            //                       style: TextStyle(
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.bold),
            //                     ),
            //                     SizedBox(height: 10),
            //                     TextField(
            //                       maxLines: 10,
            //                       minLines: 10,
            //                       decoration: InputDecoration(
            //                           border: OutlineInputBorder(),
            //                           hintText:
            //                               "Enter Any Relevant details for Deliver"),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             );
            //           } else {
            //             delivery = Container();
            //           }
            //         });
            //       },
            //       splashColor: delCol,
            //       shape: StadiumBorder(),
            //       elevation: 0.0,
            //       fillColor: delCol,
            //       child: Padding(
            //         padding: const EdgeInsets.all(14.0),
            //         child: Text("It is a Delivery",
            //             style: TextStyle(
            //                 fontSize: 18, fontWeight: FontWeight.bold)),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            //Dont delete this code.. it is for delivery ui,
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
              child: Container(
                width: width - 20,
                color: isButtonEnabled ? Colors.orangeAccent : Colors.grey[200],
                child: RawMaterialButton(
                  onPressed: isButtonEnabled
                      ? () {
                          generateFinalData();
                          FirebaseAnalytics()
                              .logEvent(name: "PaymentRedirect")
                              .then((value) => {
                                    Payments(
                                      docName,
                                      widget.user.displayName,
                                      widget.user.email,
                                      widget.cafeCode,
                                      _time,
                                      widget.userPhone,
                                      orderItems,
                                    )
                                        .createOrder(
                                          total * 100,
                                          widget.user.displayName,
                                          widget.user.email,
                                          widget.userPhone,
                                        )
                                        .then((value) => {})
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
                    child: Text("Continue to Pay",
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
}
