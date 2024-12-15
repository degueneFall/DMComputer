import 'package:dmc_computer/screen/apropos_screen.dart';
import 'package:dmc_computer/screen/confidentialite_screen.dart';
import 'package:dmc_computer/screen/favoris_screen.dart';
import 'package:dmc_computer/screen/recherche.screen.dart';
import 'package:flutter/material.dart';

import 'menu.dart';
import 'panier.dart';


class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Image(
                image: AssetImage('images/logo.png'),
                width: 200,
                height: 70,
                fit: BoxFit.contain,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),

            ),


            ListTile(
              leading: Icon(Icons.home,),
              title: Text("Accueil", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>MenuScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_border,),
              title: Text("Favoris", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context)=>FavorisScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search,),
              title: Text("Recherche", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RechercheSceeen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart,),  // Autre icône personnalisée
              title: Text("Panier", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Panier()));
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined,),  // Autre icône personnalisée
              title: Text("Partager", style: TextStyle(color: Colors.black)),
              onTap: () {
                // Action à effectuer lors du clic sur cet élément
              },
            ),
            ListTile(
              leading: Icon(Icons.person,),  // Autre icône personnalisée
              title: Text("Mon compte", style: TextStyle(color: Colors.black)),
              onTap: () {
                // Action à effectuer lors du clic sur cet élément
              },
            ),
            ListTile(
              leading: Icon(Icons.info,),  // Autre icône personnalisée
              title: Text("A propos", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AproposScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock,),  // Autre icône personnalisée
              title: Text("Politique de confidentialité", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ConfidentialiteScreen()));
              },
            ),
            ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsque le bouton est pressé
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Deconnexion',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                )

            ),

          ],
        ),
      ),
    );

  }
}