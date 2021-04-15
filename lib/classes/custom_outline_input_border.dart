import 'package:flutter/material.dart';

class CustomOutlineInputBorder extends OutlineInputBorder {
  final Color borderColor;

  CustomOutlineInputBorder({this.borderColor = Colors.transparent});

  @override
  BorderRadius get borderRadius {
    return BorderRadius.all(
      const Radius.circular(10.0),
    );
  }

  @override
  BorderSide get borderSide {
    return BorderSide(
      color: this.borderColor,
    );
  }
}
