import 'package:flutter/material.dart';

InputDecoration buildLoginDecoration(
    {IconData icon = Icons.lock, String hintText = ''}) {
  return InputDecoration(
    counterText: '',
    icon: Icon(icon),
    focusColor: Colors.white,
    border: InputBorder.none,
    hintText: hintText,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

InputDecoration buildLoginDecorationNoIcon({String hintText = ''}) {
  return InputDecoration(
    counterText: '',
    //icon: Icon(icon),
    labelText: hintText,
    labelStyle: TextStyle(backgroundColor: Colors.transparent),
    focusColor: Colors.white,
    //border: InputBorder.none,
    hintText: hintText,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
