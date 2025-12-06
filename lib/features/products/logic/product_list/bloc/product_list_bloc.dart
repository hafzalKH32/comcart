import 'package:bloc/bloc.dart';
import 'package:com_cart/features/products/data/product_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository repository; 
  static const  int _pageSize = 20;
  ProductListBloc({required this.repository}) : super(ProductListState()) {
  on<ProductListFetched>(_onProductListFetched);
  on<ProductListRefreshed>(_onProductListRefreshed);

  }


  static const int _limit = 20;

  Future<void> _onProductListFetched(ProductListFetched event, Emitter<ProductListState> emit) async {
    try {
      emit(state.copyWith(status: ProductListStatus.loading));

      final skip = (event.page - 1) * _limit;
      final res = await repository.getProducts(limit: _limit, skip: skip);

      final totalPages = (res.total / _limit).ceil();

      emit(state.copyWith(
        status: ProductListStatus.success,
        products: res.products,
        currentPage: event.page,
        totalPages: totalPages,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }


  Future<void> _onProductListRefreshed(
      ProductListRefreshed event,
      Emitter<ProductListState> emit,
      ) async {
    try {
      // show loading while refreshing
      emit(state.copyWith(status: ProductListStatus.loading));

      // always refresh from page 1
      final response = await repository.getProducts(
        limit: _pageSize,
        skip: 0,
      );

      final totalPages = (response.total / _pageSize).ceil();

      emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: response.products,
          currentPage: 1,
          totalPages: totalPages,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }


}
