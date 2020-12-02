import 'package:TreatBees/utils/customCircleIndicator.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollectOrder extends StatefulWidget {
  final User user;

  const CollectOrder({Key key, @required this.user}) : super(key: key);

  @override
  _CollectOrderState createState() => _CollectOrderState();
}

class _CollectOrderState extends State<CollectOrder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors().alice,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: TitleWidget(),
          actions: [
            UserAppBarTile(
              user: widget.user,
            )
          ],
        ),
        body: Container(
          color: MyColors().alice,
          child: FutureBuilder(
              future: FirebaseCallbacks().getTodaysOrders(widget.user.email),
              builder: (context, snap) {
                List<Widget> orderTile = [];
                List<Widget> orderTileData = [];
                if (snap.data != null) {
                  snap.data.forEach((doc) {
                    print(doc);
                    doc['data']['orderItems'].forEach((item) {
                      print(item);
                      orderTileData.add(Padding(
                        padding:
                            EdgeInsets.only(top: 15.0, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${item['ItemName']} X ${item['ItemQuantity']}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('${item['TotalPrice']}')
                          ],
                        ),
                      ));
                    });
                    orderTile.add(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: orderTileData,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RawMaterialButton(
                              onPressed: () {},
                              shape: StadiumBorder(),
                              fillColor: Colors.orange,
                              child: Text("Collect"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ));
                    orderTileData = [];
                  });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Recent Order",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: orderTile,
                    ),
                  ],
                );
              }),
        ));
  }
}
