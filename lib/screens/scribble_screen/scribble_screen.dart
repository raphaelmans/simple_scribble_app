import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:worlls/screens/drawing_screen/domains/drawing_painter.dart';

class ScribbleScreen extends StatefulWidget {
  final image;

  ScribbleScreen(this.image);
  @override
  _ScribbleScreenState createState() => _ScribbleScreenState();
}

class _ScribbleScreenState extends State<ScribbleScreen> {


  @override
  Widget build(BuildContext context) {

    final uIntImg = Uint8List.fromList(widget.image.codeUnits);
    return Scaffold(
      appBar: AppBar(
        title: Text('Scribble Screen'),
      ),
      body: Container(
        child:
          Image.memory(uIntImg),
      ),
    );
  }
}
