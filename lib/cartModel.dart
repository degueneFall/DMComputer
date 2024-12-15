import 'package:flutter/material.dart';

// Classe CartItem pour stocker les informations d'un produit dans le panier
class CartItem {
  final String productName;
  final double price;
  final int quantity;

  CartItem({
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

// Modèle CartModel pour gérer les éléments du panier
class CartModel with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Méthode pour ajouter un article au panier
  void add(CartItem item) {
    _items.add(item); // Ajoute l'article à la liste _items
    notifyListeners(); // Notifie les abonnés pour mettre à jour l'interface
  }

  // Méthode pour supprimer un item
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();  // Pour mettre à jour l'UI après la suppression
  }

  // Calcul du prix total
  double get total {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
