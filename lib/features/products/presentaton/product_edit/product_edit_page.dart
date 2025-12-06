import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../logic/product_detail/bloc/product_detail_bloc.dart';

class ProductEditPage extends StatefulWidget {
  final Product product;
  final ProductDetailBloc bloc;

  const ProductEditPage({
    super.key,
    required this.product,
    required this.bloc,
  });

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    widget.bloc.add(
      ProductDetailUpdated(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ??
            widget.product.price,
      ),
    );

    // Small delay then close with "true"
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      // nice soft background like other screens
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3F4F6),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        title: const Text(
          'Edit Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // top subtle gradient bar
            Container(
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2CB67D), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
            ),
            // content on top of gradient
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      // floating product card header
                      _ProductHeaderCard(product: product),
                      const SizedBox(height: 16),

                      Card(color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.07),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Edit details',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Update title, price and description of this product.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                _buildTextField(
                                  label: 'Title',
                                  controller: _titleController,
                                  validator: (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Title is required'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildTextField(
                                  label: 'Price',
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  validator: (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Price is required'
                                      : null,
                                ),
                                const SizedBox(height: 14),

                                _buildTextField(
                                  label: 'Description',
                                  controller: _descriptionController,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFE5E7EB),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18),
                                          ),
                                        ),
                                        onPressed: _saving
                                            ? null
                                            : () => Navigator.of(context)
                                            .pop(false),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF2CB67D),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: _saving ? null : _onSave,
                                        child: _saving
                                            ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child:
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                            AlwaysStoppedAnimation<
                                                Color>(
                                                Colors.white),
                                          ),
                                        )
                                            : const Text(
                                          'Save Changes',
                                          style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            fillColor: const Color(0xFFF9FAFB),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF2CB67D),
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductHeaderCard extends StatelessWidget {
  final Product product;
  const _ProductHeaderCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFFEEFDF5), Color(0xFFE0F2FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2CB67D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFFFB800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
