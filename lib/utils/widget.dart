import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/utils/colors.dart';
import 'package:flutter/material.dart';

class TopButton extends StatelessWidget {
  const TopButton(
      {Key key,
      @required this.size,
      @required this.url,
      @required this.icon,
      @required this.title,
      @required this.subTitle})
      : super(key: key);

  final Size size;
  final String url;
  final String title;
  final String subTitle;
  final IconData icon;

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
                    color: Color.fromRGBO(218, 225, 233, 1),
                    offset: Offset(4.0, 4.0),
                    blurRadius: 15,
                    spreadRadius: 1),
                BoxShadow(
                    color: Color.fromRGBO(243, 250, 255, 1),
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(218, 225, 233, 1),
                              MyColors().alice,
                            ])),
                    child: Icon(icon),
                  ),
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
      @required this.subtitle})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(218, 225, 233, 1),
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15,
                  spreadRadius: 1),
              BoxShadow(
                  color: Color.fromRGBO(243, 250, 255, 1),
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15,
                  spreadRadius: 1)
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(218, 225, 233, 1),
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
      subtitle: Text("This is a good cafe"),
      trailing: RawMaterialButton(
          child: Text("Menu"),
          shape: StadiumBorder(),
          fillColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Menu(
                      cafeName: title,
                    )));
          }),
    );
  }
}

class Menutile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(218, 225, 233, 1),
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15,
                  spreadRadius: 1),
              BoxShadow(
                  color: Color.fromRGBO(243, 250, 255, 1),
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15,
                  spreadRadius: 1)
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(218, 225, 233, 1),
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
      subtitle: Text(price),
    );
  }
}
