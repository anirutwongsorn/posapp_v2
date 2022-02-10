import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_product_Inventory.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'product_manager_event.dart';
part 'product_manager_state.dart';

class ProductManagerBloc
    extends Bloc<ProductManagerEvent, ProductManagerState> {
  ProductManagerBloc() : super(ProductManagerInitial()) {
    on<ProductManagerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<PostManagePrice>((event, emit) async {
      await _postChangedPrice(event, emit);
    });

    on<SetResetManagePriceState>(
        (event, emit) => {emit(ProductManagerInitial())});
  }

  Future<void> _postChangedPrice(PostManagePrice event, Emitter emit) async {
    emit(ProductManagerWaiting());
    Future.delayed(Duration(seconds: 2));
    try {
      bool isOK = await NetworkService()
          .postModifyPrice(model: event.model, dbname: event.dbName)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw "การเชื่อมต่อเครือข่ายล้มเหลว !";
      });
      if (isOK) {
        emit(ProductManagerSuccess());
      } else {
        emit(ProductManagerError(errMsg: "แก้ไขข้อมูลสินค้าล้มเหลว !"));
      }
    } catch (e) {
      emit(ProductManagerError(errMsg: e.toString()));
    }
  }
}
