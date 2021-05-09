import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treatbees/pages/aboutus.dart';
import 'package:treatbees/pages/account.dart';
import 'package:treatbees/pages/cancellation.dart';
import 'package:treatbees/pages/contact.dart';
import 'package:treatbees/pages/home.dart';
import 'package:treatbees/pages/privacy.dart';
import 'package:treatbees/pages/term.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:treatbees/utils/widget.dart';

class TBSettings extends StatefulWidget {
  final User user;
  final String number;
  final String msg;
  final SharedPreferences sp;
  const TBSettings({Key key, this.user, this.number, this.msg, this.sp})
      : super(key: key);
  @override
  _TBSettingsState createState() => _TBSettingsState();
}

class _TBSettingsState extends State<TBSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home(
                      sp: null,
                      user: widget.user,
                      phone: widget.number,
                      msgToken: widget.msg,
                    )));
          },
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: size.width * 0.8,
              height: size.height * 0.7,
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
              child: Container(
                child: Column(
                  // runSpacing: 2.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutUS()));
                        },
                        child: Text(
                          "About us",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactUS()));
                        },
                        child: Text(
                          "Contact us",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PrivacyPolicy()));
                        },
                        child: Text(
                          "Privacy policy",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TermsConditions()));
                        },
                        child: Text(
                          "T&C",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CancellationPolicy()));
                        },
                        child: Text(
                          "Cancellation policy",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Colors.orangeAccent,
                        child: RawMaterialButton(
                          elevation: 0.0,
                          fillColor: MyColors().alice,
                          onPressed: () {
                            googleSignIn.signOut().then((value) {
                              if (widget.sp != null) {
                                widget.sp.setBool('available', false);
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            });
                          },
                          child: Text('Logout'),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
