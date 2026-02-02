import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class StorageService {
  // Keys
  static const String _cartKey = 'cart_items';
  static const String _favoritesKey = 'favorites';
  static const String _userKey = 'user_session';
  static const String _onboardingKey = 'onboarding_complete';

  // ==================== CART ====================

  static Future<void> saveCart(Map<int, CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = cartItems.map((key, value) => MapEntry(
        key.toString(),
        {
          'product': value.product.toJson(),
          'quantity': value.quantity,
        },
      ));
      await prefs.setString(_cartKey, json.encode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  static Future<Map<int, CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString == null) return {};

      final Map<String, dynamic> cartData = json.decode(cartString);
      return cartData.map((key, value) => MapEntry(
        int.parse(key),
        CartItem(
          product: Product.fromJson(value['product']),
          quantity: value['quantity'],
        ),
      ));
    } catch (e) {
      debugPrint('Error loading cart: $e');
      return {};
    }
  }

  static Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }

  // ==================== FAVORITES ====================

  static Future<void> saveFavorites(Set<int> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _favoritesKey,
        favorites.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  static Future<Set<int>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
      return favoritesList.map((e) => int.parse(e)).toSet();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return {};
    }
  }

  static Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  // ==================== USER SESSION ====================

  static Future<void> saveUserSession({
    required String email,
    String? name,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'email': email,
        'name': name ?? 'User',
        'loginTime': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_userKey, json.encode(userData));
    } catch (e) {
      debugPrint('Error saving user session: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      if (userString == null) return null;
      return json.decode(userString);
    } catch (e) {
      debugPrint('Error getting user session: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final session = await getUserSession();
      return session != null;
    } catch (e) {
      debugPrint('Error checking login: $e');
      return false;
    }
  }

  static Future<void> clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      debugPrint('Error clearing user session: $e');
    }
  }

  // ==================== ONBOARDING ====================

  static Future<void> setOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      debugPrint('Error setting onboarding: $e');
    }
  }

  static Future<bool> isOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      debugPrint('Error checking onboarding: $e');
      return false;
    }
  }

  // ==================== CLEAR ALL ====================

  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }
}