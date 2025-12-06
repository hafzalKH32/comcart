import '../features/products/data/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> items = [];
  void addOne(Product product) {
    final index = items.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      items.add(CartItem(product: product, quantity: 1));
    } else {
      items[index].quantity++;
    }
  }

  void removeOne(int productId) {
    final index = items.indexWhere((e) => e.product.id == productId);
    if (index == -1) return;

    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
  }
  void setQuantity(Product product, int qty) {
    final index = items.indexWhere((e) => e.product.id == product.id);

    if (qty <= 0) {
      if (index != -1) items.removeAt(index);
      return;
    }

    if (index == -1) {
      items.add(CartItem(product: product, quantity: qty));
    } else {
      items[index].quantity = qty;
    }
  }

  int quantityFor(int productId) {
    final index = items.indexWhere((e) => e.product.id == productId);
    if (index == -1) return 0;
    return items[index].quantity;
  }

  void clear() => items.clear();
}

final cartService = CartService();
