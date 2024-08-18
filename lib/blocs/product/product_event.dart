part of 'product_bloc.dart';

sealed class ProductEvent {}

class ProductEventAddProduct extends ProductEvent {
  ProductEventAddProduct(
      {required this.code, required this.name, required this.quantity});
  final String code;
  final String name;
  final int quantity;
}

class ProductEventEditProduct extends ProductEvent {
  ProductEventEditProduct(
      {required this.productId,
      required this.code,
      required this.name,
      required this.quantity});
  final String productId;
  final String code;
  final String name;
  final int quantity;
}

class ProductEventDeleteProduct extends ProductEvent {
  ProductEventDeleteProduct({required this.productId});
  final String productId;
}

class ProductEventExportToPdfProduct extends ProductEvent {}
