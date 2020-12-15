import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/selections.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Selections selections = new Selections();

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
      padding: EdgeInsets.all(15),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(subTitle,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[850].withOpacity(0.6),
                    Colors.black.withOpacity(0.8)
                  ]),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}

class Cafetile extends StatelessWidget {
  const Cafetile(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.subtitle,
      @required this.user,
      @required this.userPhone,
      @required this.cafeCode})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final User user;
  final String cafeCode;
  final String userPhone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        FirebaseAnalytics()
            .logEvent(name: "CafeSelect", parameters: {"CafeName": title});
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (a, b, c) {
            return Menu(
              cafeName: title,
              user: user,
              userPhone: userPhone,
              cafeCode: cafeCode,
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
      },
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
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none),
      ),
      subtitle: Text(subtitle),
    );
  }
}

class Menutile extends StatefulWidget {
  const Menutile(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.price})
      : super(key: key);

  final IconData icon;
  final String title;
  final String price;

  @override
  _MenutileState createState() => _MenutileState();
}

class _MenutileState extends State<Menutile> {
  List<Color> grad;
  bool enab;
  Widget trail;
  int no;

  @override
  void initState() {
    enab = false;
    grad = [
      MyColors().shadowDark,
      MyColors().alice,
    ];
    no = 0;
    trail = Container(width: 0, height: 0);
    super.initState();
  }

  void inc() {
    setState(() {
      if (no == 0) {
        tapLogic();
      } else {
        no += 1;
        selections.update(no, widget.title);
      }
    });
  }

  void dec() {
    setState(() {
      if (no > 0) {
        no -= 1;
      }
      if (no == 0) {
        tapLogic();
      }
    });
  }

  void tapLogic() {
    setState(() {
      if (!enab) {
        grad = [Colors.lightGreen[200], Colors.lightGreen[400]];
        enab = true;
        no = 1;
        selections.pushItem(widget.title, int.parse(widget.price));
      } else {
        grad = [
          MyColors().shadowDark,
          MyColors().alice,
        ];
        no = 0;
        enab = false;
        trail = Container(
          width: 0,
          height: 0,
        );
        selections.popItem(widget.title, int.parse(widget.price));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
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
                            colors: grad)),
                    child: Icon(widget.icon),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(widget.price)
                  ],
                ),
              ],
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 20),
                  onPressed: inc,
                  child: CircleAvatar(
                    radius: 10,
                    child: Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: MyColors().alice,
                  child: Text(
                    '$no',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                RawMaterialButton(
                  constraints: BoxConstraints(minWidth: 20),
                  onPressed: dec,
                  child: CircleAvatar(
                    radius: 10,
                    child: Icon(
                      Icons.remove,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  const OptionTile(
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
