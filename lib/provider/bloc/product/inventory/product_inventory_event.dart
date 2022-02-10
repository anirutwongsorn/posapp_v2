part of 'product_inventory_bloc.dart';

@immutable
abstract class ProductInventoryEvent {}

class GetInventory extends ProductInventoryEvent {
  final String dbname;

  GetInventory({required this.dbname});
}

class GetInventoryV2 extends ProductInventoryEvent {
  final String dbname;
  final String filterWord;

  GetInventoryV2({required this.dbname, required this.filterWord});
}

class GetInventoryFilter extends ProductInventoryEvent {
  final String keyword;
  final List<ProductInvModel> model;

  GetInventoryFilter({required this.keyword, required this.model});
}

class SetInventoryReset extends ProductInventoryEvent {}

class ResetInventory extends ProductInventoryEvent {}
