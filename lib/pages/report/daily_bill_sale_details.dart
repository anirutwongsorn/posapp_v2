import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posapp_v2/app_constants/app_constants.dart';
import 'package:posapp_v2/provider/bloc/report/bill_details/daily_bill_details_bloc.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

class DailyBillDetailsPage extends StatefulWidget {
  final String billCd;

  const DailyBillDetailsPage({Key? key, required this.billCd})
      : super(key: key);

  @override
  _DailyBillDetailsPageState createState() => _DailyBillDetailsPageState();
}

class _DailyBillDetailsPageState extends State<DailyBillDetailsPage> {
  String billCd = '';

  DailyBillDetailsBloc? _billDetailsBloc;

  String dbName = '';

  Color _black = Colors.black.withOpacity(.6);
  Color _black1 = Colors.black.withOpacity(.4);

  @override
  void initState() {
    billCd = widget.billCd;
    _billDetailsBloc = BlocProvider.of<DailyBillDetailsBloc>(context);

    getDatabaseName();

    super.initState();
  }

  Future<void> getDatabaseName() async {
    dbName = await NetworkService().getInitDB();
    if (dbName != "") {
      _billDetailsBloc!
          .add(GetDailyBillDetails(dbName: dbName, billCd: billCd));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดบิลขาย'),
      ),
      body: Container(
        decoration: buildGradientColor(borderR: 0),
        child: SafeArea(
          child: _buildMainUI(),
        ),
      ),
    );
  }

  Padding _buildMainUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<DailyBillDetailsBloc, DailyBillDetailsState>(
        bloc: _billDetailsBloc,
        builder: (context, state) {
          if (state is DailyBillDetailsLoadSuccess) {
            var _data = state.model;

            if (_data.length == 0) {
              return Center(
                child: Text(
                  'ไม่พบข้อมูลที่ค้นหา !',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            return _buildBillDetails(model: _data);
          }
          if (state is DailyBillDetailsLoadError) {
            return Center(
              child: Text(
                state.errMsg,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Column _buildBillDetails({required List<WorkOrderMain> model}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration:
              buildGradientColor(borderR: 12, color1: _black, color2: _black),
          child: ListTile(
            title: _buildTextRow(leading: 'เลขที่', trailing: billCd),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextRow(leading: 'วันที่', trailing: model[0].billDt),
                _buildTextRow(leading: 'พนักงาน', trailing: model[0].employee),
              ],
            ),
            trailing: Text(
              model[0].billTm,
              style: buildAppTextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        _buildBillDetailsItem(model),
        _buildSummarySection(model: model),
      ],
    );
  }

  _buildSummarySection({required List<WorkOrderMain> model}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration:
          buildGradientColor(borderR: 12, color1: _black, color2: _black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'รวมทั้งสิ้น',
            style: buildAppTextStyle(color: Colors.white70),
          ),
          Text(
            model[0].amount,
            style: buildAppTextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ],
      ),
    );
  }

  _buildTextRow({required String leading, required String trailing}) {
    return Row(
      children: [
        Text(
          leading,
          style: buildAppTextStyle(
            color: Colors.white70,
          ),
        ),
        SizedBox(width: 8),
        Text(
          trailing,
          style: buildAppTextStyle(color: Colors.white, fontSize: 16),
        )
      ],
    );
  }

  _buildBillDetailsItem(List<WorkOrderMain> model) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          top: 12,
          bottom: 12,
        ),
        decoration:
            buildGradientColor(color1: _black1, color2: _black1, borderR: 12),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 4),
              child: _buildRowHeader(),
            ),
            Expanded(
              child: ListView.separated(
                padding:
                    EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 80),
                itemCount: model.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildAppText(
                            txt: model[index].pDesc, color: Colors.white),
                      ),
                      Expanded(
                        child: buildAppText(
                            txt: model[index].qty,
                            textAlign: TextAlign.center,
                            color: Colors.white),
                      ),
                      Expanded(
                        child: buildAppText(
                            txt: model[index].price,
                            textAlign: TextAlign.center,
                            color: Colors.white),
                      ),
                      Expanded(
                        child: buildAppText(
                            txt: model[index].itemDiscount,
                            textAlign: TextAlign.center,
                            color: Colors.white),
                      ),
                      Expanded(
                        child: buildAppText(
                            txt: model[index].pdAmount,
                            textAlign: TextAlign.end,
                            color: Colors.white),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white60,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildRowHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildAppText(txt: 'สินค้า', color: Colors.yellow),
        ),
        Expanded(
          child: buildAppText(
              txt: 'จำนวน', textAlign: TextAlign.center, color: Colors.yellow),
        ),
        Expanded(
          child: buildAppText(
              txt: 'ราคา', textAlign: TextAlign.center, color: Colors.yellow),
        ),
        Expanded(
          child: buildAppText(
              txt: 'ส่วนลด', textAlign: TextAlign.center, color: Colors.yellow),
        ),
        Expanded(
          child: buildAppText(
              txt: 'รวม', textAlign: TextAlign.end, color: Colors.yellow),
        ),
      ],
    );
  }
}
