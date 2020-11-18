import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String groupName;

  const ChatRoom({Key key, this.groupName}) : super(key: key);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _editingController;

  void handleClick(String value) {
    switch (value) {
      case 'Create Group':
        break;
    }
  }

  @override
  void initState() {
    _editingController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0.0,
          title: Text(widget.groupName),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Join Link'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/chatroom.jpg'),
                    fit: BoxFit.cover)),
            child: ListView()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: _editingController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(style: BorderStyle.none, width: 0.0),
                            borderRadius: BorderRadius.circular(30),
                            gapPadding: 2.0)),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
