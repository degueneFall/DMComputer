import 'package:dmc_computer/screen/produitDetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:dmc_computer/api_service.dart';
import 'package:dmc_computer/product.dart';
import 'package:dmc_computer/category.dart';


class RechercheSceeen extends StatefulWidget {
  const RechercheSceeen({super.key});

  @override
  State<RechercheSceeen> createState() => _RechercheSceeenState();
}

class _RechercheSceeenState extends State<RechercheSceeen> {
  TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  late Future<List<Product>> _searchResults;
  late Future<List<Category>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ApiService.fetchCategories();  // Charger les catégories
    _searchResults = ApiService.fetchProductsWithSearch(); // Initialiser avec tous les produits
  }

  // Fonction pour exécuter la recherche
  void _search() {
    setState(() {
      _searchResults = ApiService.fetchProductsWithSearch(
        search: _searchController.text,  // Passer le texte de recherche
        categoryId: _selectedCategoryId,  // Passer la catégorie sélectionnée
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: Color(0xFF006400),
        centerTitle: true,
        title: Text(
          'Rechercher un produit DMC',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                // Champ de texte pour la recherche par nom
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un produit...',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: _search,  // Lancer la recherche
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Liste déroulante pour la sélection de catégorie
                FutureBuilder<List<Category>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Aucune catégorie disponible');
                    } else {
                      List<Category> categories = snapshot.data!;
                      return DropdownButton<int>(
                        hint: Text('Sélectionner une catégorie'),
                        value: _selectedCategoryId,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedCategoryId = newValue;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),

                // Espacement
                SizedBox(height: 20),

                // Afficher les résultats de recherche
                FutureBuilder<List<Product>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Aucun résultat trouvé', style: TextStyle(fontSize: 20, color: Colors.grey));
                    } else {
                      List<Product> products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product product = products[index];
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
                              elevation: 5,
                              child: Column(
                                children: [
                                  Image.network(
                                    product.imageUrl,
                                    width: double.infinity,
                                    height: 100,
                                  ),
                                  SizedBox(height: 8),
                                  Text(product.name, style: TextStyle(fontSize: 16)),
                                  Text('${product.price} FCFA', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
