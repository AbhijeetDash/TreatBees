import 'package:TreatBees/pages/orderDetails.dart';
import 'package:TreatBees/utils/colors.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  String cafeName;

  Menu({this.cafeName});

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
        titleSpacing: 20.0,
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

class MenuSectionHeading extends StatelessWidget {
  const MenuSectionHeading({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, bottom: 10, top: 20),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none),
      ),
    );
  }
}
