import 'package:dmc_computer/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteService {
  static const String baseUrl = 'https://ton-api.com/api';

  // Récupérer les produits favoris de l'utilisateur
  Future<List<Product>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Authorization': 'Bearer ${getAuthToken()}'}, // Remplace getAuthToken() par ta méthode pour obtenir le token d'authentification
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  // Ajouter un produit aux favoris
  Future<void> addFavorite(int productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {
        'Authorization': 'Bearer ${getAuthToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add favorite');
    }
  }

  // Retirer un produit des favoris
  Future<void> removeFavorite(int productId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/$productId'),
      headers: {'Authorization': 'Bearer ${getAuthToken()}'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }

  // Fonction pour obtenir le token d'authentification de l'utilisateur
  String getAuthToken() {
    // Tu devras obtenir le token de l'utilisateur de manière sécurisée, par exemple via SharedPreferences ou un autre mécanisme.
    return 'user_auth_token';
  }
}
