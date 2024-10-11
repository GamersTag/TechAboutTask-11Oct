import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = "https://dummyjson.com/products";

  Future<List<Product>> fetchProducts(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=30&skip=${(page - 1) * 30}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<Product> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load product details");
    }
  }
}
