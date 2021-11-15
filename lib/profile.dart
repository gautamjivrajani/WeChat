import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String image;
  final String username;
  final String email;
  final bool col;

  Profile({this.image, this.username, this.email, this.col});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //

      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: col ? Theme.of(context).primaryColor : Colors.black54,
        title: Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          color: col ? Colors.pink[200] : Colors.black26,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    radius: 200.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(1.0),
                  margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 25.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: col
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      SizedBox(width: 10.0),
                      Text(username),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: col
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      SizedBox(width: 10.0),
                      Text(email),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
