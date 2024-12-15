import 'package:flutter/material.dart';
import '../api_service.dart';
import 'menu.dart';
import '../product.dart';
import 'produitDetails_screen.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({Key? key}) : super(key: key);

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  late Future<List<Product>> _allProducts;
  List<Product> _favoris = []; // Liste locale pour les favoris

  @override
  void initState() {
    super.initState();
    _allProducts = ApiService.fetchProducts();
  }

  /// Ajoute un produit aux favoris
  void _addToFavorites(Product product) {
    setState(() {
      _favoris.add(product);
    });
  }

  /// Retire un produit des favoris
  void _removeFromFavorites(Product product) {
    setState(() {
      _favoris.removeWhere((p) => p.id == product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: Color(0xFF006400),
        centerTitle: true,
        title: Text(
          'Mes Favoris',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Product>>(
        future: _allProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucun produit disponible',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          } else {
            final products = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: calculateChildAspectRatio(2),
              children: products.map((product) {
                final isFavoris = _favoris.contains(product);
                return _buildProductCard(product, isFavoris);
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isFavoris) {
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
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      isFavoris ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xFF006400),
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavoris) {
                          _removeFromFavorites(product);
                        } else {
                          _addToFavorites(product);
                        }
                      });
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
                Text(
                  '${product.price} FCFA',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Calcule l'aspect ratio pour les cartes
  double calculateChildAspectRatio(int crossAxisCount) {
    return (MediaQuery.of(context).size.width / crossAxisCount) /
        (MediaQuery.of(context).size.height / 4);
  }
}
