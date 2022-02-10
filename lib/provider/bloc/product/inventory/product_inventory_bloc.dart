import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_product_Inventory.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'product_inventory_event.dart';
part 'product_inventory_state.dart';

class ProductInventoryBloc
    extends Bloc<ProductInventoryEvent, ProductInventoryState> {
  List<ProductInvModel> productModel = [];

  ProductInventoryBloc() : super(ProductInventoryInitial()) {
    on<GetInventory>((event, emit) async {
      await _getInventory(event, emit);
    });

    on<GetInventoryV2>((event, emit) async {
      await _getInventoryV2(event, emit);
    });

    on<GetInventoryFilter>((event, emit) => _getInventoryFilter(event, emit));

    on<SetInventoryReset>((event, emit) => _setInventoryReset(event, emit));

    // on<ProductInventoryEvent>((event, emit) {
    //   // TODO: implement event handler
    //
    //   if (event is GetInventoryV2) {
    //     _getInventoryV2(event, emit);
    //   } else if (event is GetInventory) {
    //     _getInventory(event, emit);
    //   } else if (event is GetInventoryFilter) {
    //     var _model = event.model;
    //     var _keyword = event.keyword;
    //     if (_keyword.isEmpty) {
    //       emit(ProductInventoryLoadSuccess(model: productModel));
    //     } else {
    //       var _filterModel =
    //           _model.where((p) => p.pdDesc.contains(_keyword)).toList();
    //       emit(ProductInventoryFiltering(model: _filterModel));
    //     }
    //   } else if (event is SetInventoryReset) {
    //     emit(ProductInventoryWaiting());
    //     Future.delayed(Duration(seconds: 2));
    //     emit(ProductInventoryLoadSuccess(model: productModel));
    //   }
    // });
  }

  void _setInventoryReset(SetInventoryReset event, Emitter emit) {
    emit(ProductInventoryWaiting());
    Future.delayed(Duration(seconds: 2));
    emit(ProductInventoryLoadSuccess(model: productModel));
  }

  void _getInventoryFilter(GetInventoryFilter event, Emitter emit) {
    var _model = event.model;
    var _keyword = event.keyword;
    if (_keyword.isEmpty) {
      emit(ProductInventoryLoadSuccess(model: productModel));
    } else {
      var _filterModel =
          _model.where((p) => p.pdDesc.contains(_keyword)).toList();
      emit(ProductInventoryFiltering(model: _filterModel));
    }
  }

  Future<void> _getInventoryV2(GetInventoryV2 event, Emitter emit) async {
    emit(ProductInventoryWaiting());
    Future.delayed(Duration(seconds: 2));
    List<ProductInvModel> model = [];
    try {
      model = await NetworkService()
          .getInventoryV2(dbname: event.dbname, filterWord: event.filterWord)
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw "การเชื่อมต่อเครือข่ายล้มเหลว !";
      });
      productModel.addAll(model);
      emit(ProductInventoryLoadSuccess(model: model));
    } catch (e) {
      emit(ProductInventoryLoadError(errMsg: e.toString()));
    }
  }

  Future<void> _getInventory(GetInventory event, Emitter emit) async {
    emit(ProductInventoryWaiting());
    Future.delayed(Duration(seconds: 2));
    List<ProductInvModel> model = [];
    productModel = [];
    try {
      model = await NetworkService()
          .getInventory(dbname: event.dbname)
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw "การเชื่อมต่อเครือข่ายล้มเหลว !";
      });
      productModel.addAll(model);
      emit(ProductInventoryLoadSuccess(model: model));
    } catch (e) {
      emit(ProductInventoryLoadError(errMsg: e.toString()));
    }
  }
}
