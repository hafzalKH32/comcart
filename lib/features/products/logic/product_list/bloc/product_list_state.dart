part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, failure }

final class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> products;
  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    currentPage,
    totalPages,
    errorMessage,
  ];
}
