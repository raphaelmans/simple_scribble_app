
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worlls/screens/drawing_screen/domains/helper_functions.dart';
import 'package:worlls/screens/drawing_screen/drawing_screen.dart';
import 'dart:ui' as ui;
import '../domains/drawing_painter.dart';
import 'drawing_action.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  ui.Image image;
  var points = <Offset>[];
  bool drawCache = false;
  bool saveImg = false;
  String filename = "";

  Future<void> _showMyDialog(size) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File name: '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    setState(() {
                      filename = value;
                    });
                  },
                  cursorColor: Colors.black45,
                  decoration: InputDecoration(
                      focusColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.black,
                      ))),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  saveImg = false;
                });
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                saveCanvas(filename, size);
                setState(() {
                  saveImg = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void drawCanvasCache(size) async {
    if (points.length > 50 && !drawCache) {
      drawCache = true;
      var points = this.points;
      var numPoints = points.length;
      var recorder = ui.PictureRecorder();
      var canvas = ui.Canvas(recorder);

      DrawingPainter(image, points).paint(canvas, size);

      var picture = recorder.endRecording();
      var newImage = await picture.toImage(
        size.width.round(),
        size.height.round(),
      );
      if (points == this.points) {
        image?.dispose();
        image = newImage;
        points.removeRange(0, numPoints);
        drawCache = false;
      }
    }
  }

  void saveCanvas(filename, size) async {
    final folderName = 'scribbles';
    final recorder = ui.PictureRecorder();
    var canvas = ui.Canvas(recorder);

    DrawingPainter(image, points).paint(canvas, size);
    final picture = recorder.endRecording();
    final newImage =
        await picture.toImage(size.width.round(), size.height.round());

    final pngBytes = await newImage.toByteData(format: ui.ImageByteFormat.png);
    final directory = await getApplicationDocumentsDirectory();

    print(directory);

    final assetDir = await createDir(directory.path,folderName);

    var path = '$assetDir$filename.png';
    filename = eliminateFileDuplicate(path, assetDir, filename);



    final fullPath = assetDir + '$filename.png';
    print(fullPath);
    await writeToFile(pngBytes, fullPath);
    await ImageGallerySaver.saveImage(pngBytes.buffer.asUint8List(),name: filename).then((value)=>print(value));

  }


  SnackBar imgSnackBar(bool isSuccess) {
    return SnackBar(
      content: Container(
        alignment: Alignment.center,
        height: 24.0,
        child: Text(
          isSuccess ? 'Image saved successfully!' : 'Canvas is empty',
          style: Theme.of(context).textTheme.caption,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
      ),
      duration: Duration(milliseconds: 2000),
      backgroundColor: Colors.white,
    );
  }

  build(context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          child: CustomPaint(
            painter: DrawingPainter(image, points),
            willChange: true,
            child: Container(
              height: size.height,
              width: size.width,
            ),
          ),
          onPanStart: (drag) {
            setState(() {
              points.add(drag.localPosition);
            });
            drawCanvasCache(size);
          },
          onPanUpdate: (drag) {
            setState(() {
              points.add(drag.localPosition);
            });
            drawCanvasCache(size);
          },
          onPanEnd: (drag){
            setState(() {
              points.add(null);
            });
          },
        ),
        Positioned(
            bottom: 5,
            right: 5,
            child: DrawingAction(
              icon: Icon(FontAwesomeIcons.eraser),
              userAction: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => DrawingScreen()));
              },
            )),
        Positioned(
          bottom: 5,
          right: 65,
          child: DrawingAction(
            icon: Icon(FontAwesomeIcons.arrowDown),
            userAction: () async {
              if (points.isEmpty && image == null) {
                ScaffoldMessenger.of(context).showSnackBar(imgSnackBar(false));
              } else {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.accessMediaLocation,
                  Permission.storage,
                ].request();


                if(statuses.values.every((element) => element.isGranted)){
                  await _showMyDialog(size);
                  if (saveImg) {
                    ScaffoldMessenger.of(context).showSnackBar(imgSnackBar(true));
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
