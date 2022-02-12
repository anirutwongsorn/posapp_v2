import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:posapp_v2/app_constants/app_color.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/app_constants/app_error_widgets.dart';
import 'package:posapp_v2/app_constants/login_decoration.dart';
import 'package:posapp_v2/app_global/global_error_alert.dart';
import 'package:posapp_v2/provider/bloc/make_sale/make_sale_bloc.dart';
import 'package:posapp_v2/provider/models/model_make_sale.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

class MakeSalePage extends StatefulWidget {
  const MakeSalePage({Key? key}) : super(key: key);

  @override
  _MakeSalePageState createState() => _MakeSalePageState();
}

class _MakeSalePageState extends State<MakeSalePage> {
  late MakeSaleBloc _makeSaleBloc;

  final DateFormat _ddMMyy = new DateFormat('dd/MM/yyyy HH:mm');
  final NumberFormat _numberFormat = new NumberFormat('#,###');

  String dbname = "", branch = "";

  final _formKey = GlobalKey<FormState>();
  final _money = TextEditingController();
  final _date = TextEditingController();

  var _makeSaleModel = MakeSale();

  Future<void> _getDatabaseName() async {
    dbname = await NetworkService().getInitDB();
    branch = await NetworkService().getBranch();
    _reloadData();
    print('dbname :$dbname');
    print('branch :$branch');
  }

  @override
  void initState() {
    super.initState();
    _makeSaleBloc = BlocProvider.of<MakeSaleBloc>(context);
    _getDatabaseName();
  }

  void _reloadData() {
    _makeSaleBloc.add(GetMakeSale(dbname: this.dbname));
  }

  void _saveChange() {
    if (_formKey.currentState!.validate()) {
      _makeSaleModel = MakeSale(
          billDate: _date.value.text.toString(),
          makeSale: double.tryParse(_money.value.text),
          actualSale: 0,
          isActive: false,
          lastActivity: DateTime.now());
      _makeSaleBloc.add(PostMakeSale(model: _makeSaleModel, dbname: dbname));
      print(_makeSaleModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SOFT_BLUE, SECONDARY_COLOR],
              stops: [0.35, 0.95],
            ),
          ),
          child: BlocListener<MakeSaleBloc, MakeSaleState>(
            bloc: _makeSaleBloc,
            listener: (context, state) {
              if (state is MakeSaleSaveSuccess) {
                _reloadData();
              }
            },
            child: BlocBuilder<MakeSaleBloc, MakeSaleState>(
              bloc: _makeSaleBloc,
              builder: (context, state) {
                if (state is MakeSaleLoadSuccess) {
                  return Column(
                    children: [
                      _buildMakeSaleSection(),
                      Expanded(child: _buildListView(model: state.model)),
                    ],
                  );
                }

                if (state is MakeSaleLoadError) {
                  return AppErrorPage(callBack: _reloadData);
                }

                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMakeSaleSection() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 12),
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
                Text(
                  'บันทึกยอดขาย',
                  style: buildAppTextStyle(color: PRIMARY_COLOR, fontSize: 18),
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _date,
                  maxLength: 20,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'วันที่';
                    }
                    return null;
                  },
                  decoration: buildLoginDecorationNoIcon(hintText: 'วันที่'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _money,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'จำนวนเงิย';
                    }
                    return null;
                  },
                  // obscureText: true,
                  decoration: buildLoginDecorationNoIcon(hintText: 'จำนวนเงิน'),
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

  Widget _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _saveChange();
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 22.0, right: 22.0, top: 8, bottom: 8),
            decoration: buildGradientColor(
                borderR: 12,
                color1: SOFT_ORANGE.withOpacity(.7),
                color2: SOFT_ORANGE.withOpacity(.5)),
            child: Text(
              'บันทึก',
              style: TextStyle(fontSize: 16, color: WHITE),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView({required List<MakeSale> model}) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 12),
      decoration: buildBlackDecoration(),
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8, bottom: 100),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.length,
        itemBuilder: (context, index) {
          var _dt = model[index].billDate!;
          if (_dt.length >= 8) {
            var _format = _dt.substring(6) +
                '/' +
                _dt.substring(4, 6) +
                '/' +
                _dt.substring(0, 4);
            _dt = _format;
          }

          return ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dt,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'ลงข้อมูล: ' + _ddMMyy.format(model[index].lastActivity!),
                      style: TextStyle(fontSize: 14, color: SOFT_ORANGE),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Text(
              _numberFormat.format(model[index].makeSale!),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.white60,
          );
        },
      ),
    );
  }
}
