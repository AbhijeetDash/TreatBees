import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treatbees/pages/collectOrder.dart';
import 'package:treatbees/pages/helpPage.dart';
import 'package:treatbees/pages/settings.dart';
import 'package:treatbees/utils/customCircleIndicator.dart';
import 'package:treatbees/utils/functions.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:treatbees/utils/widget.dart';

class Home extends StatefulWidget {
  final SharedPreferences sp;
  final User user;
  final String phone;
  final String msgToken;
  Home({@required this.sp, this.user, @required this.phone, this.msgToken});
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
                      icon: Icons.help,
                      title: "Help",
                      subTitle: "Order related helpline",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpInfo()));
                      }),
                  OptionTile(
                      icon: Icons.settings,
                      title: "Setting",
                      subTitle: "Settings and documents",
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => TBSettings(
                                  sp: widget.sp,
                                  user: widget.user,
                                  number: widget.phone,
                                  msg: widget.msgToken,
                                )));
                      }),
                ],
              ),
              Container(
                child: Column(
                  children: [
                    Text("Version 1.0 MVP"),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
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
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                bottom : -50.0,
                right: -50,
                child: Container(
                  width: size.width,
                    height: size.height*0.6,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/sushi.png'))),
                  child: Container(
                    width: size.width,
                    height: size.height*0.6,
                    color: MyColors().alice.withOpacity(0.7),
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: size.height,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 2,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Carousels')
                            .snapshots(),
                        builder: (context, stream) {
                          List cards = [];
                          if (stream.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (stream.hasError) {
                            return Center(child: Text(stream.error.toString()));
                          }

                          QuerySnapshot snap = stream.data;
                          snap.docs.forEach((doc) => {
                                cards.add(CarousTile(
                                  size: size,
                                  url: doc['URL'],
                                  title: doc['Title'],
                                  subTitle: doc['SubTitle'],
                                ))
                              });

                          return CarouselSlider(
                            height: 250.0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            aspectRatio: 2.0,
                            items: cards.map((card) {
                              return Builder(builder: (BuildContext context) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
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
                                  if (snap.data.length > 0) {
                                    orderTile.add(Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            'Active Order',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          subtitle: Text(
                                            "Check Order Status",
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
                                    ));
                                  }
                                }
                                return Column(
                                  children: orderTile,
                                );
                              }),
                          FutureBuilder(
                            future: FirebaseCallbacks().getCafe(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Container(
                                  height: 600,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Cafetile(
                                          cafeCode: snapshot.data[index]['INFO']
                                              ['#CafeCode'],
                                          icon: Icons.food_bank_outlined,
                                          title:
                                              "${snapshot.data[index]['INFO']['RestaurantName']}",
                                          subtitle:
                                              "${snapshot.data[index]['INFO']['ServiceType']}",
                                          user: widget.user,
                                          userPhone: widget.phone,
                                          msgToken: widget.msgToken,
                                          isOpen: snapshot.data[index]['INFO']['isOpen']
                                        );
                                      }),
                                );
                              }
                              return Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          )
                          //Use this widget
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh, color: Colors.black),
        onPressed: (){
          setState(() {

          });
        },
      )
    );
  }
}
