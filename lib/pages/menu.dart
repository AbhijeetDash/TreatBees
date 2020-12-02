import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/pages/orderDetails.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final String cafeName;
  final User user;
  final String userPhone;

  Menu({@required this.cafeName, this.user, @required this.userPhone});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
            selections.selectedName = [];
            selections.selectedPrice = [];
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (a, b, c) {
                return Home(
                  sp: null,
                  user: widget.user,
                  phone: widget.userPhone,
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
        child: ListView(
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
            MenuSectionHeading(title: "Refreshing Tea"),
            Menutile(
              icon: Icons.emoji_food_beverage,
              title: "Asam Tea",
              price: "120",
            ),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Masala Chai",
                price: "120"),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Darjeeling Tea",
                price: "126"),
            MenuSectionHeading(
              title: "Cold Coffee Delights",
            ),
            Menutile(
              icon: Icons.emoji_food_beverage,
              title: "Devils own vanila cream",
              price: "266",
            ),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Devil’s Own Cocoa Cream",
                price: "212"),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Dark Frappe",
                price: "226"),
            MenuSectionHeading(title: "Refreshing Tea"),
            Menutile(
              icon: Icons.emoji_food_beverage,
              title: "Asam Tea",
              price: "120",
            ),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Masala Chai",
                price: "120"),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Darjeeling Tea",
                price: "126"),
            MenuSectionHeading(
              title: "Cold Coffee Delights",
            ),
            Menutile(
              icon: Icons.emoji_food_beverage,
              title: "Devils own vanila cream",
              price: "266",
            ),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Devil’s Own Cocoa Cream",
                price: "212"),
            Menutile(
                icon: Icons.emoji_food_beverage,
                title: "Dark Frappe",
                price: "226"),
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
                      cafeName: widget.cafeName,
                      userPhone: widget.userPhone);
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
