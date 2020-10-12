import 'package:TreatBees/pages/menu.dart';
import 'package:TreatBees/utils/colors.dart';
import 'package:TreatBees/utils/selections.dart';
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
      subtitle: Text("This is a good cafe"),
      trailing: RawMaterialButton(
          child: Text("Menu"),
          shape: StadiumBorder(),
          fillColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Menu(
                      cafeName: title,
                    )));
          }),
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
      @required this.subTitle})
      : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
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
