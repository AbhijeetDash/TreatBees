import 'package:TreatBees/pages/chatPage.dart';
import 'package:TreatBees/utils/functions.dart';
import 'package:TreatBees/utils/theme.dart';
import 'package:TreatBees/utils/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  final User user;

  const Groups({Key key, this.user}) : super(key: key);
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  double dragStartPoint, dragEndPoint;
  TextEditingController textEditingController;

  void handleClick(String value) {
    Widget create = Text("Create Group");
    switch (value) {
      case 'Create Group':
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
                              controller: textEditingController,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GroupAvatar(
                                  img: 'assets/ava1.png',
                                ),
                                SizedBox(width: 18),
                                GroupAvatar(
                                  img: 'assets/ava2.png',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, top: 18.0, left: 18.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  create = CircularProgressIndicator();
                                });
                                String groupName = textEditingController.text;
                                FirebaseCallbacks()
                                    .createGroup(groupName, widget.user.email)
                                    .then((value) {
                                  if (value) {
                                    _GroupsState().build(context);
                                    Navigator.pop(context);
                                    setState(() {
                                      textEditingController.text = "";
                                    });
                                    initState();
                                  }
                                }).catchError((onError) {
                                  setState(() {
                                    create = Text("Create Group");
                                  });
                                });
                              },
                              shape: StadiumBorder(),
                              fillColor: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: create,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            });
        break;
      case 'Join Group':
        break;
    }
  }

  @override
  void initState() {
    textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: TitleWidget(),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Create Group', 'Join Group'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
          color: MyColors().alice,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: FirebaseCallbacks().getGroups(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        var data = snapshot.data[i]['_fieldsProto'];
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage('assets/ava1.png'),
                              ),
                              title:
                                  Text('${data['groupName']['stringValue']}'),
                              subtitle: Text(
                                  'Admin: ${data['adminMail']['stringValue']}'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                          groupName: data['groupName']
                                              ['stringValue'],
                                        )));
                              },
                            ),
                            Divider(
                              thickness: 5.0,
                            ),
                          ],
                        );
                      });
                }
                return NoGroupView(
                  textEditingController: textEditingController,
                  widget: widget,
                  onPressedCreateGroup: () {
                    handleClick('Create Group');
                  },
                  onPressedJoinGroup: () {
                    handleClick('Join Group');
                  },
                );
              })),
    );
  }
}

class NoGroupView extends StatefulWidget {
  const NoGroupView(
      {Key key,
      @required this.textEditingController,
      @required this.widget,
      @required this.onPressedCreateGroup,
      @required this.onPressedJoinGroup})
      : super(key: key);

  final TextEditingController textEditingController;
  final Groups widget;
  final GestureTapCallback onPressedCreateGroup, onPressedJoinGroup;

  @override
  _NoGroupViewState createState() => _NoGroupViewState();
}

class _NoGroupViewState extends State<NoGroupView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.grey[600],
            size: 100,
          ),
          SizedBox(height: 10),
          Text(
            "You are not part of any group\nYou can either create one or join one",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RawMaterialButton(
                fillColor: Colors.orange,
                splashColor: Color.fromRGBO(0, 0, 0, 0),
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Create Group"),
                ),
                onPressed: widget.onPressedCreateGroup,
              ),
              SizedBox(width: 20),
              RawMaterialButton(
                fillColor: Colors.orange,
                splashColor: Color.fromRGBO(0, 0, 0, 0),
                shape: StadiumBorder(),
                onPressed: widget.onPressedJoinGroup,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Join Group"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GroupAvatar extends StatefulWidget {
  final String img;
  const GroupAvatar({Key key, @required this.img}) : super(key: key);

  @override
  _GroupAvatarState createState() => _GroupAvatarState();
}

class _GroupAvatarState extends State<GroupAvatar> {
  Color selected = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 50,
      minRadius: 40,
      backgroundColor: selected,
      child: RawMaterialButton(
        splashColor: Colors.orange,
        onPressed: () {
          setState(() {
            selected == Colors.grey
                ? selected = Colors.orange
                : selected = Colors.grey;
          });
        },
        child: CircleAvatar(
          backgroundImage: AssetImage(widget.img),
          maxRadius: 45,
          minRadius: 35,
        ),
      ),
    );
  }
}
