import 'package:treatbees/pages/menu.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarousTile extends StatelessWidget {
  const CarousTile(
      {Key key,
      @required this.size,
      @required this.url,
      @required this.title,
      @required this.subTitle})
      : super(key: key);

  final Size size;
  final String url;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Stack(
        children: [
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            height: 200,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(url), fit: BoxFit.fill),
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
            ),
          ),
          Container(
            width: size.width,
            height: 200,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(title,
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold)),
                  //     Text(subTitle,
                  //         style: TextStyle(
                  //             fontSize: 12,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold)),
                  //   ],
                  // ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       Colors.grey[850].withOpacity(0.6),
              //       Colors.black.withOpacity(0.4)
              //     ]),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}

class Cafetile extends StatefulWidget {
  const Cafetile({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subtitle,
    @required this.user,
    @required this.userPhone,
    @required this.cafeCode,
    @required this.msgToken,
    @required this.isOpen
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final User user;
  final String cafeCode;
  final String userPhone;
  final String msgToken;
  final bool isOpen;

  @override
  _CafetileState createState() => _CafetileState();
}

class _CafetileState extends State<Cafetile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      onTap: widget.isOpen? () {
        FirebaseAnalytics().logEvent(
            name: "CafeSelect", parameters: {"CafeName": widget.title});
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (a, b, c) {
            return Menu(
              cafeName: widget.title,
              user: widget.user,
              userPhone: widget.userPhone,
              cafeCode: widget.cafeCode,
              msgToken: widget.msgToken,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(curve: Curves.ease, parent: animation);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));
      }: (){},
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[300],
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
        child: Icon(widget.icon, color: widget.isOpen?Colors.black: Colors.grey,),
      ),
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 18,
            color: widget.isOpen?Colors.black: Colors.grey,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none),
      ),
      subtitle: widget.isOpen?Text(widget.subtitle):Text("Closed Right Now", style: TextStyle(color: widget.isOpen?Colors.black: Colors.grey,),),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(20.0),
    //   child: Container(
    //     width: size.width,
    //       height:  size.width,
    //       decoration: BoxDecoration(
    //         color: Colors.grey[300],
    //         borderRadius: BorderRadius.circular(10),
    //         boxShadow: [
    //           BoxShadow(
    //               color: MyColors().shadowDark,
    //               offset: Offset(4.0, 4.0),
    //               blurRadius: 15,
    //               spreadRadius: 1),
    //           BoxShadow(
    //               color: MyColors().shadowLight,
    //               offset: Offset(-4.0, -4.0),
    //               blurRadius: 15,
    //               spreadRadius: 1)
    //         ],
    //         gradient: LinearGradient(
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             colors: [
    //               MyColors().shadowDark,
    //               MyColors().alice,
    //             ])),
    //     child: Column(
    //       children: [
    //
    //       ],
    //     ),
    //   ),
    // );
  }
}

class Menutile extends StatefulWidget {
  Menutile({
    Key key,
    @required this.title,
    @required this.price,
    @required this.avai,
    @required this.selection,
  }) : super(key: key);

  String title;
  String price;
  String avai;
  Selection selection;

  @override
  _MenutileState createState() => _MenutileState();
}

class _MenutileState extends State<Menutile> {
  List<Color> unselectedColor, selectedColor, unavailableColor;
  bool selected = false;
  Widget trail;
  int no;

  void checkIfExists(){
    widget.selection.selected.forEach((element) {
      if(element['DishName'] == widget.title){
        setState(() {
          selected = true;
        });
      }
    });
  }

  @override
  void initState() {
    /// Setting basic prop..
    unselectedColor = [MyColors().shadowDark, MyColors().alice];
    unavailableColor = [Colors.grey, Colors.grey];
    selectedColor =  [Colors.lightGreen[200],Colors.lightGreen[400]];

    /// checking if already exists in list
    checkIfExists();

    super.initState();
  }

  void tapLogic() {
    if (widget.avai == "available") {
      if(selected){
        setState(() {
          widget.selection.selected.removeWhere((item) => item['DishName'] == widget.title);
          selected = false;
        });
      } else {
        setState(() {
          widget.selection.selected.add({
            "DishName": widget.title,
            "Price": widget.price,
            "Quantity": "1",
          });
          selected = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: RawMaterialButton(
        onPressed: tapLogic,
        splashColor: MyColors().alice,
        child: Container(
          height: 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
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
                              colors: selected?selectedColor:unselectedColor)),
                      child: Icon(
                        Icons.fastfood,
                        color: widget.avai == "available"
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.avai == "available"
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(widget.price,
                              style: TextStyle(
                                color: widget.avai == "available"
                                    ? Colors.black
                                    : Colors.grey,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(' ' + widget.avai.toUpperCase() + ' ',
                              style: TextStyle(
                                  wordSpacing: 5,
                                  backgroundColor: widget.avai == "available"
                                      ? Colors.green
                                      : Colors.red,
                                  color: Colors.white,
                                  fontSize: 11))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  OptionTile(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.subTitle,
      @required this.onPressed})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {


    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[300],
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
        child: Icon(icon),
      ),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subTitle,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Treat', style: MyFonts().smallHeadingBold),
        TextSpan(text: 'Bees', style: MyFonts().smallHeadingLight)
      ]),
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

class UserAppBarTile extends StatelessWidget {
  final User user;

  /// This widget will take UserName and ProfilePic
  /// link as argumants..
  /// It must be created once and used by Its Object
  /// passed to each node.
  const UserAppBarTile({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Welcome ',
                style: TextStyle(fontSize: 14, color: Colors.black)),
            TextSpan(
                text: '${user.displayName.split(' ')[0]} ',
                style: MyFonts().smallHeadingLight)
          ]),
        ),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user.photoURL),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.0),
      radius: 30,
      child: Container(
        child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Colors.black.withOpacity(0.0),
            onPressed: () {},
            child: Icon(Icons.group)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors().shadowDark,
                MyColors().alice,
              ]),
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
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
