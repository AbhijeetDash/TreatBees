import 'dart:async';

import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/colors.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController fadeController;
  Animation anim;

  void drive() {
    Timer(Duration(milliseconds: 500), () {
      fadeController.forward();
    });
  }

  @override
  void initState() {
    fadeController = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    anim = new Tween(begin: 0.0, end: 1.0).animate(fadeController);
    drive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: MyColors().alice,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Hero(
                      tag: "Logo",
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(text: 'Treat', style: MyFonts().headingBold),
                          TextSpan(text: 'Bees', style: MyFonts().headingLight)
                        ]),
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                FadeTransition(
                  opacity: anim,
                  child: SizedBox(
                      width: width * 0.7,
                      child: Text(
                        'Hello there, we are glad to welcome you to our TreatBees community',
                        textAlign: TextAlign.center,
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                FadeTransition(
                  opacity: anim,
                  child: SizedBox(
                    height: 60,
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                          color: MyColors().alice,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                      child: RawMaterialButton(
                          splashColor: Colors.white.withOpacity(0.6),
                          shape: StadiumBorder(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/g.png'))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  "Sign-in",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
                bottom: -80,
                right: -50,
                child: Hero(
                  tag: "Icon",
                  child: Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/foodIllus.png')))),
                ))
          ],
        ),
      ),
    );
  }
}
