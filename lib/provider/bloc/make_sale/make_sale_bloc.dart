import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_make_sale.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'make_sale_event.dart';
part 'make_sale_state.dart';

class MakeSaleBloc extends Bloc<MakeSaleEvent, MakeSaleState> {
  MakeSaleBloc() : super(MakeSaleInitial()) {
    on<MakeSaleEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetMakeSale>((event, emit) async {
      await _getMakeSale(event, emit);
    });

    on<PostMakeSale>((event, emit) async {
      await _postMakeSale(event, emit);
    });
  }

  Future<void> _postMakeSale(PostMakeSale event, Emitter emit) async {
    emit(MakeSaleWaiting());
    try {
      await NetworkService()
          .postMakeSale(model: event.model, dbname: event.dbname);
      emit(MakeSaleSaveSuccess());
    } catch (e) {
      emit(MakeSaleLoadError(errMsg: e.toString()));
    }
  }

  Future<void> _getMakeSale(GetMakeSale event, Emitter emit) async {
    emit(MakeSaleWaiting());
    try {
      List<MakeSale> makeSale = [];
      makeSale = await NetworkService().getMakeSale(dbname: event.dbname);
      emit(MakeSaleLoadSuccess(model: makeSale));
    } catch (e) {
      emit(MakeSaleLoadError(errMsg: e.toString()));
    }
  }
}
