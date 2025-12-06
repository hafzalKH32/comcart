part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, failure }

class ProductListState extends Equatable {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final ProductListStatus status;
  final String? errorMessage;

  const ProductListState({
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.currentPage = 1,
    this.totalPages = 1,
    this.status = ProductListStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    searchQuery,
    currentPage,
    totalPages,
    status,
    errorMessage,
  ];

  ProductListState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    ProductListStatus? status,
    String? errorMessage,
  }) {
    return ProductListState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
