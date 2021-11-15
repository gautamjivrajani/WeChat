import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat_screen.dart';
import 'signup_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    Widget okButton = FlatButton(
      color: Theme.of(context).accentColor,
      child: Text(
        "OK",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Error !',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        content: Text(
          "Account does not exist !",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [
          okButton,
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _image_url = '';

  var tp = '';

  User firebaseUser = FirebaseAuth.instance.currentUser;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      print(_userEmail);
      print(_userPassword);
      print(_userName);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({String email, String password}) async {
    try {
      // getData();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        _isLogin = true;
      });
      print(_isLogin);

      return null;
    } on FirebaseAuthException catch (e) {
      // return _showAlertDialog;
      return Navigator.of(context).restorablePush(_dialogBuilder);
      // return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }

  void _WeChat() async {
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('messages')
        .doc(user.uid)
        .get();

    setState(() {
      _image_url = userData['image_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _WeChat();

    return _isLogin
        ? ChatScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                InputDecoration(labelText: 'Email address'),
                            key: ValueKey('email'),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmail = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value;
                            },
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RaisedButton(
                            onPressed: () {
                              _trySubmit();
                              signIn(
                                  email: _userEmail, password: _userPassword);
                              // if (!_isLogin) Navigator.of(context).restorablePush(_dialogBuilder);
                            },
                            child: Text('Login'),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text('Create new Account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
