import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum ProductState { initial, loading, loaded, error }

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _userAddedProducts = []; // Products added by user
  ProductState _state = ProductState.initial;
  String _errorMessage = '';
  String _searchQuery = '';

  // Getters
  List<Product> get products {
    // Combine user added products (first) with API products
    final allProducts = [..._userAddedProducts, ..._products];

    if (_searchQuery.isEmpty) return allProducts;
    return allProducts
        .where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  ProductState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ProductState.loading;
  bool get hasError => _state == ProductState.error;
  bool get isEmpty => _state == ProductState.loaded && _products.isEmpty && _userAddedProducts.isEmpty;

  // Fetch all products from API
  Future<void> fetchProducts() async {
    _state = ProductState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
      _state = ProductState.loaded;
    } on ApiException catch (e) {
      _state = ProductState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = ProductState.error;
      _errorMessage = 'An unexpected error occurred';
    }
    notifyListeners();
  }

  // Add new product (appears at the top)
  void addProduct({
    required String title,
    required double price,
    required String description,
    required String category,
    String? imageUrl,
  }) {
    // Generate a unique ID (negative to avoid conflict with API IDs)
    final newId = -(_userAddedProducts.length + 1);

    final newProduct = Product(
      id: newId,
      title: title,
      price: price,
      description: description,
      category: category,
      image: imageUrl ?? '', // Empty string if no image
      rating: Rating(rate: 0.0, count: 0),
    );

    // Add to the beginning of user products list
    _userAddedProducts.insert(0, newProduct);
    notifyListeners();
  }

  // Remove product
  void removeProduct(int productId) {
    _userAddedProducts.removeWhere((p) => p.id == productId);
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Get product by ID
  Product? getProductById(int id) {
    try {
      // Check user added products first
      return _userAddedProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      try {
        return _products.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  // Get total product count
  int get totalProducts => _userAddedProducts.length + _products.length;

  // Get user added products count
  int get userProductsCount => _userAddedProducts.length;
}