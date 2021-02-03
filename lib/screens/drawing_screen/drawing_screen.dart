import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/drawing_board.dart';




class DrawingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DrawingBoard(),
      ),
    );
  }
}
