import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                // L'utilisateur n'est pas authentifié
                return Center(child: Text('Utilisateur non authentifié'));
              }

              User user = snapshot.data!;
              String userId = user.uid;

              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('enfants')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    // Gérer l'erreur de chargement de données
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      !snapshot.data!.exists) {
                    // Essayez de récupérer les données de la collection "medecins"
                    return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('medecins')
                          .doc(userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          // Gérer l'erreur de chargement de données
                          return Center(
                              child: Text('Erreur: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            !snapshot.data!.exists) {
                          // L'utilisateur n'existe ni dans la collection "enfants" ni dans la collection "medecins"
                          return Center(
                              child: Text(
                                  'Aucune information utilisateur trouvée'));
                        }
                        Map<String, dynamic> userData = snapshot.data!.data()!;
                        String firstName = userData['prenom'] ??
                            ''; // Récupère le prénom depuis Firestore
                        String lastName = userData['nom'] ??
                            ''; // Récupère le nom depuis Firestore
                        String email = userData['email'] ?? '';
                        String phone = userData['numero'] ?? '';
                        String image = userData['image_url'] ?? '';

                        return buildProfileWidget('$firstName $lastName', email,
                            phone, image.toString());
                      },
                    );
                  }
                  Map<String, dynamic> userData = snapshot.data!.data()!;
                  String name = userData['nom'] ?? '';
                  String email = userData['email'] ?? '';
                  String phone = userData['numero'] ?? '';
                  String image = userData['image_url'] ?? '';
                  return buildProfileWidget(
                      name, email, phone, image.toString());
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildProfileWidget(
      String name, String email, String phone, String image) {
    return Column(
      children: [
        const SizedBox(height: 40),
        if (image.isNotEmpty)
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 144, 201, 201),
            backgroundImage: Image.network(
              image,
              errorBuilder: (context, error, stackTrace) {
                // Gérer l'erreur de chargement de l'image
                print('Erreur lors du chargement de l\'image: $error');
                // Retourner un widget alternatif en cas d'erreur
                return Icon(Icons.error);
              },
            ).image,
            radius: 70,
          ),
        const SizedBox(height: 20),
        itemProfile('Name', name, CupertinoIcons.person),
        const SizedBox(height: 10),
        itemProfile('Email', email, CupertinoIcons.mail),
        const SizedBox(height: 10),
        itemProfile('Phone', phone, CupertinoIcons.phone),
        const SizedBox(height: 20),
        itemProfile(
            'Address', 'abc address, xyz city', CupertinoIcons.location),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: const Color.fromARGB(255, 144, 201, 201),
            ),
            child: Text(
              'Modifier',
              style: TextStyle(color: Color.fromARGB(255, 245, 247, 245),fontWeight: FontWeight.bold,  fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Color.fromARGB(255, 127, 210, 190).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        tileColor: Colors.white,
      ),
    );
  }
}
/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('Utilisateur non authentifié'));
              }

              User user = snapshot.data!;
              String userId = user.uid;

              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('enfants')
                    .doc(userId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      !snapshot.data!.exists) {
                    return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('medecins')
                          .doc(userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Erreur: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            !snapshot.data!.exists) {
                          return Center(
                              child: Text(
                                  'Aucune information utilisateur trouvée'));
                        }
                        Map<String, dynamic> userData = snapshot.data!.data()!;
                        String firstName = userData['prenom'] ?? '';
                        String lastName = userData['nom'] ?? '';
                        String email = userData['email'] ?? '';
                        String phone = userData['numero'] ?? '';
                        String image = userData['image_url'] ?? '';

                        return buildProfileWidget(
                            '$firstName $lastName', email, phone, image.toString(), '', context);
                      },
                    );
                  }
                  Map<String, dynamic> userData = snapshot.data!.data()!;
                  String name = userData['nom'] ?? '';
                  String email = userData['email'] ?? '';
                  String phone = userData['numero'] ?? '';
                  String image = userData['image_url'] ?? '';
                  return buildProfileWidget(
                      name, email, phone, image.toString(), '', context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildProfileWidget(
      String name, String email, String phone, String image, String address, BuildContext context) {
    TextEditingController addressController = TextEditingController(text: address);

    return Column(
      children: [
        const SizedBox(height: 40),
        if (image.isNotEmpty)
          CircleAvatar(
            backgroundImage: Image.network(
              image,
              errorBuilder: (context, error, stackTrace) {
                print('Erreur lors du chargement de l\'image: $error');
                return Icon(Icons.error);
              },
            ).image,
            radius: 70,
          ),
        const SizedBox(height: 20),
        itemProfile('Name', name, CupertinoIcons.person),
        const SizedBox(height: 10),
        itemProfile('Email', email, CupertinoIcons.mail),
        const SizedBox(height: 10),
        itemProfile('Phone', phone, CupertinoIcons.phone),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showAddressDialog(addressController, context);
          },
          child: Text('Modifier l\'adresse'),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: const Color.fromARGB(255, 144, 201, 201),
            ),
            child: Text(
              'Déconnexion',
              style: TextStyle(
                color: Color.fromARGB(255, 245, 247, 245),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddressDialog(TextEditingController addressController, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier l\'adresse'),
          content: TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Nouvelle adresse',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                saveAddress(context, addressController.text);
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void saveAddress(BuildContext context, String newAddress) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('enfants')
        .doc(userId)
        .update({'address': newAddress})
        .then((value) {
      print('Adresse mise à jour avec succès');
    }).catchError((error) {
      print('Erreur lors de la mise à jour de l\'adresse: $error');
    });
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Color.fromARGB(255, 127, 210, 190).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        tileColor: Colors.white,
      ),
    );
  }
}
 */