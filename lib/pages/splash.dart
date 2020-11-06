import 'dart:async';

import 'package:TreatBees/pages/account.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController fadeController;
  Animation anim;
  SharedPreferences sp;

  void toLogin() {
    Timer(Duration(milliseconds: 500), () {
      fadeController.forward().whenComplete(() => {
            Timer(Duration(milliseconds: 600), () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (a, b, c) {
                    return Login();
                  },
                  transitionDuration: Duration(milliseconds: 400)));
            })
          });
    });
  }

  Future<void> driver() async {
    sp = await SharedPreferences.getInstance();
    if (sp.getKeys().contains('done')) {
      // Call google login and go to home
    } else {
      toLogin();
    }
  }

  @override
  void initState() {
    // Initialising Basic Animation Variables
    fadeController = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    anim = new Tween(begin: 0.0, end: 1.0).animate(fadeController);

    //Calling the driver Function if Everyting is configured
    driver();
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
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(30),
                child: FadeTransition(
                  opacity: anim,
                  child: Hero(
                    tag: "Logo",
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Treat', style: MyFonts().headingBold),
                        TextSpan(text: 'Bees', style: MyFonts().headingLight)
                      ]),
                    ),
                  ),
                )),
            Positioned(
              right: -50,
              child: FadeTransition(
                opacity: anim,
                child: Hero(
                  tag: "Icon",
                  child: Container(
                    width: width * 0.7,
                    height: 300,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/foodIllus.png'))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
