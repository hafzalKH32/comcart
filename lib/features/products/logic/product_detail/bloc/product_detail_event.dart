part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailRequested extends ProductDetailEvent {
  final int productId;

  const ProductDetailRequested(this.productId);

  @override
  List<Object> get props => [productId];
}

class ProductDetailUpdated extends ProductDetailEvent {
  final String title;
  final String description;
  final double price;

  const ProductDetailUpdated({
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  List<Object> get props => [title, description, price];
}
