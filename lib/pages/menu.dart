import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/orderDetails.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final String cafeName;
  final String cafeCode;
  final User user;
  final String userPhone;
  //Message Token of Cafe
  final String msgToken;
  Menu(
      {@required this.cafeName,
      this.user,
      @required this.userPhone,
      @required this.cafeCode,
      @required this.msgToken});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            selections.selectedName = [];
            selections.selectedPrice = [];
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (a, b, c) {
                return Home(
                  sp: null,
                  user: widget.user,
                  phone: widget.userPhone,
                  // msgToken: widget.msgToken,
                );
              },
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                animation =
                    CurvedAnimation(curve: Curves.ease, parent: animation);
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
          },
        ),
        title: TitleWidget(),
        actions: [
          UserAppBarTile(
            user: widget.user,
          )
        ],
      ),
      body: Container(
        color: MyColors().alice,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
              ),
              child: Text(
                widget.cafeName,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: size.height * 0.8,
              child: FutureBuilder(
                future: FirebaseCallbacks().getMenu(widget.cafeCode),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<String> mainMenu = [];
                  List<Map<dynamic, dynamic>> menuItems = [];
                  snap.data[0]['Categories']['categories'].forEach((cat) {
                    mainMenu.add(cat);
                  });
                  snap.data[1]['Items']['items'].forEach((item) {
                    menuItems.add(item);
                  });
                  return ListView.builder(
                    itemCount: mainMenu.length,
                    itemBuilder: (context, index) {
                      List<Widget> cateItems = [];
                      menuItems.forEach((element) {
                        if (element['Category'] == mainMenu[index]) {
                          cateItems.add(Menutile(
                              icon: Icons.emoji_food_beverage,
                              title: element['DishName'],
                              price: element['Price'],
                              avai: element['Availability']));
                        }
                      });
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MenuSectionHeading(title: mainMenu[index]),
                            Column(
                              children: cateItems,
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // MenuSectionHeading(title: "Refreshing Tea"),
            // Menutile(
            //   icon: Icons.emoji_food_beverage,
            //   title: "Asam Tea",
            //   price: "120",
            // ),
          ],
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          Navigator.of(context)
              .push(PageRouteBuilder(
                pageBuilder: (a, b, c) {
                  return Ord(
                    selection: selections,
                    user: widget.user,
                    cafeCode: widget.cafeCode,
                    userPhone: widget.userPhone,
                    msgToken: widget.msgToken,
                  );
                },
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  animation =
                      CurvedAnimation(curve: Curves.ease, parent: animation);
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ))
              .then((value) => {
                    FirebaseAnalytics().logEvent(
                        name: "AddedToCart",
                        parameters: {"Status": "Added Items To cart"})
                  });
        },
        shape: StadiumBorder(),
        fillColor: Colors.orange,
        child: Text("Order now"),
      ),
    );
  }
}
