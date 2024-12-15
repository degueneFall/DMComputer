import 'package:dmc_computer/cartModel.dart';
import 'package:dmc_computer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmc_computer/screen/accueil.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: ChangeNotifierProvider(
        create: (context) => ThemeModel(), // Ajout de la gestion du thème
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'myDMC',
          theme: themeModel.currentTheme, // Applique le thème actuel
          home: Rainu(),
        );
      },
    );
  }
}
