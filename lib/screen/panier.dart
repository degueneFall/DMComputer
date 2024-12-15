import 'package:dmc_computer/cartModel.dart';
import 'package:dmc_computer/main.dart';
import 'package:dmc_computer/screen/menu.dart';
import 'package:dmc_computer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Panier extends StatelessWidget {
  const Panier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context); // Accédez à CartModel via Provider
    final themeModel = Provider.of<ThemeModel>(context); // Accédez à ThemeModel via Provider

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Color(0xFF006400),
        centerTitle: true,
        title: const Text(
          'Mon Panier',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeModel.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: () {
              themeModel.toggleTheme(); // Change le thème
            },
          ),
        ],
      ),
      body: cart.items.isEmpty
          ? SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: const [
                SizedBox(height: 130),
                Icon(
                  Icons.shopping_cart_rounded,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'Votre panier est vide',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(item.productName),
                    subtitle: Text(
                        'Prix: ${item.price.toStringAsFixed(2)} FCFA\nTotal: ${(item.price * item.quantity).toStringAsFixed(2)} FCFA'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => cart.removeItem(index),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${cart.total.toStringAsFixed(2)} FCFA',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Commande validée !')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                  ),
                  child: const Text(
                    'Valider la commande',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
