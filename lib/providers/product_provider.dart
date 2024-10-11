import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = []; // For filtered products
  bool _isLoading = false;
  int _currentPage = 1;
  final int _productsPerPage = 30;
  final String _baseUrl = 'https://dummyjson.com/products';

  List<Product> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _products;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;

  // Fetch products with pagination
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$_productsPerPage&skip=${(_currentPage - 1) * _productsPerPage}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> fetchedProducts = (data['products'] as List)
            .map((productData) => Product.fromJson(productData))
            .toList();
        _products = fetchedProducts;
        _filteredProducts = [];
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

  // Fetch next page of products
  Future<void> fetchMoreProducts() async {
    if (_isLoading) return;
    _currentPage++;
    await fetchProducts();
  }

  // Fetch previous page of products
  Future<void> fetchPreviousPage() async {
    if (_isLoading || _currentPage <= 1) return;
    _currentPage--;
    await fetchProducts();
  }

  // Filter products by title
  void filterProductsByTitle(String query) {
    if (query.isNotEmpty) {
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredProducts = [];
    }
    notifyListeners();
  }
}
