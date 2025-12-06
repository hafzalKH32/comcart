import 'package:com_cart/features/products/presentaton/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/cart_service.dart';
import '../../data/models/product_model.dart';
import '../../data/product_repository.dart';


class CustomGridSliver extends StatelessWidget {
  final List<Product> products;
  final ProductRepository repository;

  const CustomGridSliver({
    super.key,
    required this.products,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900
        ? 4
        : width > 600
        ? 3
        : 2;
    final childAspectRatio = width > 600 ? 0.78 : 0.72;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final product = products[index];
          final qty = cartService.quantityFor(product.id);

          return ProductCard(
            product: product,
            repository: repository,
          );
        },
        childCount: products.length,
      ),
    );
  }
}
