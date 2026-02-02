import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode >= 500) {
        throw ApiException(AppConstants.serverError);
      } else {
        throw ApiException(AppConstants.unknownError);
      }
    } on SocketException {
      throw ApiException(AppConstants.networkError);
    } on http.ClientException {
      throw ApiException(AppConstants.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(AppConstants.unknownError);
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw ApiException(AppConstants.unknownError);
      }
    } on SocketException {
      throw ApiException(AppConstants.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(AppConstants.unknownError);
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}