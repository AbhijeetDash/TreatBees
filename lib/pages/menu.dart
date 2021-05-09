import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:treatbees/pages/home.dart';
import 'package:treatbees/pages/orderDetails.dart';
import 'package:treatbees/pages/userDetails.dart';
import 'package:treatbees/utils/functions.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:treatbees/utils/widget.dart';

class Selection {
  List<Map<String, String>> selected = [];
}

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

  Selection selection = new Selection();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool show = false;
  FirebaseFirestore cloudInstance;
  String selectedCategory = "All categories";

  @override
  void initState() {
    cloudInstance = FirebaseFirestore.instance;
    super.initState();
  }

  void doneDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Alert",
                    style: MyFonts().smallHeadingBold,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please select at least\none item to continue",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.orange,
                    height: 30,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Okay",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

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
              Navigator.of(context).pop(PageRouteBuilder(
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
            ),
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
                  left: 15,
                ),
                child: Text(
                  widget.cafeName,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                height: size.height - 220,
                child: StreamBuilder(
                  stream: cloudInstance
                      .collection(widget.cafeCode)
                      .doc('MENU')
                      .collection('Categories')
                      .snapshots(),

                  builder: (context, categories) {
                    QuerySnapshot snapCateDocs;
                    List<String> categoryName = [];
                    List<int> itemHeight = [];
                    List<bool> selections = [];
                    snapCateDocs = categories.data;

                    if(snapCateDocs != null) {
                      if(selectedCategory == 'All categories'){
                        snapCateDocs.docs.forEach((element) {
                          categoryName.add(element.id);
                          itemHeight.add(element.data()['itemCount']);
                        });
                      } else {
                        snapCateDocs.docs.forEach((element) {
                          if(element.id == selectedCategory){
                            categoryName.add(element.id);
                            itemHeight.add(element.data()['itemCount']);
                          }
                        });
                      }
                    } else {
                      return Container(
                        width: size.width,
                        height: size.height,
                        color: MyColors().alice,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }


                    /// List of category
                    return ListView.builder(
                        itemCount: categoryName.length,
                        itemBuilder: (context, cateIndex) {

                          return Container(
                            width: size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    categoryName[cateIndex],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),

                                StreamBuilder(
                                    stream: cloudInstance
                                        .collection(widget.cafeCode)
                                        .doc('MENU')
                                        .collection('Items')
                                        .snapshots(),
                                    builder: (context, items) {

                                      QuerySnapshot snapItemData = items.data;
                                      List<Map<String, dynamic>> menuItems = [];

                                      if(snapItemData != null){
                                        if(selectedCategory == 'All categories'){
                                          snapItemData.docs.forEach((element) {
                                            if (categoryName[cateIndex] == element.data()['Category']) {
                                              menuItems.add({
                                                "DishName":element.id,
                                                "Price": element.data()['Price'],
                                                "Available": element.data()['Availability']
                                              });
                                            }
                                          });
                                        } else {
                                          snapItemData.docs.forEach((element) {
                                            if(categoryName[cateIndex] == selectedCategory){
                                              if (categoryName[cateIndex] == element.data()['Category']) {
                                                menuItems.add({
                                                  "DishName":element.id,
                                                  "Price": element.data()['Price'],
                                                  "Available": element.data()['Availability']
                                                });
                                              }
                                            }
                                          });
                                        }

                                      }

                                      double dynaHeight = itemHeight[cateIndex] * 86.0 + 10;

                                      List<Widget> cateColumn = [];


                                      menuItems.forEach((element) {
                                          cateColumn.add(
                                              Menutile(
                                                key: GlobalKey(),
                                                title: element['DishName'],
                                                price: element['Price'].toString(),
                                                avai:  element['Available'],
                                                selection: widget.selection,
                                              )
                                          );
                                      });


                                      /// Main List of Items
                                      return Container(
                                        height: dynaHeight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: cateColumn,
                                          ),
                                        ),
                                      );
                                    }),

                              ],
                            ),
                          );
                        });
                  },
                ),
              ),

            ],
          ),
        ),
        floatingActionButton: Container(
          width: size.width,
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              StreamBuilder(
                stream: cloudInstance
              .collection(widget.cafeCode)
              .doc('MENU')
              .collection('Categories')
              .snapshots(),
                builder: (context, categories) {

                  QuerySnapshot snapCateDocs = categories.data;
                  List<String> categoryName = [];
                  if(snapCateDocs != null){
                    snapCateDocs.docs.forEach((element) {
                      categoryName.add(element.id);
                    });
                    categoryName.add('All categories');

                    return Container(
                      height: 50.0,
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25.0)
                      ),
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        value: selectedCategory,
                        underline: Container(),
                        items: categoryName
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.black),),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
              ),

              RawMaterialButton(
                onPressed: () {
                  if (widget.selection.selected.length > 0) {
                    FirebaseCallbacks()
                        .getCurrentUser(widget.user.email)
                        .then((value) {
                      if (value['address'] == 'Not Provided') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetails(
                                  fromOrderPage: true,
                                  user: widget.user,
                                  selection: widget.selection,
                                  cafeName: widget.cafeName,
                                  cafeCode: widget.cafeCode,
                                )));
                      } else {
                        Navigator.of(context)
                            .push(PageRouteBuilder(
                              pageBuilder: (a, b, c) {
                                return Ord(
                                  user: widget.user,
                                  cafeCode: widget.cafeCode,
                                  userPhone: widget.userPhone,
                                  selection: widget.selection,
                                  cafeName: widget.cafeName,
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
                            ))
                            .then((value) => {
                                  FirebaseAnalytics().logEvent(
                                      name: "AddedToCart",
                                      parameters: {"Status": "Added Items To cart"})
                                });
                      }
                    });
                  } else {
                    doneDialog(context);
                  }
                },
                shape: StadiumBorder(),
                fillColor: Colors.orange,
                child: Text("Order now"),
              ),
            ],
          ),
        ));
  }
}
