

import 'package:flutter/material.dart';
import 'screens/drawing_screen/drawing_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.resolveWith((states) => Size.square(60.0)),
            foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
            overlayColor: MaterialStateProperty.resolveWith((states) => Colors.black12),
            shape: MaterialStateProperty.resolveWith((states) => CircleBorder()),
          )
        )
      ),
      home: DrawingScreen(),
    );
  }
}



