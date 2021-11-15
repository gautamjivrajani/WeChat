import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/login_screen.dart';
import 'package:flutter_chat/messages.dart';

import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  String email = FirebaseAuth.instance.currentUser.email;
  var username;
  var img_url;

  ChatScreen();
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  bool load=false;


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?' , style: TextStyle(color: col?Theme.of(context).primaryColor : Colors.black54),),
        content: new Text('Do you want to exit an App' , style: TextStyle(color: col?Theme.of(context).primaryColor : Colors.black54),),
        actions: <Widget>[
          FlatButton(
            color:col?Theme.of(context).primaryColor : Colors.black54,
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),

          ),
          FlatButton(
            color: col?Theme.of(context).primaryColor : Colors.black54,
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  // hal ready
  //phone ave etle karu ek j min
  //ok

  bool col = true;
  var _userId = '';

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('messages');

  Future<void> getData() async {
    final image_value =
        await FirebaseFirestore.instance.collection('images').get();
    final usernames =
        await FirebaseFirestore.instance.collection('username').get();

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('images');
    CollectionReference _collectionRef1 =
    FirebaseFirestore.instance.collection('username');
// setState(() {
//   load=true;
// });
    QuerySnapshot querySnapshot = await _collectionRef.get();
    QuerySnapshot querySnapshot1 = await _collectionRef1.get();
    // setState(() {
    //   load=false;
    // });
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allData1 = querySnapshot1.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < allData1.length; i++) {
      Map<dynamic, dynamic> m = allData1[i];
      if (m.keys.first == widget.email) {
        setState(() {
          widget.username = m.values.first;
        });
      }
    }

    for (int i = 0; i < allData.length; i++) {
      Map<dynamic, dynamic> m = allData[i];
      if (m.keys.first == widget.email) {
        setState(() {
          widget.img_url = m.values.first;
        });
      }
    }

   }

  var _chat_message = '';

  final _controller = new TextEditingController();

  User firebaseUser = FirebaseAuth.instance.currentUser;

  //SIGN OUT METHOD
  Future signOut() async {
    // await _auth.signOut();
    await FirebaseAuth.instance.signOut();

    print('signout');
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(
                  email: widget.email,
                  username: widget.username,
                  image: widget.img_url,
                  col: col,
                )));
        break;
      case 1:
        setState(() {
          col = !col;
        });
        break;
      case 2:
        signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
   getData();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: col ? Theme.of(context).accentColor : Colors.black54,
          title: Text(
            'WeChat',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color: col ? Colors.pink[300] : Colors.black,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          "My Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.brightness_6_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Change Theme",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ],
                onSelected: (item) => SelectedItem(context, item),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Messages(col),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      labelStyle: TextStyle(
                          color: col
                              ? Theme.of(context).primaryColor
                              : Colors.black54),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(

                            color: col
                                ? Theme.of(context).primaryColor
                                : Colors.black54),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: col
                                ? Theme.of(context).primaryColor
                                : Colors.black54),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _chat_message = value;
                        print(_chat_message);
                      });
                    },
                  ),
                ),
                RaisedButton.icon(
                    color: _chat_message.length == 0
                        ? Colors.grey[200]
                        : col
                            ? Theme.of(context).accentColor
                            : Colors.black54,
                    onPressed: _chat_message.length != 0
                        ? () {
                            FirebaseFirestore.instance
                                .collection('messages')
                                .add({
                              'chat_msg': '$_chat_message',
                              'createdAt': Timestamp.now(),
                              'email': widget.email,
                              'userId': _userId,
                              'username': widget.username,
                              'image_url': widget.img_url,
                            });

                            FocusScope.of(context).unfocus();
                            _controller.clear();

                            print(_chat_message);
                            _chat_message = "";
                          }
                        : () {},
                    icon: Icon(Icons.send),
                    label: Text('Send')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
