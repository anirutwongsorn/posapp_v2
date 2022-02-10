import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_work_order_main.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'daily_bill_details_event.dart';
part 'daily_bill_details_state.dart';

class DailyBillDetailsBloc
    extends Bloc<DailyBillDetailsEvent, DailyBillDetailsState> {
  DailyBillDetailsBloc() : super(DailyBillDetailsInitial()) {
    on<DailyBillDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDailyBillDetails>((event, emit) async {
      await _getDailyBillDetails(event, emit);
    });
  }
  Future<void> _getDailyBillDetails(
      GetDailyBillDetails event, Emitter emit) async {
    emit(DailyBillDetailsWaiting());
    try {
      var model = await NetworkService()
          .getDailyBillDetails(dbname: event.dbName, billCd: event.billCd)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw 'เชื่อมต่อฐานข้อมูลล้มเหลว !';
      });
      emit(DailyBillDetailsLoadSuccess(model: model));
    } catch (e) {
      emit(DailyBillDetailsLoadError(errMsg: e.toString()));
    }
  }
}
