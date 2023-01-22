import 'package:flutter/material.dart';

// Get the height, proportionally to screen height
double getScreenPropotionHeight(double actualHeight, Size size) {
  // 896 is the artboard height that designer use
  return (actualHeight / 896.0) * size.height;
}

// Get the width, proportionally to screen width
double getScreenPropotionWidth(double actualWidth, Size size) {
  // 414 is the artboard width that designer use
  return (actualWidth / 414.0) * size.width;
}
const kPrimaryColor = Color(0XFF2DBB54);
const kTextColor = Color(0XFF303030);
const kTextLightColor = Color(0XFFD9D9D9);
const kIndicatorColor = Color(0XFFCBCCD5);
const kBackgroundColor = Color(0XFFF6F8FF);
const kDividerColor = Color(0XFFF6F6F6);

const kDefaultPadding = 18.0;