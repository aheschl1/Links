
import 'package:flutter/material.dart';

class Decorations{
  BuildContext? context;

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

  ButtonStyle getButtonStyle1(){
    return ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            )
        ),
        elevation: MaterialStateProperty.all(10)
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