import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(PatientCardEnfant());
}

class PatientCard extends StatelessWidget {
  final String name;
  final String age;
  final String gender;
  final String diagnostique;
  final String imagePath;
  final String dateNaissance;
  final String medecinName;
  final String cabinet;

  const PatientCard({
    Key? key,
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnostique,
    required this.imagePath,
    required this.dateNaissance,
    required this.medecinName,
    required this.cabinet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      flipOnTouch: true,
      front: _buildFrontCard(),
      back: _buildBackCard(),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      height: 220.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 254, 255, 255),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120.0,
                height: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 192, 212, 207),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: imagePath.isNotEmpty
                          ? Image.network(
                              imagePath,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Placeholder(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 38, 38, 38),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'dateNaissance: $dateNaissance',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 49, 53, 52)),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Age: $age',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 49, 53, 52)),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Sexe: $gender',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 49, 53, 52)),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Diagnostic: $diagnostique',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 49, 53, 52)),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'par: Dr $medecinName',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 49, 53, 52)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 5,
            top: 2,
            child: _buildCustomShape(Color.fromARGB(255, 195, 244, 240)),
          ),
          Positioned(
            right: 20,
            top: 40,
            child: _buildCustomShape(Color.fromARGB(255, 246, 223, 193)),
          ),
          Positioned(
            right: 40,
            top: 78,
            child: _buildCustomShape(Color.fromARGB(255, 181, 221, 250)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      height: 200.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 192, 212, 207),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'clinique: $cabinet',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 36, 35, 35),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCustomShape(Color color) {
    return Container(
      width: 40,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class PatientCardEnfant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Current user ID: ${currentUser?.uid}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Carte de patient'),
          ),
        ),
        body: Center(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('patients')
                .where('userId', isEqualTo: currentUser!.uid)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    final patientData = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    final name =
                        '${patientData['nom']} ${patientData['prenom']}';
                    final age = patientData['age'].toString();
                    final gender = patientData['gender'] ?? '';
                    final diagnostique = patientData['diagnostique'] ?? '';
                    final dateNaissance =
                        patientData['dateNaissance'].toString();
                    final imagePath = patientData['imagePath'] ?? '';
                         // Placeholder image URL
                    final medecinName =
                        '${patientData['medecin']['nom']} ${patientData['medecin']['prenom']}';
                    final cabinet = '${patientData['medecin']['cabinet']} ';

                    return PatientCard(
                      name: name,
                      age: age,
                      gender: gender,
                      diagnostique: diagnostique,
                      imagePath: imagePath,
                      dateNaissance: dateNaissance,
                      medecinName: medecinName,
                      cabinet: cabinet,
                    );
                  } else {
                    return Text('Document not found');
                  }
                } else {
                  return Text('Document not found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
