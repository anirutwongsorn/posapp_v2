import 'package:flutter/material.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';

class RegisterCompletedPage extends StatelessWidget {
  final String shopName;
  const RegisterCompletedPage({Key? key, required this.shopName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SOFT_BLUE,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            buildAppLogo(height: 100),
            SizedBox(height: 20),
            Text(
              'ยินดีต้อนรับ',
              style: buildAppTextStyle(color: WHITE),
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                shopName,
                overflow: TextOverflow.clip,
                style: buildAppTextStyle(
                    color: WHITE, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            _buildRegisterButton(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _buildRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 22.0, right: 22.0, top: 8, bottom: 8),
            decoration: buildGradientColor(
                borderR: 12,
                color1: SOFT_ORANGE.withOpacity(.7),
                color2: SOFT_ORANGE.withOpacity(.5)),
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(fontSize: 16, color: WHITE),
            ),
          ),
        ),
      ],
    );
  }
}
