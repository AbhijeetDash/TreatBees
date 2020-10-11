import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/utils/colors.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List cards = [
      TopButton(
        size: size,
        url:
            'https://images.unsplash.com/photo-1496412705862-e0088f16f791?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
        icon: Icons.emoji_food_beverage_rounded,
        title: "Pre Order Now!",
        subTitle: "Order now and eat later",
      ),
      TopButton(
        size: size,
        url:
            'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
        icon: Icons.house_outlined,
        title: "Hello",
        subTitle: "Welcome to TreatBees",
      )
    ];

    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: MyColors().alice,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text("Menu"),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1484300681262-5cca666b0954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'))),
                ),
                SizedBox(height: 20),
                Menutile(
                    icon: Icons.history,
                    title: "My Order",
                    price: "View recent orders"),
                Menutile(
                    icon: Icons.info_outlined,
                    title: "Version 1 MVP",
                    price: "Information about us")
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyColors().alice,
          elevation: 0.0,
          titleSpacing: 0.0,
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
          alignment: Alignment.center,
          color: MyColors().alice,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 2,
                child: CarouselSlider(
                  height: 250.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: Duration(seconds: 5),
                  aspectRatio: 2.0,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: cards.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: card);
                    });
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                      child: Text(
                        "Cafeterias",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Cafetile(
                      icon: Icons.local_cafe_outlined,
                      title: "Cafe Coffee Day",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.fastfood,
                      title: "KFC",
                      subtitle: "Visit for offers",
                    ),
                    Cafetile(
                      icon: Icons.food_bank_outlined,
                      title: "Canteen",
                      subtitle: "Visit for offers",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
