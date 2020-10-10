import 'package:TreatBees/utils/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.0,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Treat', style: MyFonts().smallHeadingBold),
            TextSpan(text: 'Bees', style: MyFonts().smallHeadingLight)
          ]),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Welcome ',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                  TextSpan(
                      text: 'Julia   ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 25,
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/wave.png'),
                  fit: BoxFit.fitHeight,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
