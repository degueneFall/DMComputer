import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmc_computer/screen/produitDetails_screen.dart';
import 'package:dmc_computer/theme.dart';
import 'package:flutter/material.dart';
import 'package:dmc_computer/api_service.dart';
import 'package:provider/provider.dart';
import '../category.dart';
import '../product.dart';
import 'drawer_sreen.dart';
import 'panier.dart';
import 'recherche.screen.dart';
import 'screenconnexion.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;
  late Future<List<Category>> _categories;
  late Future<List<Product>> _products;
  int? _selectedCategoryId; // Ajout d'une catégorie sélectionnée
  late Future<List<String>> _sliders; // Pour stocker les URL des sliders


  @override
  void initState() {
    super.initState();
    _categories = ApiService.fetchCategories(); // Charger les catègories
    _products = ApiService.fetchProducts();// Charger les produits
    _sliders = ApiService.fetchSliders(); // Charger les sliders
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Page Accueil', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Page Recherche', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Page Notifications', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    Text('Page Profil', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _filterByCategory(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _products = ApiService.fetchProducts(categoryId: categoryId); // Filtrer par catégorie
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF006400),
        centerTitle: true,
        title: Text('DMComputer.sn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              // Basculer entre les thèmes
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.brightness_6, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Panier()));
            },
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: DrawerScreen(),
      body: ClipRect(
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              // Carrousel
              FutureBuilder<List<String>>(
                future: _sliders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No sliders available');
                  } else {
                    List<String> sliders = snapshot.data!;
                    return CarouselSlider(
                      items: sliders.map((sliderUrl) {
                        return Image.network(
                          sliderUrl,
                          width: 300,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 150.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    );
                  }
                },
              ),


              // Fetch and display categories
          FutureBuilder<List<Category>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No categories available');
              } else {
                List<Category> categories = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Catégories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () => _filterByCategory(category.id), // Filtrer par catégorie
                                child: AnimatedOpacity(
                                  opacity: 1.0,  // Peut être dynamique selon l'état
                                  duration: Duration(milliseconds: 300),
                                  child: Chip(
                                    label: Text(category.name),
                                    backgroundColor: _selectedCategoryId == category.id ? Color(0xFF006400) : Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),


          // Fetch and display products
              FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No products available');
                  } else {
                    List<Product> products = snapshot.data!;
                    return Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: calculateChildAspectRatio(2),
                        children: products.map((product) => _buildProductCard(product)).toList(),

                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (_selectedIndex == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MenuScreen()));
          }
          if (_selectedIndex == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RechercheSceeen()));
          }
          if (_selectedIndex == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Panier()));
          }
          if (_selectedIndex == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screenconnexion()));
          }
        },
        selectedItemColor: Color(0xFF006400),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String text, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
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
                      color: Color(0xFF006400),
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        product.isFavorite = !product.isFavorite;
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
                Text('${product.price} FCFA',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  double calculateChildAspectRatio(int crossAxisCount) {
    return (crossAxisCount == 2) ? 1.0 : 1.5;
  }
}
