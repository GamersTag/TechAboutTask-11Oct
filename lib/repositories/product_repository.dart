import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
  final String apiUrl;

  ProductRepository({required this.apiUrl});

  Future<List<Product>> fetchProducts({required int limit, required int skip}) async {
    final response = await http.get(Uri.parse('$apiUrl?limit=$limit&skip=$skip'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
