import 'package:flutter/material.dart';
import 'package:posapp_v2/app_constants/app_color.dart';

class AppErrorPage extends StatelessWidget {
  final Function() callBack;
  const AppErrorPage({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildEmptyWidgets();
  }

  _buildEmptyWidgets() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mood_bad_sharp,
            color: ASSENT_COLOR,
            size: 60,
          ),
          SizedBox(height: 12),
          Text(
            'การเชื่อมต่อฐานข้อมูลล้มเหลว !',
            style: TextStyle(color: ASSENT_COLOR),
          ),
          SizedBox(height: 22),
          IconButton(
            onPressed: () {
              this.callBack();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
