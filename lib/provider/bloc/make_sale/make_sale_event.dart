part of 'make_sale_bloc.dart';

@immutable
abstract class MakeSaleEvent {}

class GetMakeSale extends MakeSaleEvent {
  final String dbname;

  GetMakeSale({required this.dbname});
}

class PostMakeSale extends MakeSaleEvent {
  final MakeSale model;
  final String dbname;

  PostMakeSale({required this.model, required this.dbname});
}
