import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_project/firebase_options.dart';
import 'package:simple_project/screens/MyHomePage.dart';
import 'package:simple_project/screens/medcin.dart';
import 'package:simple_project/screens/splash.dart';
import 'package:simple_project/screens/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'autisme',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffffffff)),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            final userUid = snapshot.data!.uid;
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('enfants')
                  .doc(userUid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('medecins')
                        .doc(userUid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        // Utilisateur authentifié est un médecin
                        return MyHomeMedcin();
                      } else {
                        // Utilisateur authentifié est un enfant ou autre rôle
                        return MyHomePage();
                      }
                    },
                  );
                } else {
                  // Utilisateur authentifié est un enfant
                  return MyHomePage();
                }
              },
            );
          }
          return Splash();
        },
      ),
    );
  }
}
