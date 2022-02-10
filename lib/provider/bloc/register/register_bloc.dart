import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_register.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<DoRegister>((event, emit) async {
      await _doRegister(event, emit);
    });
  }

  Future<void> _doRegister(DoRegister event, Emitter emit) async {
    emit(RegisterWaiting());
    try {
      await NetworkService().postRegister(model: event.model);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(errMsg: e.toString()));
    }
  }
}
