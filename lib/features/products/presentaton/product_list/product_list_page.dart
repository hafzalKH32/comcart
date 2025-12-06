import 'package:com_cart/features/products/data/product_repository.dart';
import 'package:com_cart/features/products/logic/product_list/bloc/product_list_bloc.dart';
import 'package:com_cart/features/products/presentaton/product_list/widgets/custom_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_grid_sliver.dart';

class ProductListPage extends StatelessWidget {
  final ProductRepository repository;
  const ProductListPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8FAFB),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ProductListBloc>()
                  .add(const ProductListRefreshed());
            },
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _buildHeader(),
                    _buildSearchAndChipRow(context),

                    // ───── MAIN CONTENT SLIVER (grid or states) ─────
                    if (state.status == ProductListStatus.loading ||
                        state.status == ProductListStatus.initial)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.status == ProductListStatus.failure)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            state.errorMessage ?? 'Failed to load products',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else if (state.products.isEmpty)
                        const SliverFillRemaining(
                          child: Center(
                            child: Text('No products available'),
                          ),
                        )
                      else
                        SliverPadding(
                          padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          // 👇 THIS IS NOW A PROPER SLIVER GRID
                          sliver: CustomGridSliver(
                            products: state.products,
                            repository: repository,
                          ),
                        ),

                    // ───── PAGINATION BAR AS SEPARATE SLIVER ─────
                    if (state.products.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          child: _PaginationBar(state: state),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildHeader() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      expandedHeight: 140,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2CB67D), Color(0xFF0EA5E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 12),
              title: Text(
                'Ecom Cart',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 6),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSearchAndChipRow(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for items',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: Color(0xFF2CB67D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryChip(label: 'All', selected: true),
                  _CategoryChip(label: 'Tech'),
                  _CategoryChip(label: 'Beauty'),
                  _CategoryChip(label: 'Fashion'),
                  _CategoryChip(label: 'Home'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, // 👈 ensure center alignment
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: selected ? const Color(0xFF2CB67D) : Colors.white,
        boxShadow: selected
            ? [
          BoxShadow(
            color: const Color(0xFF2CB67D).withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(          // 👈 wrap for perfect centering
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final ProductListState state;
  const _PaginationBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalPages = state.totalPages;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: state.currentPage > 1
                    ? () {
                  context.read<ProductListBloc>().add(
                    ProductListFetched(state.currentPage - 1),
                  );
                }
                    : null,
                icon: const Icon(Icons.chevron_left, size: 20),
              ),
              const SizedBox(width: 4),
              ...List.generate(totalPages, (index) {
                final pageNumber = index + 1;
                final isSelected = pageNumber == state.currentPage;
                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      context
                          .read<ProductListBloc>()
                          .add(ProductListFetched(pageNumber));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: isSelected
                          ? const Color(0xFF2CB67D)
                          : Colors.grey.shade200,
                    ),
                    child: Text(
                      '$pageNumber',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 4),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: state.currentPage < state.totalPages
                    ? () {
                  context.read<ProductListBloc>().add(
                    ProductListFetched(state.currentPage + 1),
                  );
                }
                    : null,
                icon: const Icon(Icons.chevron_right, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
