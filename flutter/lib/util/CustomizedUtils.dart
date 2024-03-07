import 'package:flutter/material.dart';

// Customized Text
Widget CustomizedText(String txt,
    {double font_size=24.0,//Named Parameters
      Color font_color=Colors.white,
      FontWeight font_Weight = FontWeight.bold})
{
  return Text(txt,
      style: TextStyle(
        fontSize: font_size,
        color: font_color,
        fontWeight: font_Weight,
      ));
}

Widget mySpace(double height){
  return SizedBox(height: height);
}

class BoolWrapper{
  late bool _val;
  BoolWrapper(this._val);
  void setVal(bool val){
    _val = val;
  }
  bool getVal()=>_val;
}