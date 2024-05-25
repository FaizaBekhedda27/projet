import 'package:flutter/material.dart';
import 'package:simple_project/screens/Oppointment.dart';
import 'package:simple_project/screens/ajouterenfantmode.dart';
import 'package:simple_project/screens/ajouterinscrit.dart';
import 'package:simple_project/screens/more.dart';
import 'package:simple_project/screens/pagedoctor.dart';
import 'package:simple_project/screens/score.dart';

class HomePagemedcin extends StatefulWidget {
  @override
  _HomePagemedcinState createState() => _HomePagemedcinState();
}

class _HomePagemedcinState extends State<HomePagemedcin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/fv.jpg'),
                    fit: BoxFit.cover),
              ),
              /*
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.2),
                ])),
              ),*/
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Services",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            makeItem(
                                image: 'assets/images/1.png',
                                title: 'Ajouter patient ',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 1   UserDetails
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                              ButtonPage(),

                                    ),
                                  );
                                }),
                            makeItem(
                                image: 'assets/images/2.png',
                                title: 'Liste Des patients',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 2
                                }),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            makeItem(
                                image: 'assets/images/3.png',
                                title: 'Rendez-Vous',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 3
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ListeRendezVousScreen(),
                                    ),
                                  );
                                }),
                            makeItem(
                                image: 'assets/images/ajouter.png',
                                title: 'Liste Des Rendez-Vous ',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 4
                                }),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            makeItem(
                                image: 'assets/images/medecin.png',
                                title: 'Liste Des Médecin',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 3
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MedecinList(),
                                    ),
                                  );
                                }),
                                //
                                makeItem(
                                image: 'assets/images/patient.png',
                                title: 'Diagnositic',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 3
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CARSIIPage(),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeItem(
      {required String image,
      required String title,
      required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160, // Largeur du bouton
        height: 160, // Hauteur du bouton
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color.fromARGB(255, 163, 211, 250)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.asset(
              image,
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
