part of 'product_inventory_bloc.dart';

@immutable
abstract class ProductInventoryState {}

class ProductInventoryInitial extends ProductInventoryState {}

class ProductInventoryWaiting extends ProductInventoryState {}

class ProductInventoryLoadError extends ProductInventoryState {
  final String errMsg;

  ProductInventoryLoadError({required this.errMsg});
}

class ProductInventoryLoadSuccess extends ProductInventoryState {
  final List<ProductInvModel> model;

  ProductInventoryLoadSuccess({required this.model});
}

class ProductInventoryFiltering extends ProductInventoryState {
  final List<ProductInvModel> model;

  ProductInventoryFiltering({required this.model});
}
