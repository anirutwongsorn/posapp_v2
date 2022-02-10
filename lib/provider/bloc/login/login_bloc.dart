import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_login.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // on<LoginEvent>((event, emit) {
    //
    // });

    //DoLogin
    on<DoLogin>((event, emit) async {
      await doLogin(event, emit);
    });

    //CheckLogin
    on<CheckLogin>((event, emit) async {
      await checkLogin(event, emit);
    });
  }

  Future<void> doLogin(DoLogin event, Emitter emit) async {
    emit(LoginWaiting());
    bool isLogin = false;
    try {
      isLogin = await NetworkService().postLogin(model: event.model);
      if (isLogin) {
        emit(LoginLoggedIn());
      } else {
        emit(LoginLoggedOut());
      }
    } catch (e) {
      emit(LoginError(errMsg: e.toString()));
    }
  }

  Future<void> checkLogin(CheckLogin event, Emitter emit) async {
    emit(LoginWaiting());
    Future.delayed(Duration(seconds: 1));
    bool isLogin = false;
    try {
      isLogin = await NetworkService().checkTokenExpired();
      if (isLogin) {
        emit(LoginLoggedIn());
      } else {
        emit(LoginLoggedOut());
      }
    } catch (e) {
      emit(LoginError(errMsg: e.toString()));
    }
  }
}
