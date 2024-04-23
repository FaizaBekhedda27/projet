/*import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

final _firebase = FirebaseAuth.instance;
void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
      ),
    );

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  final _form = GlobalKey<FormState>();

  bool phoniatreValue = false;
  bool enfantValue = false;
  var _isLogin = true;
  var _enteredPrenom = '';
  var _enteredNom = '';
  var _enteredNumero = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  Uint8List? _selectedImage;
  var _isAuthenticating = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      final pickedImageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = pickedImageBytes;
      });
    }
  }

  void _submit() async {
  print('Submit button pressed.');
  final isValid = _form.currentState!.validate();

  if (!isValid || (!_isLogin && _selectedImage == null)) {
    return;
  }

  _form.currentState!.save();

  try {
    print('Attempting authentication...');
    setState(() {
      _isAuthenticating = true;
    });

    String? imageUrl;

    if (_isLogin) {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
      print('User authenticated: ${userCredentials.user!.email}');
    } else {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
      print('User created with email: ${userCredentials.user!.email}');

      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putData(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
        print('Image uploaded. URL: $imageUrl');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'prenom': _enteredPrenom,
        'nom': _enteredNom,
        'numero': _enteredNumero,
        'username': _enteredUsername,
        'email': _enteredEmail,
        'password': _enteredPassword,
        'image_url': imageUrl ?? '',
        'role': phoniatreValue ? 'medcin' : 'enfant', // Ajout du champ 'role'
      });
      print('User data saved to Firestore.');
    }
  } on FirebaseAuthException catch (error) {
    print('Firebase Authentication Error: ${error.message}');
    if (error.code == 'email-already-in-use') {
      //...
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.message ?? 'authentication failed.'),
    ));
    setState(() {
      _isAuthenticating = false;
    });
  }
}


  void _resetForm() {
    _form.currentState!.reset();
    setState(() {
      _enteredPrenom = '';
      _enteredNom = '';
      _enteredNumero = '';
      _enteredEmail = '';
      _enteredPassword = '';
      _enteredUsername = '';
      _selectedImage = null;
      _isAuthenticating = false;
    });
  }

  // mana nbda nchof
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Ajout de SingleChildScrollView
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 88, 212, 163),
            Color.fromARGB(255, 152, 231, 199),
            Color.fromARGB(255, 199, 241, 226)
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(3, 245, 156, 0.294),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _form,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isLogin)
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Color.fromARGB(
                                                255, 230, 230, 230),
                                            backgroundImage: _selectedImage !=
                                                    null
                                                ? MemoryImage(_selectedImage!)
                                                : null,
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () => _pickImage(
                                                    ImageSource.camera),
                                                icon: Icon(Icons.camera_alt),
                                                label: Text('Caméra'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 95, 207, 181),
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton.icon(
                                                onPressed: () => _pickImage(
                                                    ImageSource.gallery),
                                                icon: Icon(Icons.image),
                                                label: Text('Galerie'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 95, 207, 181),
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Prénom',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Veuillez saisir votre prénom';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          // Sauvegardez la valeur du prénom ici
                                          _enteredPrenom = value!;
                                        },
                                      ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Nom',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Veuillez saisir votre nom';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          // Sauvegardez la valeur du nom ici
                                          _enteredNom = value!;
                                        },
                                      ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Numéro de téléphone',
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty ||
                                              !RegExp(r'^[0-9]{10}$')
                                                  .hasMatch(value)) {
                                            return 'Veuillez saisir un numéro de téléphone valide';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          // Sauvegardez la valeur du numéro de téléphone ici
                                          _enteredNumero = value!;
                                        },
                                      ),
                                    //
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Adresse email'),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains("@")) {
                                          return 'S\'il vous plaît, mettez une adresse email valide';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredEmail = value!;
                                      },
                                    ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Nom d\'utilisateur'),
                                        enableSuggestions: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length < 6) {
                                            return 'Veuillez saisir au moins 6 caractères';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredUsername = value!;
                                        },
                                      ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Mot de passe'),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length < 8) {
                                          return 'Le mot de passe doit comporter au moins 8 caractères.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPassword = value!;
                                      },
                                    ),
                                    if (!_isLogin)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                20), // Ajoute de l'espace en haut
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: phoniatreValue,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  phoniatreValue = newValue!;
                                                  if (newValue!) {
                                                    // Si la case "Phoniatre" est cochée, décocher la case "Enfant"
                                                    enfantValue = false;
                                                  }
                                                });
                                              },
                                              activeColor: const Color.fromARGB(
                                                  255,
                                                  95,
                                                  207,
                                                  181), // Définir la couleur de la case cochée
                                            ),
                                            Text('Medecin'),
                                            SizedBox(
                                              width: 20,
                                            ), // Ajoutez un espace entre les boutons
                                            Checkbox(
                                              value: enfantValue,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  enfantValue = newValue!;
                                                  if (newValue!) {
                                                    // Si la case "Enfant" est cochée, décocher la case "Phoniatre"
                                                    phoniatreValue = false;
                                                  }
                                                });
                                              },
                                              activeColor: const Color.fromARGB(
                                                  255,
                                                  95,
                                                  207,
                                                  181), // Définir la couleur de la case cochée
                                            ),
                                            Text('Enfant'),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      
                      FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      const SizedBox(height: 12),
                      if (_isAuthenticating) const CircularProgressIndicator(),
                      if (!_isAuthenticating)
                        FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: _submit,
                              height: 50,
                              color: Color.fromARGB(255, 95, 207, 181),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  _isLogin ? 'Se connecter' : 'S\'inscrire',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      SizedBox(
                        height: 10,
                      ),
                      if (!_isAuthenticating)
                        Container(
                          margin: EdgeInsets.only(
                              top: 5), // Ajout de la marge entre les boutons
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _resetForm(); // Réinitialiser le formulaire
                              });
                            },
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1700),
                                child: Text(
                                  _isLogin
                                      ? ' Pas encore membre ? Créer un compte'
                                      : "j'ai déjà un compte",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 25, 25, 25)),
                                )),
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
// deix cpllection
 import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:simple_project/screens/MyHomePage.dart';
import 'package:simple_project/screens/medcin.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  bool medecinValue = false;
  bool enfantValue = false;
  var _isLogin = true;
  var _enteredPrenom = '';
  var _enteredNom = '';
  var _enteredNumero = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  Uint8List? _selectedImage;
  var _isAuthenticating = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      final pickedImageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = pickedImageBytes;
      });
    }
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      String? imageUrl;

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        _navigateToNextPage(userCredentials.user!);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        if (_selectedImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child("user_images")
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putData(_selectedImage!);
          imageUrl = await storageRef.getDownloadURL();
        }

        final userData = {
          'prenom': _enteredPrenom,
          'nom': _enteredNom,
          'numero': _enteredNumero,
          'username': _enteredUsername,
          'email': _enteredEmail,
          'password': _enteredPassword,
          'image_url': imageUrl ?? '',
          'role': medecinValue ? 'medecin' : 'enfant',
        };

        if (medecinValue) {
          await FirebaseFirestore.instance
              .collection('medecins')
              .doc(userCredentials.user!.uid)
              .set(userData);
        } else {
          await FirebaseFirestore.instance
              .collection('enfants')
              .doc(userCredentials.user!.uid)
              .set(userData);
        }

        _navigateToNextPage(userCredentials.user!);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Authentication failed.'),
      ));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _navigateToNextPage(User user) {
  FirebaseFirestore.instance
      .collection('medecins')
      .doc(user.uid)
      .get()
      .then((medecinDoc) {
    if (medecinDoc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomeMedcin()),
      );
    } else {
      FirebaseFirestore.instance
          .collection('enfants')
          .doc(user.uid)
          .get()
          .then((enfantDoc) {
        if (enfantDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          print("Utilisateur non trouvé dans les collections 'medecins' et 'enfants'");
        }
      }).catchError((error) {
        print("Erreur lors de la recherche dans la collection 'enfants': $error");
        // Gérer les erreurs de récupération des données utilisateur
      });
    }
  }).catchError((error) {
    print("Erreur lors de la recherche dans la collection 'medecins': $error");
    // Gérer les erreurs de récupération des données utilisateur
  });
}

  void _resetForm() {
    _form.currentState!.reset();
    setState(() {
      _enteredPrenom = '';
      _enteredNom = '';
      _enteredNumero = '';
      _enteredEmail = '';
      _enteredPassword = '';
      _enteredUsername = '';
      _selectedImage = null;
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 144, 201, 201),
                Color.fromARGB(255, 152, 231, 199),
                Color.fromARGB(255, 199, 241, 226)
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(3, 245, 156, 0.294),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _form,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!_isLogin)
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor:
                                              Color.fromARGB(255, 230, 230, 230),
                                          backgroundImage: _selectedImage != null
                                              ? MemoryImage(_selectedImage!)
                                              : null,
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _pickImage(ImageSource.camera),
                                              icon: Icon(Icons.camera_alt),
                                              label: Text('Caméra'),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Color.fromARGB(255, 144, 201, 201),
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _pickImage(ImageSource.gallery),
                                              icon: Icon(Icons.image),
                                              label: Text('Galerie'),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Color.fromARGB(255, 144, 201, 201),
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  if (!_isLogin)
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Prénom',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Veuillez saisir votre prénom';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredPrenom = value!;
                                      },
                                    ),
                                  if (!_isLogin)
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Nom',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Veuillez saisir votre nom';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredNom = value!;
                                      },
                                    ),
                                  if (!_isLogin)
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Numéro de téléphone',
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                          return 'Veuillez saisir un numéro de téléphone valide';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredNumero = value!;
                                      },
                                    ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Adresse email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains("@")) {
                                        return 'S\'il vous plaît, mettez une adresse email valide';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredEmail = value!;
                                    },
                                  ),
                                  if (!_isLogin)
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Nom d\'utilisateur',
                                      ),
                                      enableSuggestions: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length < 6) {
                                          return 'Veuillez saisir au moins 6 caractères';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredUsername = value!;
                                      },
                                    ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Mot de passe',
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.trim().length < 8) {
                                        return 'Le mot de passe doit comporter au moins 8 caractères.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredPassword = value!;
                                    },
                                  ),
                                  if (!_isLogin)
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: medecinValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                medecinValue = newValue!;
                                                if (newValue!) {
                                                  enfantValue = false;
                                                }
                                              });
                                            },
                                            activeColor:
                                                Color.fromARGB(255, 144, 201, 201),
                                          ),
                                          Text('Medecin'),
                                          SizedBox(width: 20),
                                          Checkbox(
                                            value: enfantValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                enfantValue = newValue!;
                                                if (newValue!) {
                                                  medecinValue = false;
                                                }
                                              });
                                            },
                                            activeColor:
                                                Color.fromARGB(255, 144, 201, 201),
                                          ),
                                          Text('Enfant'),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (_isLogin)
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      SizedBox(
                        height: 25,
                      ),
                      const SizedBox(height: 12),
                      if (_isAuthenticating) const CircularProgressIndicator(),
                      if (!_isAuthenticating)
                        FadeInUp(
                          duration: Duration(milliseconds: 1600),
                          child: MaterialButton(
                            onPressed: _submit,
                            height: 50,
                            color: Color.fromARGB(255, 144, 201, 201),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                _isLogin ? 'Se connecter' : 'S\'inscrire',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (!_isAuthenticating)
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _resetForm();
                              });
                            },
                            child: FadeInUp(
                              duration: Duration(milliseconds: 1700),
                              child: Text(
                                _isLogin
                                    ? ' Pas encore membre ? Créer un compte'
                                    : "j'ai déjà un compte",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 25, 25, 25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// MyHomePage
 

/*import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  Uint8List? _selectedImage;
  var _isAuthenticating = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      final pickedImageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = pickedImageBytes;
      });
    }
  }

  void _submit() async {
    print('Submit button pressed.');
    final isValid = _form.currentState!.validate();

    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    _form.currentState!.save();

    try {
      print('Attempting authentication...');
      setState(() {
        _isAuthenticating = true;
      });

      String? imageUrl; // Déclarer imageUrl ici

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('User authenticated: ${userCredentials.user!.email}');
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('User created with email: ${userCredentials.user!.email}');

        if (_selectedImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child("user_images")
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putData(_selectedImage!);
          imageUrl = await storageRef.getDownloadURL(); // Affecter la valeur à imageUrl
          print('Image uploaded. URL: $imageUrl');
        }

        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'password': _enteredPassword,
          'image_url': imageUrl ?? '', // Utiliser imageUrl ici
        });
        print('User data saved to Firestore.');
      }
    } on FirebaseAuthException catch (error) {
      print('Firebase Authentication Error: ${error.message}');
      if (error.code == 'email-already-in-use') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'authentication failed.'),
      ));
      setState(() {
        _isAuthenticating = false; // Mettre à false ici
      });
    }
  }

  void _resetForm() {
    _form.currentState!.reset();
    setState(() {
      _enteredEmail = '';
      _enteredPassword = '';
      _enteredUsername = '';
      _selectedImage = null;
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              Card(
                color: Color.fromARGB(255, 240, 251, 241),
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color.fromARGB(255, 230, 230, 230),
                                  backgroundImage: _selectedImage != null
                                      ? MemoryImage(_selectedImage!)
                                      : null,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.camera),
                                      icon: Icon(Icons.camera_alt),
                                      label: Text('Caméra'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 95, 207, 181),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.gallery),
                                      icon: Icon(Icons.image),
                                      label: Text('Galerie'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 95, 207, 181),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Adresse email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains("@")) {
                                return 'S\'il vous plaît, mettez une adresse email valide';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.isEmpty || value.trim().length < 6) {
                                  return 'Veuillez saisir au moins 6 caractères';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Mot de passe'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 8) {
                                return 'Le mot de passe doit comporter au moins 8 caractères.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 95, 207, 181),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(150, 40),
                              ),
                              child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
                            ),
                          if (!_isAuthenticating)
                            Container(
                              margin: EdgeInsets.only(top: 5), // Ajout de la marge entre les boutons
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _resetForm(); // Réinitialiser le formulaire
                                  });
                                },
                                child: Text(_isLogin ? 'Créer un compte' : "j'ai déjà un compte"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
//appmobile
/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  var _isAuthenticating = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _submit() async {
    print('Submit button pressed.');
    final isValid = _form.currentState!.validate();

    if (!isValid || (!_isLogin && _selectedImage == null)) {
      return;
    }

    _form.currentState!.save();

    try {
      print('Attempting authentication...');
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('User authenticated: ${userCredentials.user!.email}');
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('User created with email: ${userCredentials.user!.email}');

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print('Image uploaded. URL: $imageUrl');

        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'password': _enteredPassword,
          'image_url': imageUrl,
        });
        print('User data saved to Firestore.');
      }
    } on FirebaseAuthException catch (error) {
      print('Firebase Authentication Error: ${error.message}');
      if (error.code == 'email-already-in-use') {
        //...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'authentication failed.'),
      ));
      setState(() {
        _isAuthenticating = false; // Mettre à false ici
      });
    }
  }

  void _resetForm() {
    _form.currentState!.reset();
    setState(() {
      _enteredEmail = '';
      _enteredPassword = '';
      _enteredUsername = '';
      _selectedImage = null;
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/logo.png'),
              ),
              Card(
                color: Color.fromARGB(255, 240, 251, 241),
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color.fromARGB(255, 230, 230, 230),
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : null,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.camera),
                                      icon: Icon(Icons.camera_alt),
                                      label: Text('Caméra'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 95, 207, 181),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.gallery),
                                      icon: Icon(Icons.image),
                                      label: Text('Galerie'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 95, 207, 181),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Adresse email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains("@")) {
                                return 'S\'il vous plaît, mettez une adresse email valide';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.isEmpty || value.trim().length < 6) {
                                  return 'Veuillez saisir au moins 6 caractères';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Mot de passe'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 8) {
                                return 'Le mot de passe doit comporter au moins 8 caractères.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 95, 207, 181),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(150, 40),
                              ),
                              child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
                            ),
                          if (!_isAuthenticating)
                            Container(
                              margin: EdgeInsets.only(top: 5), // Ajout de la marge entre les boutons
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _resetForm(); // Réinitialiser le formulaire
                                  });
                                },
                                child: Text(_isLogin ? 'Créer un compte' : "j'ai déjà un compte"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
