import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/pages/inventory/inventory_management.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/member/member_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/inventory/product_inventory_bloc.dart';
import 'package:posapp_v2/provider/models/model_product_Inventory.dart';
import 'package:posapp_v2/provider/services/service_network.dart';
import 'package:responsive_grid/responsive_grid.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with AutomaticKeepAliveClientMixin {
  ProductInventoryBloc? _inventoryBloc;

  LoginBloc? _loginBloc;

  MemberBloc? _memberBloc;

  double _width = 0;

  String dbname = "", branch = "";

  Color _black = Colors.black.withOpacity(.4);

  Future<void> getDatabaseName() async {
    dbname = await NetworkService().getInitDB();
    branch = await NetworkService().getBranch();
    if (_inventoryBloc!.state is! ProductInventoryLoadSuccess) {
      _inventoryBloc!.add(GetInventory(dbname: dbname));
    }
  }

  var formatter = new NumberFormat("#,###", 'en_US');

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc!.add(CheckLogin());

    _inventoryBloc = BlocProvider.of<ProductInventoryBloc>(context);

    _memberBloc = BlocProvider.of<MemberBloc>(context);
    if (_memberBloc!.state is! MemberLoadSuccess) {
      _memberBloc!.add(GetMember());
    }

    getDatabaseName();
    super.initState();
  }

  Future _handleRefresh() async {
    // await Future.delayed(Duration(
    //   seconds: 2,
    // ));
    await getDatabaseName();
    _inventoryBloc!.add(GetInventory(dbname: dbname));
    branch = await NetworkService().getBranch();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (context, state) {
          if (state is LoginLoggedOut) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (Route<dynamic> route) => route is LoginPage);
          }
        },
        child: _buildMainUI(),
      ),
    );
  }

  _buildMainUI() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [DARK_GREEN, LIGHT_GREEN],
            stops: [0.3, 0.95],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<ProductInventoryBloc, ProductInventoryState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      branch == "" ? _memberBloc!.branch : branch,
                      style: buildAppTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _width / 1.2,
                    child: _buildTextFilter(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildLoadInventory(),
            ],
          ),
        ),
      ),
    );
  }

  _buildLoadInventory() {
    return BlocBuilder<ProductInventoryBloc, ProductInventoryState>(
      bloc: _inventoryBloc,
      builder: (context, state) {
        if (state is ProductInventoryLoadSuccess) {
          return _buildResponsiveGrid(model: state.model);
        }

        if (state is ProductInventoryFiltering) {
          return _buildResponsiveGrid(model: state.model);
        }

        if (state is ProductInventoryFiltering) {
          return _buildListView(model: state.model);
        }

        if (state is ProductInventoryLoadError) {
          return _buildEmptyWidgets();
        }

        return Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  _buildTextFilter() {
    return TextField(
      decoration: InputDecoration(
        focusColor: Colors.white,
        border: InputBorder.none,
        hintText: 'ค้นหาสินค้า',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (val) {
        _inventoryBloc!.add(GetInventoryFilter(
            keyword: val, model: _inventoryBloc!.productModel));
      },
    );
  }

  _buildListView({required List<ProductInvModel> model}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductManagerPage(
                      invModel: model[index], dbname: dbname)));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: (_width / 2) + 10,
                          child: Text(
                            model[index].pdDesc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(color: PRIMARY_COLOR),
                          ),
                        ),
                        Text(
                          model[index].pcd,
                          style: TextStyle(fontSize: 14, color: CHARCOAL),
                        ),
                        Text(
                          'ปรับปรุงเมื่อ :' + model[index].lastActivity,
                          style: TextStyle(fontSize: 14, color: BLACK_GREY),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  model[index].invBalance,
                  style: TextStyle(
                      fontSize: 20,
                      color: SECONDARY_COLOR,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildResponsiveGrid({required List<ProductInvModel> model}) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ResponsiveGridList(
          minSpacing: 2,
          desiredItemWidth: 250,
          children: List.generate(
            model.length,
            (index) {
              var _data = model[index];
              return InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: 4, right: 4),
                  decoration: buildGradientColor(
                      borderR: 12, color1: _black, color2: _black),
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: (_width),
                        child: Text(
                          _data.pdDesc,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: WHITE, fontSize: 14),
                        ),
                      ),
                      Text(
                        _data.pcd,
                        style: TextStyle(color: WHITE),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('คงคลัง (${_data.uom})',
                              style:
                                  TextStyle(color: LIGHT_GREY, fontSize: 14)),
                          Text(
                            _data.invBalance,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ราคาขาย',
                              style:
                                  TextStyle(color: LIGHT_GREY, fontSize: 14)),
                          Text(
                            _data.price,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductManagerPage(
                            invModel: _data,
                            dbname: dbname,
                          )));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  _buildEmptyWidgets() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: _width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SOFT_GREY, BLACK_GREY],
              stops: [0.3, 0.95],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'รายการสินค้า',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'สินค้า',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '0 รายการ',
                      style:
                          TextStyle(fontSize: 18, color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 140.0),
          child: Container(
            height: double.infinity,
            width: _width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0)),
              color: Colors.white,
            ),
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'ข้อมูลสินค้าคงคลัง',
                      style: TextStyle(fontSize: 18, color: SECONDARY_COLOR),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mood_bad_sharp,
                          color: ASSENT_COLOR,
                          size: 60,
                        ),
                        Text(
                          'การเชื่อมต่อฐานข้อมูลล้มเหลว !',
                          style: TextStyle(color: ASSENT_COLOR),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
