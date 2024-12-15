import 'package:dmc_computer/product.dart';
import 'package:dmc_computer/screen/produitDetails_screen.dart';
import 'package:flutter/material.dart';
import '../api_service.dart'; // Service API
import 'menu.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  late Future<List<Product>> _favorisProducts;

  @override
  void initState() {
    super.initState();
    // Supposons que vous avez une méthode pour obtenir les IDs favoris
    List<int> favoriteProductIds = _getFavoriteProductIds();
    _favorisProducts = ApiService.fetchFavoriteProducts(favoriteProductIds);
  }

  // Simule une liste d'identifiants favoris (à adapter)
  List<int> _getFavoriteProductIds() {
    return [1, 2, 5]; // Exemple : IDs des produits marqués comme favoris
  }

  // Fonction pour retirer un produit des favoris
  void _removeFromFavorites(Product product) {
    setState(() {
      product.isFavorite = false; // Mise à jour locale
    });
    ApiService.removeFromFavorites(product.id); // Appel à l'API pour mettre à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MenuScreen()));
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Mes Favoris',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Product>>(
        future: _favorisProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucun produit favori',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          } else {
            final favoris = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: calculateChildAspectRatio(2),
              children: favoris.map((product) => _buildProductCard(product)).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: 100,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.green,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        product.isFavorite = !product.isFavorite;
                      });
                      if (!product.isFavorite) {
                        _removeFromFavorites(product);
                      } else {
                        ApiService.addToFavorites(product.id);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text('${product.price} FCFA',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calcule l'aspect pour GridView
  double calculateChildAspectRatio(int crossAxisCount) {
    return (MediaQuery.of(context).size.width / crossAxisCount) /
        (MediaQuery.of(context).size.height / 4);
  }
}
