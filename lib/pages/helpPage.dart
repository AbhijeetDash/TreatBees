import 'package:flutter/material.dart';
import 'package:treatbees/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpInfo extends StatefulWidget {
  @override
  _HelpInfoState createState() => _HelpInfoState();
}

class _HelpInfoState extends State<HelpInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text("For any order related query\nOR\nif your order status isn't updating\n call / whats-app\nus on any of these number", textAlign: TextAlign.center,),
            SizedBox(height: 20.0,),
            Text("+91 6265610435", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 5.0,),
            RawMaterialButton(
              child: Text("Call"),
                fillColor: Colors.orange,
                onPressed: (){
                  launch("tel://+91 6265610435");
            }),
            SizedBox(height: 10.0,),
            Text("+91 9845904285", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 5.0,),
            RawMaterialButton(
                child: Text("Call"),
                fillColor: Colors.orange,
                onPressed: (){
                  launch("tel://+91 9845904285");
            }),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}
