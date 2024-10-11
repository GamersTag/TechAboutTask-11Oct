import 'product.dart';

class ProductModel {
  List<Product> products;

  ProductModel({required this.products});

  List<Product> filterByPrice(double maxPrice) {
    return products.where((product) => product.price <= maxPrice).toList();
  }

}
