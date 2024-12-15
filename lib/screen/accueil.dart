import 'dart:async';

import 'package:flutter/material.dart';

import 'menu.dart';

class Rainu extends StatefulWidget {
  const Rainu({super.key});

  @override
  State<Rainu> createState() => _RainuState();
}

class _RainuState extends State<Rainu> {
  @override
  void initState(){
    allerALaPageSuivante();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/img.jpg'),
                fit: BoxFit.cover,
              )
          ),
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  void allerALaPageSuivante(){
    Timer(Duration(seconds:5),(){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=> MenuScreen()));
    });
  }

}

