import 'package:flutter/services.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat_screen.dart';
import 'login_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pinkAccent,
        accentColor: Colors.pinkAccent,
        accentColorBrightness: Brightness.light,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    // return SplashScreenView(
    //   navigateRoute: FirebaseAuth.instance.currentUser != null
    //       ? ChatScreen()
    //       : LoginScreen(),
    //   duration: 10000,
    //   imageSize: 500,
    //   imageSrc: 'images/icons1.png',
    //   text: 'WeChat',
    //   textType: TextType.ScaleAnimatedText,
    //   textStyle: TextStyle(
    //       fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
    //   backgroundColor: Colors.pinkAccent,
    // );

    return SplashScreenView(
      navigateRoute: FirebaseAuth.instance.currentUser != null
          ? ChatScreen()
          : LoginScreen(),
      duration: 3000,
      imageSize: 300,
      imageSrc: 'images/icons2.png',
      text: "WeChat",
      speed: 2,
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 80.0,
        fontWeight: FontWeight.bold,
      ),

      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
  }
}
