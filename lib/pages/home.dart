import 'package:TreatBees/pages/collectOrder.dart';
import 'package:TreatBees/utils/customCircleIndicator.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final SharedPreferences sp;
  final User user;
  final String phone;
  Home({@required this.sp, this.user, @required this.phone});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // get carousels.. and create the cards array
    if (widget.sp != null) widget.sp.setBool('available', true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: MyColors().alice,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 200,
                    width: size.width * 0.9,
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        title: Text(
                          widget.user.displayName,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Text(
                          widget.user.email,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.user.photoURL),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                            Colors.grey[850].withOpacity(0.6),
                            Colors.black.withOpacity(0.8)
                          ])),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1484300681262-5cca666b0954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'))),
                  ),
                  SizedBox(height: 20),
                  OptionTile(
                    onPressed: () {
                      // Go to Order History Based on Dates..
                    },
                    icon: Icons.history,
                    title: "Orders",
                    subTitle: "View recent orders",
                  ),
                  OptionTile(
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (a, b, c) {
                          return CollectOrder(
                            user: widget.user,
                          );
                        },
                        transitionDuration: Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          animation = CurvedAnimation(
                              curve: Curves.ease, parent: animation);
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ));
                    },
                    icon: Icons.confirmation_num_rounded,
                    title: "Collect Order",
                    subTitle: "Collect your Active Order",
                  ),
                  OptionTile(
                    onPressed: () {},
                    icon: Icons.group,
                    title: "Gangs",
                    subTitle: "Order with your Gang",
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("version 1.0 MVP"),
              )
            ],
          ),
        ),
      ),
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
        alignment: Alignment.center,
        color: MyColors().alice,
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 2,
              child: FutureBuilder(
                future: FirebaseCallbacks().getCarousels(),
                builder: (context, snap) {
                  List cards = [];
                  if (snap.data != null) {
                    snap.data.forEach((doc) => {
                          cards.add(CarousTile(
                            size: size,
                            url: doc['data']['URL'],
                            title: doc['data']['Title'],
                            subTitle: doc['data']['SubTitle'],
                          ))
                        });
                  }
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Container(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return CarouselSlider(
                    height: 250.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: Duration(seconds: 5),
                    aspectRatio: 2.0,
                    items: cards.map((card) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            width: MediaQuery.of(context).size.width,
                            child: card);
                      });
                    }).toList(),
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              // this list view would be dynamic
              child: ListView(
                children: [
                  FutureBuilder(
                      future: FirebaseCallbacks()
                          .getTodaysOrders(widget.user.email),
                      builder: (context, snap) {
                        List<Widget> orderTile = [];
                        if (snap.data != null) {
                          snap.data.forEach((doc) => {
                                orderTile.add(Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    alignment: Alignment.center,
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
                                    child: ListTile(
                                      leading: CircularPercentIndicator(
                                        center: Icon(Icons.fastfood),
                                        radius: 50,
                                        lineWidth: 5.0,
                                        percent: 0.25,
                                        progressColor: Colors.orange,
                                      ),
                                      title: Text(
                                        '${doc['data']['orderStatus'].toString().toUpperCase()}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      subtitle: Text(
                                        "The status is '${doc['data']['orderStatus']}'",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      trailing: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(PageRouteBuilder(
                                            pageBuilder: (a, b, c) {
                                              return CollectOrder(
                                                user: widget.user,
                                              );
                                            },
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              animation = CurvedAnimation(
                                                  curve: Curves.ease,
                                                  parent: animation);
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ));
                                        },
                                        shape: StadiumBorder(),
                                        fillColor: Colors.orange,
                                        child: Text("View"),
                                      ),
                                    ),
                                  ),
                                ))
                              });
                        }
                        return Column(
                          children: orderTile,
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    child: Text(
                      "Cafeterias",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Cafetile(
                    icon: Icons.local_cafe_outlined,
                    title: "Cafe Coffee Day",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.fastfood,
                    title: "KFC",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.food_bank_outlined,
                    title: "Canteen",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.local_cafe_outlined,
                    title: "Cafe Coffee Day",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.fastfood,
                    title: "KFC",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.food_bank_outlined,
                    title: "Canteen",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.local_cafe_outlined,
                    title: "Cafe Coffee Day",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.fastfood,
                    title: "KFC",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                  Cafetile(
                    icon: Icons.food_bank_outlined,
                    title: "Canteen",
                    subtitle: "Visit for offers",
                    user: widget.user,
                    userPhone: widget.phone,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //floatingActionButton: CustomFloatingActionButton()
    );
  }
}
