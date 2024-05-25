import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

File? _image;

class RegisterPage extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String imagePath;
  final String phoneNumber;
  final String email;

  RegisterPage(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.imagePath,
      required this.phoneNumber,
      required this.email});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isFemmeChecked = false;
  bool isHommeChecked = false;
  DateTime? _selectedDate;
  //create the controllers
  TextEditingController childNameController = TextEditingController();
  TextEditingController childPrenomController = TextEditingController();
  TextEditingController childEmailController = TextEditingController();
  TextEditingController childMobileController = TextEditingController();
  TextEditingController childAddressController = TextEditingController();
  TextEditingController childAgeController = TextEditingController();
  TextEditingController childDiagnosticController = TextEditingController();
  TextEditingController childAutreController = TextEditingController();
  TextEditingController childDateController = TextEditingController();

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorEmailController = TextEditingController();
  TextEditingController doctorMobileController = TextEditingController();
  TextEditingController doctorlastNameController = TextEditingController();
  TextEditingController doctorlastNamecabinetController =
      TextEditingController();
  TextEditingController doctorAddressController = TextEditingController();
  bool _isChildInfo = true;
  void initState() {
    super.initState();
    childNameController.text = widget.firstName;
    childPrenomController.text = widget.lastName;
    childEmailController.text = widget.email;
    childMobileController.text = widget.phoneNumber;
    if (widget.imagePath != null && widget.imagePath.isNotEmpty) {
      _image = File(widget.imagePath);
    }
    _selectedDate = DateTime.now();
    _fetchDoctorData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        childDateController.text = DateFormat.yMMMMd('en_US').format(picked);
      });
    }
  }

  Future<void> _selectImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String imagePath = '${directory.path}/${image.path.split('/').last}';
    final File imageFile = File(image.path);
    await imageFile.copy(imagePath);
    setState(() {
      _image = File(imagePath);
    });
  }
}

  void _selectGender(bool isMale) {
    setState(() {
      if (isMale) {
        isHommeChecked = true;
        isFemmeChecked = false;
      } else {
        isHommeChecked = false;
        isFemmeChecked = true;
      }
    });
  }

  //
  Future<void> _fetchDoctorData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('medecins')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          final Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          print('Fetched doctor data: $userData');
          setState(() {
            doctorNameController.text = userData['nom'];
            doctorlastNameController.text = userData['prenom'];
            doctorEmailController.text = userData['email'];
            doctorMobileController.text = userData['numero'];
          });
        } else {
          print('No doctor data found for user ID ${currentUser.uid}');
        }
      } else {
        print('No current user found.');
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  //
  bool _validateForm() {
    if (childNameController.text.isEmpty ||
        childPrenomController.text.isEmpty ||
        childDateController.text.isEmpty ||
        childAgeController.text.isEmpty ||
        childEmailController.text.isEmpty ||
        childMobileController.text.isEmpty ||
        childAddressController.text.isEmpty ||
        selectedDiagnostic == null ||
        childDiagnosticController.text.isEmpty) {
      return false;
    }
    return true;
  }

  //
  InputBorder _getBorder(bool isFilled) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: isFilled ? Colors.green : Colors.red,
        width: 2,
      ),
    );
  }
  //

  String? selectedDiagnostic;
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
              SizedBox(width: 0), // Espacement entre l'image et le texte
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ajouter La Liste des Enfants",
                    style: TextStyle(
                      fontSize: 17,
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
        backgroundColor: Color.fromARGB(255, 102, 183, 249),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: _isChildInfo
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    //image
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                _image != null ? FileImage(_image!) : null,
                            child: _image == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.grey[800],
                                  )
                                : null,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 102, 183, 249),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 15,
                                color: Colors.white,
                              ),
                              //

                              //
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    const Text('Nom *'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez le nom',
                      ),
                    ),
                    //
                    const Text('Prenom'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childPrenomController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez le prenom',
                      ),
                    ),
                    //some space between name and email
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    //
                    CheckboxListTile(
                      title: Text('Femme'),
                      value: isFemmeChecked,
                      onChanged: (value) {
                        _selectGender(false); // Sélectionne Femme
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Homme'),
                      value: isHommeChecked,
                      onChanged: (value) {
                        _selectGender(true); // Sélectionne Homme
                      },
                    ),

                    //
                    const Text('Date de Naissance'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childDateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez la Date de Naissance',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ),

                    //

                    //
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    const Text('Age'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childAgeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez ici',
                      ),
                    ),
                    //
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    const Text('Email'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childEmailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez Email',
                      ),
                    ),
                    //some space between email and mobile
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Téléphone'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childMobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez  le numero Téléphone',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Address'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childAddressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez Address',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //
                    const Text('Diagnostique'),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez ici',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedDiagnostic,
                      onChanged: (value) {
                        setState(() {
                          selectedDiagnostic = value;
                          childDiagnosticController.text = value ?? '';
                        });
                      },
                      items: [
                        'Autisme sévère',
                        'Autisme moyen',
                        'Autisme léger',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    //
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    const Text("Autres maladies"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: childAutreController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez ici',
                      ),
                    ),
                    //
                    const SizedBox(
                      height: 10,
                    ),
                    //
                    //create button for next
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isChildInfo = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 102, 183, 249),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            10), // Ajouter un padding de 16 sur tous les côtés
                        child: Text(
                          'continue',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _isChildInfo = true;
                            });
                          },
                        ),
                      ],
                    ),

                    /*IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _isChildInfo = true;
                        });
                      },
                    ),*/
                    const Text('Nom du Medecin'),
                    const SizedBox(
                      height: 5,
                    ),

                    TextField(
                      controller: doctorNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez le nom du medecin',
                      ),
                    ),
                    //
                    const Text('prenom du Medecin'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: doctorlastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez le prenom du medecin',
                      ),
                    ),
                    //some space between name and email
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Email du Medecin'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: doctorEmailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez Email du medecin',
                      ),
                    ),
                    //some space between email and mobile
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(' Numero de Telephone '),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: doctorMobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez tlf',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //doctorlastNamecabinetController
                    const Text('Nom de Cabinet'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: doctorlastNamecabinetController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez ici',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //
                    const Text('Adresse '),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: doctorAddressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entrez Adresse ',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //create button for next
                    ElevatedButton(
                      onPressed: _validateForm()
                          ? () async {
                              // Create a new document in the "patients" collection
                              final FirebaseFirestore _firestore =
                                  FirebaseFirestore.instance;
                              await _firestore.collection('patients').add({
                                'userId': widget.userId,
                                'nom': childNameController.text,
                                'prenom': childPrenomController.text,
                                'dateNaissance': childDateController.text,
                                'age': childAgeController.text,
                                'email': childEmailController.text,
                                'telephone': childMobileController.text,
                                'adresse': childAddressController.text,
                                'diagnostique': selectedDiagnostic,
                                'autreMaladie': childAutreController.text,
                                'medecin': {
                                  'nom': doctorNameController.text,
                                  'prenom': doctorlastNameController.text,
                                  'email': doctorEmailController.text,
                                  'telephone': doctorMobileController.text,
                                  'cabinet':
                                      doctorlastNamecabinetController.text,
                                  'adresse': doctorAddressController.text,
                                },
                                'imagePath': _image != null ? _image!.path : '',
                                'gender': isHommeChecked ? 'homme' : 'femme',
                              });

                              // Show a success message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Succès'),
                                    content:
                                        Text('Patient enregistré avec succès'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // Clear the form fields
                              childNameController.clear();
                              childPrenomController.clear();
                              childDateController.clear();
                              childAgeController.clear();
                              childEmailController.clear();
                              childMobileController.clear();
                              childAddressController.clear();
                              childAutreController.clear();
                              doctorNameController.clear();
                              doctorlastNameController.clear();
                              doctorEmailController.clear();
                              doctorMobileController.clear();
                              doctorlastNamecabinetController.clear();
                              doctorAddressController.clear();
                              selectedDiagnostic = null;
                              setState(() {
                                _isChildInfo = true;
                              });
                            }
                          : null,
                      //...
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 102, 183, 249),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            10), // Ajouter un padding de 16 sur tous les côtés
                        child: Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
