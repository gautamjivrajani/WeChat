import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String email;
  final String img_url;
  final bool col;

  MessageBubble(
      {this.message, this.username, this.email, this.img_url, this.col});

  @override
  Widget build(BuildContext context) {
    bool isMe = FirebaseAuth.instance.currentUser.email == email;

    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? (col ? Colors.grey[500] : Colors.blueGrey)
                    : (col ? Theme.of(context).accentColor : Colors.black54),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 160,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                image: img_url,
                                username: username,
                                email: email,
                                col: col,
                              )));
                },
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // color: isMe
                          //     ? Colors.black
                          //     : Theme.of(context).accentTextTheme.title.color,
                          color: Colors.white),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                          // color: isMe
                          //     ? Colors.black
                          //     : Theme.of(context).accentTextTheme.title.color,
                          color: Colors.white),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 130,
          right: isMe ? 130 : null,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              img_url,
            ),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
