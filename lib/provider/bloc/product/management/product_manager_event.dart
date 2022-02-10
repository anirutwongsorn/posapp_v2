part of 'product_manager_bloc.dart';

@immutable
abstract class ProductManagerEvent {}

class PostManagePrice extends ProductManagerEvent {
  final ProductInvModel model;
  final String dbName;

  PostManagePrice({required this.model, required this.dbName});
}

class SetResetManagePriceState extends ProductManagerEvent {}
