import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_project/screens/profilemedcin.dart';
import 'package:simple_project/screens/raport.dart';
import 'package:simple_project/screens/start.dart';

class ProfileE extends StatefulWidget {
  const ProfileE({Key? key}) : super(key: key);

  @override
  _ProfileEPageState createState() => _ProfileEPageState();
}

class _ProfileEPageState extends State<ProfileE> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Splash()));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Rediriger vers l'écran de connexion si aucun utilisateur n'est connecté
      Navigator.pushReplacementNamed(context, '/login');
      return Container(); // Retourne un widget vide pour éviter une erreur
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('enfants')
          .doc(currentUser.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Si l'utilisateur n'existe pas dans la collection "enfants", on essaie dans la collection "medecins"
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('medecins')
                .doc(currentUser.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('Utilisateur introuvable');
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              var firstName = userData['prenom'] as String? ?? '';
              var lastName = userData['nom'] as String? ?? '';
              var fullName = '$firstName $lastName';
              var image = userData['image_url'] as String? ?? '';
              return buildProfileWidget(context, fullName, image);
            },
          );
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        var firstName = userData['prenom'] as String? ?? '';
        var lastName = userData['nom'] as String? ?? '';
        var fullName = '$firstName $lastName';
        var image = userData['image_url'] as String? ?? '';
        return buildProfileWidget(context, fullName, image);
      },
    );
  }

  Widget buildProfileWidget(
      BuildContext context, String fullName, String imageUrl) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 40,
        ),
        CircleAvatar(
          backgroundColor: Color.fromARGB(255, 102, 183, 249),
          radius: 70,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Center(
            child: Text(
              fullName,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        ProfileItem(
          text: 'profile',
          icon: Icons.account_circle,
          onTap: () {
            // Naviguer vers la page de notifications
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        ProfileItem(
          text: 'Notifications',
          icon: Icons.notifications,
          onTap: () {
            // Naviguer vers la page de notifications
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RapportPage()),
            );
          },
        ),
        ProfileItem(
          text: 'Log Out',
          icon: Icons.logout_rounded,
          onTap: () async {
            signOut();
          },//  
        ),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {required this.onTap, required this.text, required this.icon});

  final dynamic onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Container(
            height: _width / 14,
            width: _width / 14,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black12),
                color: Color.fromARGB(255, 102, 183, 249)),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
