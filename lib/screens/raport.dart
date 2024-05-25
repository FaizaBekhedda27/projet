import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class RapportPage extends StatefulWidget {
  const RapportPage({Key? key}) : super(key: key);

  @override
  State<RapportPage> createState() => _RapportPageState();
}

class _RapportPageState extends State<RapportPage> {
  String? _imagePath;
  // Ajoutez ici les variables nécessaires pour les contrôleurs de texte, l'image et les autres données
  //create the controllers
  TextEditingController childNameController = TextEditingController();
  TextEditingController childPrenomController = TextEditingController();
  TextEditingController childEmailController = TextEditingController();
  TextEditingController childMobileController = TextEditingController();
  TextEditingController childAddressController = TextEditingController();
  TextEditingController childAgeController = TextEditingController();
  TextEditingController childDiagnostiqueController = TextEditingController();
  TextEditingController childAutreController = TextEditingController();
  TextEditingController childDateController = TextEditingController();
  TextEditingController childgenreController = TextEditingController();
  //childgenreController

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorEmailController = TextEditingController();
  TextEditingController doctorMobileController = TextEditingController();
  TextEditingController doctorlastNameController = TextEditingController();
  TextEditingController doctorlastNamecabinetController =
      TextEditingController();
  TextEditingController doctorAddressController = TextEditingController();
  //
  void initState() {
    super.initState();
    _fetchData();
  }

  //
  Future<void> _fetchData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('userId', isEqualTo: currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final patient = querySnapshot.docs.first.data();
        final imagePath = patient['imagePath'];

        setState(() {
          // Update the text fields with the data
          childNameController.text = patient['nom'];
          childPrenomController.text = patient['prenom'];
          childEmailController.text = patient['email'];
          childMobileController.text = patient['telephone'];
          childAddressController.text = patient['adresse'];
          childAgeController.text = patient['age'].toString();
          childDiagnostiqueController.text = patient['diagnostique'];
          childAutreController.text = patient['autreMaladie'];
          childDateController.text = patient['dateNaissance'];
          childgenreController.text = patient['gender'];

          doctorNameController.text = patient['medecin']['nom'];
          doctorlastNameController.text = patient['medecin']['prenom'];
          doctorEmailController.text = patient['medecin']['email'];
          doctorMobileController.text = patient['medecin']['telephone'];
          doctorlastNamecabinetController.text = patient['medecin']['cabinet'];
          doctorAddressController.text = patient['medecin']['adresse'];

          // Update the image path
          _imagePath = imagePath;
        });
      } else {
        print('No data found for user ${currentUser.uid}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//
  Future<void> _generatePdfAndSave(BuildContext context) async {
  final pdf = pw.Document();

  // Patient Information
  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      return pw.Center(
        child: pw.Column(
          children: [
            pw.Text('Informations sur le patient',
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(childNameController.text),
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(childPrenomController.text),
                  ),
                ),
              ],
            ),
            // Add the rest of the patient and doctor information here
             pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(childDateController.text),
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(childAgeController.text),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childgenreController.text),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childEmailController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childMobileController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childAddressController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childDiagnostiqueController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(childAutreController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 32),
            pw.Text('Informations sur le médecin', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(doctorNameController.text),
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child: pw.Text(doctorlastNameController.text),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(doctorEmailController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(doctorMobileController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(doctorlastNamecabinetController.text),
                  ),
                ),
              ],
            ),
            //
            pw.SizedBox(height: 16),
            //
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#fbfcf7'),
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#000000'),
                        width: 1,
                      ),
                    ),
                    child:pw.Text(doctorAddressController.text),
                  ),
                ),
              ],
            ),
            
            
          ],
        ),
      );
    },
  ));

  try {
    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/rapport.pdf");
    await file.writeAsBytes(await pdf.save());

    // Print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    
    // Show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rapport téléchargé avec succès')),
    );
  } catch (e) {
    // Handle errors
    print('Error while saving or printing PDF: $e');
  }
}


//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/rapport.png', // Chemin de votre image
                height: 110, // Hauteur de l'image
                width: 110, // Largeur de l'image
              ),
              SizedBox(width: 40), // Espacement entre l'image et le texte
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rapport du patient",
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
        backgroundColor: Color.fromARGB(255, 144, 201, 201),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            children: [
              // Patient Information
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 249, 247, 225),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations sur le patient',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 251, 252, 243),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black,
                          width: 1, // Épaisseur de la bordure
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _imagePath ?? 'default_image_path',
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person),
                        height: 100,
                        width: 80,
                        /*  errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/rapport.png',
                            height: 100,
                            width: 80,
                          );
                        },*/
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: childNameController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: childPrenomController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: childDateController,
                            decoration: InputDecoration(
                              labelText: 'Date de naissance',
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: childAgeController,
                            decoration: InputDecoration(
                              labelText: 'Âge',
                            ),
                          ),
                        ),
                      ],
                    ),
                    //genre
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childgenreController,
                      decoration: InputDecoration(
                        labelText: 'genre',
                      ),
                    ),
                    //
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childEmailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse-mail',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childMobileController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childAddressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                      ),
                    ),
                    //
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childDiagnostiqueController,
                      decoration: InputDecoration(
                        labelText: 'Diagnostique',
                      ),
                    ),
                    //
                    SizedBox(height: 8),
                    TextFormField(
                      controller: childAutreController,
                      decoration: InputDecoration(
                        labelText: 'Autres maladies',
                      ),
                    ),
                    //
                    SizedBox(height: 30),
                    Text(
                      'Informations sur le médecin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: doctorNameController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: doctorlastNameController,
                            decoration: InputDecoration(
                              labelText: 'Prenom',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: doctorEmailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse-mail',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: doctorMobileController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone ',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: doctorlastNamecabinetController,
                      decoration: InputDecoration(
                        labelText: 'Nom de Cabinet',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: doctorAddressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse du cabinet',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              SizedBox(height: 16),

              // Submit Button
              Container(
                width: 230,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 162, 202, 202),
                    ),
                  ),
                  onPressed: () async {
                    // Implement form submission here
                    await _generatePdfAndSave(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.white, // Couleur blanche pour l'icône
                        ),
                        SizedBox(
                            width: 1.5), // Espacement entre l'icône et le texte
                        Text(
                          ' Télécharger',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
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
}
