
import 'package:flutter/material.dart';

class Decorations{
  BuildContext context;

  Decorations({this.context});

  InputDecoration getTextInput(String hint){
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.black38),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(50.0),
        ),
      ),
    );
  }

  InputDecoration getTitleInput(String hint){
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.black38),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(2),
        ),
      ),
    );
  }

  InputDecoration getTextInputCreate(String hint){
    return InputDecoration(
      hintStyle: TextStyle(color: Colors.black38),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
    );
  }


}