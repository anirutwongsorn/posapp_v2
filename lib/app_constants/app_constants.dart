import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posapp_v2/app_constants/app_color.dart';

Image buildAppLogo({double height = 70}) {
  return Image.asset(
    'assets/images/logo/mtech2.png',
    height: height,
  );
}

Text buildAppText(
    {String txt = '-',
    TextAlign textAlign = TextAlign.start,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = SOFT_BLUE}) {
  return Text(txt,
      textAlign: textAlign,
      style: buildAppTextStyle(
          fontSize: fontSize, fontWeight: fontWeight, color: color));
}

Padding buildAppDivider() {
  return Padding(
    padding: const EdgeInsets.only(left: 12, right: 12),
    child: Divider(color: Colors.white70),
  );
}

TextStyle buildAppTextStyle(
    {double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = SOFT_BLUE}) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}

Column buildLogoLoading() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      buildAppLogo(),
      Padding(
        padding: const EdgeInsets.only(top: 90),
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    ],
  );
}

Column buildEmptySection({required String errMsg}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      buildAppLogo(),
      Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Text(
          errMsg,
          style: buildAppTextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}

buildBlackDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.black.withOpacity(.5),
  );
}

BoxDecoration buildGradientColor(
    {double borderR = 50,
    Color color1 = SOFT_BLUE,
    Color color2 = SECONDARY_COLOR}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderR),
    gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [color1, color2],
      stops: [0.3, 0.95],
    ),
  );
}

final numberFormat = new NumberFormat("#,###");

final yyFormat = new DateFormat('yy');
