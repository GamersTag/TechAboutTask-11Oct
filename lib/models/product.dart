class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
  });

  // Factory constructor for creating a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  // toJson method to serialize Product to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
    };
  }
}
