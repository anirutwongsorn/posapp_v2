import 'package:flutter/material.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color txtColor;
  const ErrorAlertDialog(
      {Key? key,
      required this.title,
      required this.content,
      this.txtColor = SECONDARY_COLOR})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        style: buildAppTextStyle(color: txtColor),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildClosetButton(context),
            // _buildClosetButton(context),
          ],
        )
      ],
    );
  }

  _buildClosetButton(context) {
    return TextButton(
      child: Text(
        'ปิดหน้าต่าง',
        style: TextStyle(color: CHARCOAL),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
