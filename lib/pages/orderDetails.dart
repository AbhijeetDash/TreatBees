import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/payment.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/selections.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ord extends StatefulWidget {
  final Selections selection;
  final User user;
  final String cafeCode;
  final String userPhone;
  final String msgToken;
  const Ord(
      {Key key,
      @required this.selection,
      this.user,
      this.cafeCode,
      @required this.userPhone,
      @required this.msgToken})
      : super(key: key);
  @override
  _OrdState createState() => _OrdState(selection);
}

class _OrdState extends State<Ord> {
  final Selections selection;
  int total = 0;
  //Widget delivery;
  Color delCol;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time, _session;
  TextEditingController _timeController = TextEditingController();
  bool isButtonEnabled;
  String docName;

  _OrdState(this.selection);

  @override
  void initState() {
    calTotal();
    // delivery = Container(
    //   width: 10,
    //   height: 10,
    // );
    isButtonEnabled = false;
    delCol = MyColors().alice;

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    docName = formattedDate.replaceAll("-", " : ");
    super.initState();
  }

  void calTotal() {
    selection.selectedPrice.forEach((element) {
      total += element;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _session = selectedTime.period.toString().split('.')[1];
        if (_hour == '0') {
          _hour = '12';
        }
        if (_minute == '0') {
          _minute = '00';
        }
        _time = _hour + ' : ' + _minute + ' ' + _session;
        _timeController.text = _time;
      });
  }

  void gotohome() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (a, b, c) {
        return Home(
          sp: null,
          user: widget.user,
          phone: widget.userPhone,
          msgToken: widget.msgToken,
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
            selection.selectedName = [];
            selection.selectedPrice = [];
            selection.finalData = [];
            selection.initialPrice = [];
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
                      itemCount: selection.selectedName.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 18.0,
                            right: 18.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${selection.selectedName[i]} x ${selection.numVal[i]}'),
                              SizedBox(
                                height: 30,
                              ),
                              Text('RS ${selection.selectedPrice[i]}')
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
                    _selectTime(context).then((value) => {
                          setState(() {
                            isButtonEnabled = true;
                          })
                        });
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
                          FirebaseAnalytics()
                              .logEvent(name: "PaymentRedirect")
                              .then((value) => {
                                    Payments(
                                      docName,
                                      widget.user.displayName,
                                      widget.user.email,
                                      widget.cafeCode,
                                      _time,
                                      selections.generateFinalData(),
                                      widget.userPhone,
                                    ).createOrder(
                                        total * 100,
                                        widget.user.displayName,
                                        widget.user.email,
                                        widget.userPhone)
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
