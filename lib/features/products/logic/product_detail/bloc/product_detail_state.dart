part of 'product_detail_bloc.dart';
enum ProductDetailStatus { initial, loading, success, failure }

 class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final Product? product;
  final String? errorMessage; 
  final bool isUpdating;
  final bool productUpdated;


  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
    this.isUpdating = false,
    this.productUpdated=false,
  });
  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? errorMessage,
    bool? isUpdating,
    bool?productUpdated,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
      productUpdated: productUpdated?? this.productUpdated,
    );
  }
  
  @override
  List<Object> get props => [status, product ?? '', errorMessage ?? '', isUpdating,productUpdated];
}

