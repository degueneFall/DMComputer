import 'package:dmc_computer/screen/accueil.dart';
import 'package:dmc_computer/screen/menu.dart';
import 'package:dmc_computer/screen/screenconnexion.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Pageinscription extends StatefulWidget {
  const Pageinscription({super.key});

  @override
  State<Pageinscription> createState() => _PageinscriptionState();
}

class _PageinscriptionState extends State<Pageinscription> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _inscrire() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs !')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Les mots de passe ne correspondent pas !')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://dmcomputer.sn/wp-json/wc/v3/customers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode("ck_ce2175287f13be3edb8c8bb884e2e9051cfe08ad:cs_c95c5bb6027fd918466dd18823a78a227a2d0b35"))}',
      },
      body: json.encode({
        'first_name': _prenomController.text,
        'last_name': _nomController.text,
        'email': _emailController.text,
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie ! Bienvenue !')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MenuScreen()));
    } else {
      String errorMessage;
      try {
        final errorResponse = json.decode(response.body);
        errorMessage = errorResponse['message'] ?? 'Échec de l\'inscription.';
      } catch (e) {
        errorMessage = 'Erreur inconnue : ${response.body}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'inscription : $errorMessage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Screenconnexion()));
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Inscription',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.white], // Dégradé vert en haut et blanc en bas
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Créer un compte",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Remplissez les informations pour vous inscrire", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 15),

                          TextField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              labelText: "Nom",
                              prefixIcon: Icon(Icons.person, color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 10),

                          TextField(
                            controller: _prenomController,
                            decoration: InputDecoration(
                              labelText: "Prénom",
                              prefixIcon: Icon(Icons.person, color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 10),

                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email, color: Colors.green),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 10),

                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Mot de passe",
                              prefixIcon: Icon(Icons.lock, color: Colors.green),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.green),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 10),

                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Confirmer le mot de passe",
                              prefixIcon: Icon(Icons.lock, color: Colors.green),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.green),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 15),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _inscrire,
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),

                          SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Vous avez déjà un compte ? ", style: TextStyle(color: Colors.grey)),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => Screenconnexion()));
                                },
                                child: Text("Se connecter", style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



