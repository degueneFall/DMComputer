class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String imageUrl;
  bool isFavorite;  // Ajoutez ce champ pour gérer l'état de favori

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false, // Initialisez à `false` par défaut
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      description: json['description'] ?? 'Pas de description',
      imageUrl: json['imageUrl'] ?? 'https://example.com/default-image.jpg',
      isFavorite: json['isFavorite'] ?? false, // Vous pouvez aussi gérer si ce champ vient de l'API
    );
  }
}
