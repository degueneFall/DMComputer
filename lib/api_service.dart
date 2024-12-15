import 'dart:convert';
import 'package:http/http.dart' as http;
import 'category.dart';
import 'product.dart';

class ApiService {
  static const String baseUrl = 'https://dmcomputer.sn/wp-json/wc/v3/';
  static const String consumerKey = 'ck_ce2175287f13be3edb8c8bb884e2e9051cfe08ad';
  static const String consumerSecret = 'cs_c95c5bb6027fd918466dd18823a78a227a2d0b35';

  // Fetch Categories
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${baseUrl}products/categories'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch Products
  static Future<List<Product>> fetchProducts({int? categoryId}) async {
    String url = '${baseUrl}products';
    if (categoryId != null) {
      url += '?category=$categoryId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
// Fetch Sliders (e.g., using product images or custom attribute)
  static Future<List<String>> fetchSliders() async {
    final response = await http.get(
      Uri.parse('${baseUrl}products'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Extract product images for the slider
      return data.map((product) => product['images'][0]['src'] as String).toList();
    } else {
      throw Exception('Failed to load sliders');
    }
  }
// Fetch Product Details
  static Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    final url = '${baseUrl}products/$productId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Retourne les détails du produit
    } else {
      throw Exception('Échec de la récupération des détails du produit');
    }
  }
  // Méthode pour récupérer les produits favoris

  static Future<List<Product>> fetchFavoriteProducts() async {
    final url = '${baseUrl}products?is_favorite=true'; // Utiliser un paramètre "is_favorite"
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Échec de la récupération des produits favoris');
    }
  }


  // Méthode pour ajouter un produit aux favoris
  static Future<void> addToFavorites(int productId) async {
    final url = '${baseUrl}products/$productId';  // Endpoint pour un produit
    final response = await http.post(Uri.parse(url), body: {
      'is_favorite': 'true',  // Paramètre pour marquer comme favori
    });

    if (response.statusCode != 200) {
      throw Exception('Échec de l\'ajout aux favoris');
    }
  }

  // Méthode pour retirer un produit des favoris
  static Future<void> removeFromFavorites(int productId) async {
    final url = '${baseUrl}products/$productId';  // Endpoint pour un produit
    final response = await http.post(Uri.parse(url), body: {
      'is_favorite': 'false',  // Paramètre pour retirer du favoris
    });

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression des favoris');
    }
  }
// Fetch Products with search functionality
  static Future<List<Product>> fetchProductsWithSearch({int? categoryId, String? search}) async {
    String url = '${baseUrl}products';

    // Ajouter les paramètres à l'URL en fonction des valeurs de categoryId et search
    List<String> params = [];
    if (categoryId != null) {
      params.add('category=$categoryId');
    }
    if (search != null && search.isNotEmpty) {
      params.add('search=$search');
    }

    if (params.isNotEmpty) {
      url += '?' + params.join('&');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret')),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}

