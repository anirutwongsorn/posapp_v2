import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_daily_sale_rpt.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'daily_sale_rpt_event.dart';
part 'daily_sale_rpt_state.dart';

class DailySaleRptBloc extends Bloc<DailySaleRptEvent, DailySaleRptState> {
  DailySaleRptBloc() : super(DailySaleRptInitial()) {
    on<DailySaleRptEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDailySaleReport>((event, emit) async {
      await _getDailySaleReport(event, emit);
    });
  }

  Future<void> _getDailySaleReport(
      GetDailySaleReport event, Emitter emit) async {
    emit(DailySaleRptWaiting());
    Future.delayed(Duration(seconds: 2));
    try {
      var model = await NetworkService()
          .getDailySalesReport(dbname: event.dbName)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw "การเชื่อมต่อเครือข่ายล้มเหลว !";
      });
      emit(DailySaleRptLoadSuccess(model: model));
    } catch (e) {
      emit(DailySaleRptLoadError(errMsg: e.toString()));
    }
  }
}
