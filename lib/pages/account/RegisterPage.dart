import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_constants/login_decoration.dart';
import 'package:posapp_v2/app_global/global_error_alert.dart';
import 'package:posapp_v2/pages/account/RegisterCompletedPage.dart';
import 'package:posapp_v2/provider/bloc/register/register_bloc.dart';
import 'package:posapp_v2/provider/models/model_register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _formKey = GlobalKey<FormState>();
  var _username = TextEditingController();
  var _pass = TextEditingController();
  var _shop = TextEditingController();
  var _address = TextEditingController();
  var _dbname = TextEditingController();

  RegisterBloc? _registerBloc;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    super.initState();
  }

  void _doRegister() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('_username : ${_username.text}');
      print('_pass : ${_pass.text}');
      print('_shop : ${_shop.text}');
      print('_address : ${_address.text}');
      print('_dbname : ${_dbname.text}');

      var model = RegisterModel(
        username: _username.text,
        password: _pass.text,
        address: _address.text,
        shop: _shop.text,
        dbname: _dbname.text,
      );

      _registerBloc!.add(DoRegister(model: model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      backgroundColor: SOFT_BLUE,
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listener: (context, state) {
          if (state is RegisterError) {
            showDialog(
              context: context,
              builder: (context) => ErrorAlertDialog(
                title: 'แจ้งเตือน',
                content: state.errMsg,
              ),
            );
          }

          if (state is RegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterCompletedPage(
                  shopName: _shop.text,
                ),
              ),
            );
          }
        },
        child: _buildRegisterBloc(),
      ),
    );
  }

  _buildRegisterBloc() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      builder: (context, state) {
        if (state is RegisterWaiting) {
          return Center(child: buildLogoLoading());
        }

        return _buildRegisterSection();
      },
    );
  }

  _buildRegisterSection() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.all(15.0),
          //height: _height / 1.8,
          width: double.infinity,
          decoration: buildGradientColor(
            borderR: 12,
            color1: WHITE,
            color2: WHITE,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildAppLogo(height: 30),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'สมัครสมาชิก',
                        style: buildAppTextStyle(
                            color: PRIMARY_COLOR, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _username,
                  maxLength: 20,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'ชื่อเข้าใช้งาน';
                    }
                    return null;
                  },
                  decoration:
                      buildLoginDecorationNoIcon(hintText: 'ชื่อเข้าใช้งาน'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _pass,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'รหัสผ่าน';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: buildLoginDecorationNoIcon(hintText: 'รหัสผ่าน'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _shop,
                  maxLines: 2,
                  maxLength: 150,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'ชื่อร้านค้า';
                    }
                    return null;
                  },
                  decoration:
                      buildLoginDecorationNoIcon(hintText: 'ชื่อร้านค้า'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  maxLength: 200,
                  controller: _address,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'ที่อยู่';
                    }
                    return null;
                  },
                  decoration: buildLoginDecorationNoIcon(hintText: 'ที่อยู่'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _dbname,
                  maxLength: 50,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'รหัสข้อมูล';
                    }
                    return null;
                  },
                  decoration:
                      buildLoginDecorationNoIcon(hintText: 'รหัสข้อมูล'),
                ),
                SizedBox(height: 20),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _doRegister();
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 22.0, right: 22.0, top: 8, bottom: 8),
            decoration: buildGradientColor(
                borderR: 12,
                color1: SOFT_ORANGE.withOpacity(.7),
                color2: SOFT_ORANGE.withOpacity(.5)),
            child: Text(
              'ลงทะเบียน',
              style: TextStyle(fontSize: 16, color: WHITE),
            ),
          ),
        ),
      ],
    );
  }
}
