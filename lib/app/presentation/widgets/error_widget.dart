import 'package:flutter/material.dart';

class ErrorsWidget extends StatelessWidget {
  final String message;
  ErrorsWidget({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 360,
        child: Center(
          child: FittedBox(
            child: Text(message,
                style: TextStyle(fontSize: 14.0, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
