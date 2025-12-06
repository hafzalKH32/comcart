part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListFetched extends ProductListEvent {
  final int page;
  const ProductListFetched(this.page);
}


final class ProductListRefreshed extends ProductListEvent {
  const ProductListRefreshed();
}
