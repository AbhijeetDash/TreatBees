import 'package:TreatBees/utils/theme.dart';
import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  double dragStartPoint, dragEndPoint;

  @override
  void initState() {
    ///Fetch all the groups of this user..
    ///and make the list.

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: MyColors().alice,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          splashColor: Color.fromRGBO(0, 0, 0, 0),
          onPressed: () {
            showModalBottomSheet(
                enableDrag: true,
                context: context,
                builder: (context) {
                  return BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18.0, bottom: 12.0, left: 18.0),
                                child: Text("Create a Group",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      helperText: "Give the group a name",
                                      labelText: "Group Name",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 12.0, left: 18.0),
                                child: Text("Select Group Avatar",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 50,
                                      minRadius: 40,
                                      child: RawMaterialButton(
                                        shape: CircleBorder(),
                                        splashColor: Colors.orange,
                                        onPressed: () {},
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage('assets/ava1.png'),
                                          maxRadius: 45,
                                          minRadius: 35,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 18),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0, top: 18.0, left: 18.0),
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  shape: StadiumBorder(),
                                  fillColor: Colors.orange,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Create Group"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_sharp,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Text(
                'No Groups Found\nTap anywhere to create one',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
