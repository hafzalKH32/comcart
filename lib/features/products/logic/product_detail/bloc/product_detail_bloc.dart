import 'package:bloc/bloc.dart';
import 'package:com_cart/features/products/data/product_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository ;
  ProductDetailBloc({required this.repository}) : super(ProductDetailState()) {
    on<ProductDetailRequested>(_onProductDetailRequested);
    on<ProductDetailUpdated>(_onProductDetailUpdated);
  }

  Future<void> _onProductDetailRequested(
      ProductDetailRequested event,
      Emitter<ProductDetailState> emit,
      ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product = await repository.getProductById(event.productId);
      emit(
        state.copyWith(
          product: product,
          status: ProductDetailStatus.success,
          errorMessage: null,
        ),
      );
    } catch (e, st) {
      print("❌ PRODUCT FETCH ERROR: $e\n$st");   // Debug
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onProductDetailUpdated(
      ProductDetailUpdated event,
      Emitter<ProductDetailState> emit,
      ) async {
    if (state.product == null) return;

    emit(state.copyWith(isUpdating: true, productUpdated: false));

    try {
      final updatedProduct = await repository.updateProduct(
        id: state.product!.id,
        title: event.title,
        description: event.description,
        price: event.price,
      );

      emit(state.copyWith(
        isUpdating: false,
        product: updatedProduct,
        productUpdated: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
        productUpdated: false,
      ));
    }
  }
}
