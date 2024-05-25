import 'package:flutter/material.dart';
import 'package:simple_project/screens/ajouterenfantmode.dart';

class ButtonPage extends StatelessWidget {
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
                'assets/images/pense.png', // Chemin de votre image
                height: 100, // Hauteur de l'image
                width: 100, // Largeur de l'image
              ),
              SizedBox(width: 0), // Espacement entre l'image et le texte
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "                    ajouter patient ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
        backgroundColor: Color.fromARGB(255, 102, 183, 249),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 230, 240, 250),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color.fromARGB(255, 102, 183, 249),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Veuillez choisir le type de patient à ajouter. Si le patient est déjà inscrit, sélectionnez 'Patient Deja Inscrit'. Vous serez redirigé vers une liste des patients existants pour ajouter des informations supplémentaires. Si le patient n'est pas encore inscrit, sélectionnez 'Patient Non Inscrit' pour créer un nouveau profil et saisir toutes les informations nécessaires.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LargeRoleButton(
                      image: 'images/OUI.jpg',
                      text: 'Patient Deja Inscrit',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnfantList(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 30), // Add spacing between buttons
                    _LargeRoleButton(
                      image: 'images/NON.jpg',
                      text: 'Patient Non Inscrit',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnfantList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LargeRoleButton extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onPressed;

  _LargeRoleButton({required this.image, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.buttonColor,
        onPrimary: AppColors.buttonTextColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.buttonBorderColor,
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(20), // Add padding to make the button larger
      ),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 110, // Increase image height
            width: 110, // Increase image width
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 18, // Increase font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class AppColors {
  static const Color appBarColor = Color.fromARGB(255, 4, 163, 248);
  static const Color buttonColor = const Color.fromARGB(255, 163, 211, 250);
  static const Color buttonTextColor = Color.fromARGB(255, 11, 11, 11);
  static const Color buttonBorderColor = Color.fromARGB(255, 203, 166, 80);
}
