import "dart:ui";
import 'package:flutter/material.dart';
class Notifications {
  String nImage = "";
  String nBody = "";
  String nTime = "";
  String nIcon = "";

  Notifications(this.nImage, this.nBody, this.nTime, this.nIcon);
}

//theme color

class ThemeColors{
  static const blueAccent = Color(0xff1773EA);
  static const blueNotification = Color(0xffECF2FB);
  static const liteGrey = Color(0xffdadada);
}
TextStyle notificationBody(){
  return const TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 16.0);
}
//textcolor

TextStyle notificationTime(){
  return const TextStyle(
      color: Colors.black54,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12.0);
}

TextStyle requestTitle(){
  return const TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
      fontSize: 16.0);
}

TextStyle profileTitle(){
  return const TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
      fontSize: 22.0);
}
TextStyle profileBio(){
  return const TextStyle(
      color: Colors.black54,
      fontFamily: 'Montserrat',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 16.0);
}

//suggestion model
class UserSuggestion {
  String sName = "";
  String sImage = "";
  String sMutual = "";

  UserSuggestion(this.sName, this.sImage, this.sMutual);
}