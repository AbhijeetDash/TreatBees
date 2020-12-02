import 'package:TreatBees/pages/home.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  final User user;
  final SharedPreferences sp;
  const UserDetails({Key key, this.user, this.sp}) : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController controller;
  bool isPressed = true;

  @override
  void initState() {
    controller = TextEditingController();
    isPressed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: MyColors().alice,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Contact info",
              style: MyFonts().headingBold,
            ),
            SizedBox(height: 10),
            Text(
              "We would need your contact information\nto provide you order updates.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Phone Numner",
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We will share this detail only with the Cafe when you order someting",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            isPressed
                ? RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        isPressed = false;
                      });
                      FirebaseCallbacks()
                          .createUser(widget.user.email,
                              widget.user.displayName, controller.text)
                          .then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Home(
                                  sp: widget.sp,
                                  user: widget.user,
                                  phone: controller.text,
                                )));
                      });
                    },
                    shape: StadiumBorder(),
                    fillColor: Colors.orange,
                    child: Text("Update"),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
