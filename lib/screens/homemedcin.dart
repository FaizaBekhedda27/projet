import 'package:flutter/material.dart';
import 'package:simple_project/screens/Oppointment.dart';
import 'package:simple_project/screens/more.dart';
import 'package:simple_project/screens/pagedoctor.dart';

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
                    image: AssetImage('assets/images/backgroundd.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.2),
                ])),
              ),
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
                                title: 'Ajouter Enfant ',
                                onPressed: () {
                                  // Action à effectuer lors du clic sur le bouton 1   UserDetails
                                /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetails(),
                                    ),
                                  );*/
                                }),
                            makeItem(
                                image: 'assets/images/2.png',
                                title: 'Liste Des Enfants',
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
                                image: 'assets/images/4.png',
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
                                image: 'assets/images/doctorr.png',
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
            borderRadius: BorderRadius.circular(20),
            image:
                DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.2),
              ])),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
