part of 'make_sale_bloc.dart';

@immutable
abstract class MakeSaleState {}

class MakeSaleInitial extends MakeSaleState {}

class MakeSaleWaiting extends MakeSaleState {}

class MakeSaleLoadError extends MakeSaleState {
  final String errMsg;

  MakeSaleLoadError({required this.errMsg});
}

class MakeSaleLoadSuccess extends MakeSaleState {
  final List<MakeSale> model;

  MakeSaleLoadSuccess({required this.model});
}

class MakeSaleSaveSuccess extends MakeSaleState {
  MakeSaleSaveSuccess();
}
