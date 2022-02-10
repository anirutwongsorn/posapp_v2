import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/app_global/global_variable.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'daily_bill_main_event.dart';
part 'daily_bill_main_state.dart';

class DailyBillMainBloc extends Bloc<DailyBillMainEvent, DailyBillMainState> {
  DailyBillMainBloc() : super(DailyBillMainInitial()) {
    on<DailyBillMainEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDailyBillMain>((event, emit) async {
      await _getDailyBillMain(event, emit);
    });
  }

  Future<void> _getDailyBillMain(GetDailyBillMain event, Emitter emit) async {
    emit(DailyBillMainWaiting());
    try {
      //List<WorkOrderMain> model = [];
      var model = await NetworkService()
          .getDailyBill(dbname: event.dbName)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw GlobalVariable.errorConnectionMsg;
      });
      emit(DailyBillMainLoadSuccess(model: model));
    } catch (e) {
      emit(DailyBillMainLoadError(errMsg: e.toString()));
    }
  }
}
