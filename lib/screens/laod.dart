import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_project/screens/MyHomePage.dart';
import 'package:simple_project/screens/auth.dart';
import 'package:simple_project/screens/medcin.dart'; // myhomemedcin

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            // L'utilisateur est connecté
            final userUid = snapshot.data!.uid;

            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('enfants')
                  .doc(userUid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Les données de l'utilisateur ne sont pas trouvées dans la collection "enfants"
                  // On essaie de récupérer depuis la collection "medecins"
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('medecins')
                        .doc(userUid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        // Les données de l'utilisateur sont trouvées dans la collection "medecins"
                        return MyHomeMedcin();
                      } else {
                        // Si les données de l'utilisateur ne sont pas trouvées dans la collection "medecins" non plus
                        // Vous pouvez effectuer une action ou rediriger vers une autre page si nécessaire
                        // Par exemple, rediriger vers l'écran d'authentification
                        return AuthScreen();
                      }
                    },
                  );
                } else {
                  // Les données de l'utilisateur sont trouvées dans la collection "enfants"
                  return MyHomePage();
                }
              },
            );
          } else {
            // L'utilisateur n'est pas connecté, vous pouvez rediriger vers l'écran d'authentification
            return AuthScreen();
          }
        }
      },
    );
  }
}
