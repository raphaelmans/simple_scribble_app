import 'package:flutter/material.dart';

typedef void UserAction();

class DrawingAction extends StatelessWidget {
  final Icon icon;
  final UserAction userAction;
  const DrawingAction({Key key, this.icon, this.userAction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: TextButton(
        onPressed: () {
          userAction();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
          ],
        ),
      ),
    );
  }
}
