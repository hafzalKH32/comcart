class Product{
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title']??'',
      description: json['description']??'',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      category: json['category'] ??'',
      thumbnail: json['thumbnail']??'',
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList()??[],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'rating': rating,
      'stock': stock,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    double? rating,
    int? stock,
    String? category,
    String? thumbnail,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
    );
  }
}
class ProductListResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }


}