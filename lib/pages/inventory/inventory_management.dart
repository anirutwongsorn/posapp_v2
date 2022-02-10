import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/pages/auth/LoginPage.dart';
import 'package:posapp_v2/provider/bloc/login/login_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/inventory/product_inventory_bloc.dart';
import 'package:posapp_v2/provider/bloc/product/management/product_manager_bloc.dart';
import 'package:posapp_v2/provider/models/model_product_Inventory.dart';

class ProductManagerPage extends StatefulWidget {
  final ProductInvModel invModel;
  final String dbname;

  const ProductManagerPage(
      {Key? key, required this.invModel, required this.dbname})
      : super(key: key);

  @override
  _ProductManagerPageState createState() => _ProductManagerPageState();
}

class _ProductManagerPageState extends State<ProductManagerPage> {
  ProductInvModel? invModel;

  LoginBloc? _loginBloc;

  String dbname = "";

  double _width = 0, _height = 0;

  String price = "0";

  bool _isSave = false;

  ProductManagerBloc? _productManagerBloc;

  ProductInventoryBloc? _inventoryBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _txtPrice = TextEditingController();

  @override
  void initState() {
    invModel = widget.invModel;
    dbname = widget.dbname;

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc!.add(CheckLogin());

    _txtPrice.text = invModel!.price;
    _productManagerBloc = BlocProvider.of<ProductManagerBloc>(context);
    _inventoryBloc = BlocProvider.of<ProductInventoryBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _productManagerBloc!.add(SetResetManagePriceState());
    if (_isSave) {
      _inventoryBloc!.add(GetInventory(dbname: dbname));
      Navigator.of(context).pop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          bloc: _loginBloc,
          listener: (context, state) {
            if (state is LoginLoggedOut) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => route is LoginPage);
            }
          },
          child: Stack(
            children: [
              Container(
                height: _height / 3,
                width: _width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [DARK_GREEN, LIGHT_GREEN],
                    stops: [0.3, 0.95],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'แก้ไขข้อมูลสินค้า',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: _height < 700 ? 70 : (_height / 11),
                ),
                child: Container(
                  //height: _height / 3,
                  width: _width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                    color: Colors.white,
                  ),
                  child: BlocListener<ProductManagerBloc, ProductManagerState>(
                    bloc: _productManagerBloc,
                    listener: (context, state) {
                      if (state is ProductManagerError) {
                        showMyDialog(context, state.errMsg, false);
                      }
                    },
                    child: BlocBuilder<ProductManagerBloc, ProductManagerState>(
                      bloc: _productManagerBloc,
                      builder: (context, state) {
                        if (state is ProductManagerInitial) {
                          _isSave = false;
                          return SingleChildScrollView(
                            child: Container(
                              padding:
                                  EdgeInsets.only(top: 30, left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _buildTxtLbl(lbl: "รหัสสินค้า"),
                                          _buildTxtDesc(lbl: invModel!.pcd),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: _width - 20,
                                        child: Row(
                                          children: [
                                            _buildTxtLbl(lbl: "รายละเอียด"),
                                            Flexible(
                                              child: _buildTxtDesc(
                                                  lbl: invModel!.pdDesc),
                                            )
                                            //_buildTxtDesc(lbl: invModel.pdesc),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          _buildTxtLbl(lbl: "หน่วยนับ"),
                                          _buildTxtDesc(lbl: invModel!.uom),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          _buildTxtLbl(lbl: "คงคลัง"),
                                          _buildTxtDesc(
                                              lbl: invModel!.invBalance),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: _width / 2,
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: _txtPrice,
                                            //initialValue: invModel.price,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 20),
                                            decoration: InputDecoration(
                                              focusColor: BLACK_GREY,
                                              //border: InputBorder.none,
                                              hintText: 'ราคาสินค้า',
                                              //labelText: invModel.price,
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      bottom: 6.0,
                                                      top: 8.0),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "กรุณาระบุราคา";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width: _width / 2.5,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              price = _txtPrice.text;
                                              invModel!.price = price;
                                              print("POST_MANAGE_PRICE : " +
                                                  dbname);
                                              if (dbname.length > 0) {
                                                _productManagerBloc!.add(
                                                  PostManagePrice(
                                                      model: invModel!,
                                                      dbName: dbname),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            'บันทึก',
                                            style:
                                                TextStyle(color: PRIMARY_COLOR),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        _isSave = true;

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/checked.png',
                                height: 120,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'บันทึกสำเร็จ',
                                style:
                                    TextStyle(fontSize: 20, color: DARK_GREEN),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: _width / 2,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'ปิดหน้าต่างนี้',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _buildTxtLbl({required String lbl}) {
    return Text(
      '$lbl : ',
      style: TextStyle(fontSize: 14, color: BLACK_GREY),
    );
  }

  _buildTxtDesc({required String lbl}) {
    return Container(
      child: Text(
        '$lbl',
        style: TextStyle(color: RED_ORANGE),
        overflow: TextOverflow.clip,
      ),
    );
  }

  Future<void> showMyDialog(
      BuildContext context, String msg, bool isClose) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialogLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(title),
          content: SingleChildScrollView(
            child: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
