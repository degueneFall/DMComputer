import 'package:dmc_computer/api_service.dart';
import 'package:dmc_computer/cartModel.dart';
import 'package:dmc_computer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  double getTotalPrice(double price) {
    return price * _quantity;
  }

  String removeHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Produit'),
        backgroundColor: Color(0xFF006400),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Appeler la méthode pour basculer le thème
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchProductDetails(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Produit introuvable'));
          } else {
            final product = snapshot.data!;
            final String name = product['name'];
            final String category = product['categories'][0]['name'] ?? 'Non spécifié';
            final String description = removeHtmlTags(product['description'] ?? 'Pas de description disponible');
            final String imageUrl = product['images'][0]['src'];
            final double price = double.parse(product['price'].toString());
            final String currency = product['currency'] ?? 'FCFA';
            final double totalPrice = getTotalPrice(price);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      imageUrl,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$category',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description ',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$description',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Quantité :',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) {
                                _quantity--;
                              }
                            });
                          },
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Prix total : ${getTotalPrice(price).toStringAsFixed(2)} $currency',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Utilisation de la méthode add() sur CartModel via Provider
                        Provider.of<CartModel>(context, listen: false).add(
                          CartItem(
                            productName: name,
                            price: price,
                            quantity: _quantity,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$name a été ajouté au panier')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF006400)),
                      child: const Text('Ajouter au panier'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
