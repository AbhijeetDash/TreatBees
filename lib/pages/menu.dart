import 'package:TreatBees/pages/orderDetails.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final String cafeName;

  Menu({@required this.cafeName});

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
        titleSpacing: 20.0,
        title: Hero(tag: "Title", child: TitleWidget()),
        actions: [UserAppBarTile()],
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Ord(selection: selections)));
        },
        shape: StadiumBorder(),
        fillColor: Colors.orange,
        child: Text("Order now"),
      ),
    );
  }
}
