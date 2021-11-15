import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'package:email_auth/email_auth.dart';




class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

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
          "Incorrect OTP",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [
          okButton,
        ],
      ),
    );
  }


  var _isLogin = false;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userConfirmPass = '';
  var _verifyotp = '';

  bool submitValid = false;
  EmailAuth emailAuth;

  Future<bool> _showDialog(String email)async  {
   bool  ans;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify OTP" , style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.bold),),
          content: new Text("An OTP is sent to your provided email . Kindly verify your OTP in order to continue." , style: TextStyle(color: Theme.of(context).primaryColor),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new SizedBox(
              width: 50,
            ),
            new TextFormField(
              decoration: InputDecoration(labelText: 'OTP' ,  ),
              key: ValueKey('otp'),
              onChanged: (value) {
                setState(() {
                  _verifyotp = value;
                });
              },
              validator: (value) {
                if (value.isEmpty || value.length!=6) {
                  return 'Please enter a valid OTP';
                }


                return null;
              },
            ),
            new FlatButton(
              color: Theme.of(context).primaryColor,
              child: new Text("Verify"),
              onPressed:() async {

               if(verify(email)){
                  signUp(email: _userEmail , password: _userPassword);
                 Navigator.of(context).pop();

               }
               else {
                 Navigator.of(context).restorablePush(_dialogBuilder);
                   print("showdialog");
                   print(_userEmail);
               }
              },
            ),
          ],
        );
      },
    );
return await  ans;
  }
  //
  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "WeChat",
    );

    /// Configuring the remote server
    // emailAuth.config(remoteServerConfiguration);

  }

  /// a void function to verify if the Data provided is true
  /// Convert it into a boolean function to match your needs.
  bool verify(String email) {
    return(emailAuth.validateOtp(
        // recipientMail: _emailcontroller.value.text,
        // userOtp: _otpcontroller.value.text));
        recipientMail: email,
        userOtp: _verifyotp));

  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp(String email) async {

    bool result = await emailAuth.sendOtp(
        // recipientMail: _emailcontroller.value.text, otpLength: 5);
        recipientMail: email , otpLength: 6);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
    print("halne bhai");
    print(_userEmail);
  }

bool _isLoading=false;
  File _image;
  bool inProcess;
  String img_path;

  void _trySubmit(String email) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid && _image != null) {
      _formKey.currentState.save();
      sendOtp(email);
      _showDialog(email);
    }
  }

  final DBRef = FirebaseDatabase.instance.reference().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  final databaseRef = FirebaseDatabase.instance.reference();
  //SIGN UP METHOD

  Future signUp({String email, String password}) async {
    try {
      setState(() {
        _isLoading=true;
      });
      // final response=FirebaseAuth.instance.sendSignInLinkToEmail(email: _userEmail, actionCodeSettings: ActionCodeSettings());
      final  newUser=await  _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        _isLoading=false;
      });





      var img_path1 = await uploadFile(_image);




      setState(() {
    img_path = img_path1.toString();
  });
  if (img_path != null) {
   await FirebaseFirestore.instance.collection('username').add({
      '$_userEmail': _userName,
    });

   await FirebaseFirestore.instance.collection('images').add({
      '$_userEmail': img_path,
    });
  }
      setState(() {
        _isLogin=true;
      });


      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> uploadFile(File image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child("$_userEmail.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  void selectImageFromCamera() async {
    final picker = ImagePicker();
    setState(() {
      inProcess = true;
    });
    final imageFile = await picker.getImage(source: ImageSource.camera,imageQuality: 50);

    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
    setState(() {
      inProcess = false;
    });
  }

  void selectImageFromGallery() async {
    final picker = ImagePicker();
    setState(() {
      inProcess = true;
    });
    final imageFile = await picker.getImage(source: ImageSource.gallery , imageQuality: 50);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
    setState(() {
      inProcess = false;
    });
  }

  Widget dialogBox() {
    return AlertDialog(
      title: Text(
        'WeChat',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Text(
        'Choose an image from',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: [
        FlatButton(
          textColor: Colors.black,
          onPressed: () {
            selectImageFromCamera();
            Navigator.pop(context);
          },
          child: Text(
            'CAMERA',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        FlatButton(
          textColor: Colors.black,
          onPressed: () {
            selectImageFromGallery();
            Navigator.pop(context);
          },
          child: Text(
            'GALLERY',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    return _isLoading?Scaffold(body: Center(child: Container(height: 50, width: 50, child: CircularProgressIndicator(),),)): _isLogin
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
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                _image != null ? FileImage(_image) : null,
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => dialogBox()));
                            },
                            icon: Icon(Icons.image),
                            label: Text('Add an image'),
                            textColor: Theme.of(context).primaryColor,
                          ),
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
                            onChanged: (value) {
                              setState(() {
                                _userName = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter atleast 4 characters';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be atleast 7 characters long.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _userPassword = value;
                              });
                            },
                            obscureText: true,
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                            key: ValueKey('confirm_password'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long.';
                              } else if (value != _userPassword) {
                                return 'The password does not match';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _userConfirmPass = value;
                              });
                            },
                            obscureText: true,
                          ),

                          SizedBox(
                            height: 12,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Please upload an image.'),
                                    action: SnackBarAction(
                                      label: 'Okay',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                _trySubmit(_userEmail);
                                // sendOtp(_userEmail);
                                // _showDialog(_userEmail);
                              }
                            },
                            child: Text('Sign Up'),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text('I already have an account'),
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

