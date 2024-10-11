import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  int _currentPage = 1; // Track current page
  final int _productsPerPage = 30; // Products per page
  final String _baseUrl = 'https://dummyjson.com/products'; // the api

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage; // Getter for currentPage

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?limit=$_productsPerPage&skip=${(_currentPage - 1) * _productsPerPage}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> fetchedProducts = (data['products'] as List)
            .map((productData) => Product.fromJson(productData))
            .toList();
        _products = fetchedProducts;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreProducts() async {
    if (_isLoading) return; // Prevent fetching if already loading
    _currentPage++;
    await fetchProducts();
  }

  Future<void> fetchPreviousPage() async {
    if (_isLoading || _currentPage <= 1) return; // Prevent fetching if already loading or on the first page
    _currentPage--;
    await fetchProducts();
  }
}
