import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/pages/inventory/inventory_page.dart';
import 'package:posapp_v2/pages/member_details_page.dart';
import 'package:posapp_v2/pages/report/daily_bill_sale.dart';
import 'package:posapp_v2/pages/report/daily_employee_sale.dart';
import 'package:posapp_v2/pages/report/daily_summary_sale.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarPageState createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  int _currentIndex = 0;

  final List<Widget> _contentPages = <Widget>[
    DailySaleReportPage(),
    DailyBillMainPage(),
    DailySaleEmployeePage(),
    InventoryPage(),
    MemberPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _handleTabSelection(index);
        },
        selectedFontSize: 10,
        unselectedFontSize: 8,
        iconSize: 24,
        items: [
          BottomNavigationBarItem(
            label: 'รายงานขาย',
            icon: FaIcon(FontAwesomeIcons.piggyBank,
                color: _currentIndex == 0 ? SOFT_BLUE : CHARCOAL),
          ),
          BottomNavigationBarItem(
            label: 'บิลขาย',
            icon: FaIcon(FontAwesomeIcons.shoppingBasket,
                color: _currentIndex == 1 ? SOFT_BLUE : CHARCOAL),
          ),
          BottomNavigationBarItem(
            label: 'พนักงาน',
            icon: Icon(Icons.supervisor_account_sharp,
                color: _currentIndex == 2 ? SOFT_BLUE : CHARCOAL),
          ),
          BottomNavigationBarItem(
            label: 'คลัง',
            icon: FaIcon(
              FontAwesomeIcons.warehouse,
              color: _currentIndex == 3 ? SOFT_BLUE : CHARCOAL,
            ),
          ),
          BottomNavigationBarItem(
            label: 'ผู้ใช้งาน',
            icon: FaIcon(FontAwesomeIcons.user,
                color: _currentIndex == 4 ? SOFT_BLUE : CHARCOAL),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: _contentPages.map((Widget content) {
        return content;
      }).toList(),
    );
  }

  void _handleTabSelection(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
