import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};
  final Set<int> _favorites = {};

  // Cart Getters
  Map<int, CartItem> get cartItems => {..._cartItems};

  List<CartItem> get cartItemsList => _cartItems.values.toList();

  int get cartCount => _cartItems.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool isInCart(int productId) => _cartItems.containsKey(productId);

  // Favorites Getters
  Set<int> get favorites => {..._favorites};

  int get favoritesCount => _favorites.length;

  bool isFavorite(int productId) => _favorites.contains(productId);

  // Cart Methods
  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity > 1) {
        _cartItems[productId]!.quantity--;
      } else {
        _cartItems.remove(productId);
      }
      notifyListeners();
    }
  }

  void increaseQuantity(int productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity++;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int getQuantity(int productId) {
    return _cartItems[productId]?.quantity ?? 0;
  }

  // Favorites Methods
  void toggleFavorite(int productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  void removeFromFavorites(int productId) {
    _favorites.remove(productId);
    notifyListeners();
  }
}