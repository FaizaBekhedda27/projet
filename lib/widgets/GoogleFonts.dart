import 'package:flutter/material.dart';


class FormulairePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/enfant.png', // Chemin de votre image
                height: 130, // Hauteur de l'image
                width: 130, // Largeur de l'image
              ),
              SizedBox(width: 8), // Espacement entre l'image et le texte
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ajouter La Liste des Enfants",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 130,
        toolbarOpacity: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        elevation: 0.00,
        backgroundColor: Color.fromARGB(255, 144, 201, 201),
      ),
      
    );
  }
}