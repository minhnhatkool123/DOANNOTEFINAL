import 'package:doannote/screen/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.g,
      // ),
      theme: ThemeData(
        textTheme: TextTheme(
          headline5: TextStyle(
            fontFamily: 'Sans',
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: AnimatedSplashScreen(
        splash: Container(
          //width: 500,
          //height: 10000,
          color: Colors.amber[400],
          child: Image.asset('assets/anh1.png'
              //'https://zicxaphotos.com/wp-content/uploads/2020/07/girl-xinh-cap-3-1.jpg',
              ),
        ),
        nextScreen: NoteList(),
        duration: 3000,
        splashIconSize: 10000,
      ),
    );
  }
}
