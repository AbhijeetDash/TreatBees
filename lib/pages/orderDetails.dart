import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/colors.dart';
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

  _OrdState(this.selection);

  @override
  void initState() {
    calTotal();
    super.initState();
  }

  void calTotal() {
    selection.selectedPrice.forEach((element) {
      total += element;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Hero(
          tag: "Title",
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: 'Treat', style: MyFonts().smallHeadingBold),
              TextSpan(text: 'Bees', style: MyFonts().smallHeadingLight)
            ]),
          ),
        ),
        actions: [
          Hero(
            tag: "UserFace",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Welcome ',
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    TextSpan(
                        text: 'Julia  ', style: MyFonts().smallHeadingLight)
                  ]),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1573275048283-c4945bdedbe7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'),
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
      body: Container(
        color: MyColors().alice,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 12),
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
                ))
          ],
        ),
      ),
    );
  }
}
