import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _productsPerPage = 30;
  final String _baseUrl = 'https://dummyjson.com/products';

  List<Product> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _products;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;

  // Fetch products with caching
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
    }
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=$_productsPerPage&skip=${(_currentPage - 1) * _productsPerPage}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Product> fetchedProducts = (data['products'] as List)
            .map((productData) => Product.fromJson(productData))
            .toList();

        // Update the product list
        _products = fetchedProducts;
        _filteredProducts = [];

        // Save products in cache
        await _saveProductsToCache(_products);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print(error);

      // If fetching fails, try loading products from cache
      await _loadProductsFromCache();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save fetched products to shared preferences
  Future<void> _saveProductsToCache(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String productsJson = json.encode(products.map((e) => e.toJson()).toList());
    await prefs.setString('cached_products', productsJson);
  }

  // Load cached products from shared preferences
  Future<void> _loadProductsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedProductsJson = prefs.getString('cached_products');

    if (cachedProductsJson != null) {
      List<Product> cachedProducts = (json.decode(cachedProductsJson) as List)
          .map((productData) => Product.fromJson(productData))
          .toList();
      _products = cachedProducts;
      _filteredProducts = [];
      print('Loaded products from cache');
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
