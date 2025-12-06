import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cart_service.dart';
import '../../data/product_repository.dart';
import '../../logic/product_detail/bloc/product_detail_bloc.dart';
import '../cart/add_cart_page.dart';
import '../product_edit/product_edit_page.dart';

// 👇 adjust paths to your structure

class ProductDetailPage extends StatefulWidget {
  final ProductRepository repository;
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.repository,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _qty = 0;

  @override
  void initState() {
    super.initState();
    // read quantity from global cart
    _qty = cartService.quantityFor(widget.productId);
  }

  Future<bool> _handleWillPop() async {
    // send quantity back to previous page (list card)
    Navigator.of(context).pop(_qty);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductDetailBloc(repository: widget.repository)
            ..add(ProductDetailRequested(widget.productId)),
      child: WillPopScope(
        onWillPop: _handleWillPop,
        child: BlocConsumer<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            // success message (after update)
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }

            // error message (red)
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (!state.isUpdating && state.productUpdated == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product updated successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

          },
          builder: (context, state) {
            final product = state.product;

            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFB),
              appBar: AppBar(
                backgroundColor: const Color(0xFFF8FAFB),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: _handleWillPop,
                ),
                title: const Text(
                  'Product Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                centerTitle: true,
                actions: [
                  if (product != null)
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        final bloc = context.read<ProductDetailBloc>();

                        final updated = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductEditPage(product: product, bloc: bloc),
                          ),
                        );

                        if (updated == true) {
                          // bloc already updated state.product
                        }
                      },
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              body: SafeArea(
                child: state.status == ProductDetailStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : product == null
                    ? const Center(child: Text('Product not found'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth > 480
                              ? 480.0
                              : constraints.maxWidth;

                          final hasQty = _qty > 0;

                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: Column(
                                children: [
                                  // CONTENT
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // IMAGE CARD
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFE0FFF4),
                                                  Color(0xFFF6F9FF),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Hero(
                                              tag: 'product_${product.id}',
                                              child: AspectRatio(
                                                aspectRatio: 4 / 3,
                                                child: Image.network(
                                                  product.thumbnail,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          // CATEGORY + RATING + STOCK
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFDCFCE7,
                                                  ).withOpacity(0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999,
                                                      ),
                                                ),
                                                child: Text(
                                                  product.category,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF166534),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 18,
                                                    color: Color(0xFFFFB800),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    product.rating
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Stock: ${product.stock}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // TITLE
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          // PRICE
                                          Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF2CB67D),
                                            ),
                                          ),
                                          const SizedBox(height: 18),

                                          const Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          Text(
                                            product.description,
                                            style: TextStyle(
                                              fontSize: 13,
                                              height: 1.4,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          // EXTRA INFO CARD
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.04),
                                                  blurRadius: 14,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Category',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      product.category,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'ID',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '#${product.id}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 80),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // BOTTOM BAR
                                  _BottomBar(
                                    price: product.price,
                                    qty: _qty,
                                    onInc: () {
                                      setState(() => _qty++);
                                      cartService.setQuantity(product, _qty);
                                    },
                                    onDec: () {
                                      setState(() {
                                        if (_qty <= 1) {
                                          _qty = 0;
                                        } else {
                                          _qty--;
                                        }
                                      });
                                      cartService.setQuantity(product, _qty);
                                    },
                                    onAddOrGoToCart: () {
                                      final hasQty = _qty > 0;
                                      if (!hasQty) {
                                        setState(() => _qty = 1);
                                        cartService.setQuantity(product, _qty);
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const CartPage(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double price;
  final int qty;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onAddOrGoToCart;

  const _BottomBar({
    required this.price,
    required this.qty,
    required this.onInc,
    required this.onDec,
    required this.onAddOrGoToCart,
  });

  @override
  Widget build(BuildContext context) {
    final hasQty = qty > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2CB67D),
                  ),
                ),
              ],
            ),
            const Spacer(),

            if (hasQty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    _QtyCircleButton(
                      icon: Icons.remove,
                      enabled: true,
                      onTap: onDec,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '$qty',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _QtyCircleButton(
                      icon: Icons.add,
                      enabled: true,
                      onTap: onInc,
                    ),
                  ],
                ),
              ),

            if (hasQty) const SizedBox(width: 10),

            SizedBox(
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CB67D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: onAddOrGoToCart,
                child: Text(
                  hasQty ? 'GO TO CART' : 'ADD TO CART',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyCircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QtyCircleButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFE5E7EB),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? const Color(0xFF111827) : Colors.grey,
        ),
      ),
    );
  }
}
