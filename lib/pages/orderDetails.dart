import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/selections.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:flutter/material.dart';

class Ord extends StatefulWidget {
  final Selections selection;

  const Ord({Key key, @required this.selection}) : super(key: key);
  @override
  _OrdState createState() => _OrdState(selection);
}

class _OrdState extends State<Ord> {
  final Selections selection;
  int total = 0;
  Widget delivery;
  Color delCol;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour;
  String _minute;
  String _time;
  TextEditingController _timeController = TextEditingController();

  _OrdState(this.selection);

  @override
  void initState() {
    calTotal();
    delivery = Container(
      width: 10,
      height: 10,
    );
    delCol = MyColors().alice;
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
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
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
            selection.selectedName = [];
            selection.selectedPrice = [];
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        title: Hero(tag: "Title", child: TitleWidget()),
        actions: [UserAppBarTile()],
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
                                  '${selection.selectedName[i]} X ${selection.numVal[i]}'),
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
                    _selectTime(context);
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
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Container(
                width: width - 20,
                color: delCol,
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      delCol == Colors.greenAccent
                          ? delCol = MyColors().alice
                          : delCol = Colors.greenAccent;
                      if (delCol == Colors.greenAccent) {
                        delivery = Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            width: width,
                            child: Column(
                              children: [
                                Text(
                                  "Enter Delivery Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  maxLines: 10,
                                  minLines: 10,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          "Enter Any Relevant details for Deliver"),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        delivery = Container();
                      }
                    });
                  },
                  splashColor: delCol,
                  shape: StadiumBorder(),
                  elevation: 0.0,
                  fillColor: delCol,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("It is a Delivery",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            delivery,
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
              child: Container(
                width: width - 20,
                color: Colors.orangeAccent,
                child: RawMaterialButton(
                  onPressed: () {},
                  splashColor: Colors.orange[50],
                  shape: StadiumBorder(),
                  elevation: 0.0,
                  fillColor: Colors.orangeAccent,
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
