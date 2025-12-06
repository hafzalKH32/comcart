import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../data/models/product_model.dart';
import '../../../data/product_repository.dart';
import '../../product_details/product_details_page.dart';
import '../../widgets/product_card.dart';


class CustomGridView extends StatefulWidget {
  final List<Product> products;
  final ProductRepository repository;

  const CustomGridView({
    super.key,
    required this.products,
    required this.repository,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900
        ? 4
        : width > 700
        ? 3
        : 2;

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(repository: widget.repository,
          product: product,
        );

      },
    );
  }
}
