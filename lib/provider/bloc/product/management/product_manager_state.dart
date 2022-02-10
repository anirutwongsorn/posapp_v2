part of 'product_manager_bloc.dart';

@immutable
abstract class ProductManagerState {}

class ProductManagerInitial extends ProductManagerState {}

class ProductManagerWaiting extends ProductManagerState {}

class ProductManagerSuccess extends ProductManagerState {}

class ProductManagerError extends ProductManagerState {
  final String errMsg;

  ProductManagerError({required this.errMsg});
}
