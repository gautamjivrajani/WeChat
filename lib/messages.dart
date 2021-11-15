import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final bool col;
  Messages(this.col);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, chatSnapShot) {
        return !chatSnapShot.hasData
            ? Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        )
            : ListView.builder(
                reverse: true,
                itemBuilder: (ctx, index) =>!chatSnapShot.hasData
                    ? Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
                    : MessageBubble(
                      message: chatSnapShot.data.docs[index]['chat_msg'],
                      email: chatSnapShot.data.docs[index]['email'],
                      username: chatSnapShot.data.docs[index]['username'],
                      img_url: chatSnapShot.data.docs[index]['image_url'],
                      col: col,
                    ),
                itemCount: chatSnapShot.data.docs.length);
      },
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
