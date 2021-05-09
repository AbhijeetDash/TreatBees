import 'package:flutter/material.dart';
import 'package:treatbees/pages/privacy.dart';
import 'package:treatbees/utils/theme.dart';

class ContactUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: size.width,
        height: size.height,
        color: MyColors().alice,
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeadingText(heading: 'Contact Us'),
                  SizedBox(
                    height: 10,
                  ),
                  BodyText(
                      bodyText:
                          "We at TreatBees are dedicated to resolve your queries. For any question, complaints or feature request \n\nDrop a mail at : treatbees.dev@gmail.com"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: RawMaterialButton(
                    fillColor: Colors.orange,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
