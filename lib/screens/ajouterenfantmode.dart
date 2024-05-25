import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_project/screens/form.dart';


class Medecin {
  final String userId; // Add userId here
  final String nom;
  final String prenom;
  final String adresse;
  final String imageUrl;
  final String numero;
  final String email;

  Medecin(
      {required this.userId, // Update the constructor to accept userId
      required this.nom,
      required this.prenom,
      required this.adresse,
      required this.imageUrl,
      required this.numero,
      required this.email,
      });
}

class EnfantList extends StatefulWidget {
  @override
  _EnfantListState createState() => _EnfantListState();
}

class _EnfantListState extends State<EnfantList> {
  late List<Medecin> medecins;
  late List<Medecin> filteredMedecins;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    medecins = [];
    filteredMedecins = [];
    fetchMedecins();
  }

  void fetchMedecins() async {
    QuerySnapshot medecinSnapshot =
        await FirebaseFirestore.instance.collection('enfants').get();
    setState(() {
      medecins = medecinSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medecin(
          userId: doc.id, // Retrieve the user ID
          nom: data['nom'] ?? '',
          prenom: data['prenom'] ?? '',
          adresse: data['adresse'] ?? '',
          imageUrl: data['image_url'] ?? '',
          numero: data['numero'] ?? '',
          email: data['email'] ?? '',
        );
      }).toList();
      filteredMedecins = medecins;
    });
  }

  void _filterMedecins(String searchText) {
    setState(() {
      filteredMedecins = medecins.where((medecin) {
        return medecin.nom.toLowerCase().contains(searchText.toLowerCase()) ||
            medecin.prenom.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Liste Des Enfants",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      _filterMedecins(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Rechercher...",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              15), // Ajuste la hauteur du champ de recherche
                    ),
                  ),
                ),
              ],
            ),
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
      body: ListView.builder(
        itemCount: filteredMedecins.length,
        itemBuilder: (context, index) {
          return MedecinCard(
            medecin: filteredMedecins[index],
          );
        },
      ),
    );
  }
}

class MedecinCard extends StatelessWidget {
  final Medecin medecin;

  MedecinCard({required this.medecin});

  @override
  Widget build(BuildContext context) {
      

    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(medecin.imageUrl),
        ),
        title: Text('${medecin.nom} ${medecin.prenom}'),
        subtitle: Text('${medecin.adresse}'),
        
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterPage(
                userId: medecin.userId, // Utilisez userId de l'instance medecin
                firstName: medecin.nom,
                lastName: medecin.prenom,
                imagePath: medecin.imageUrl,
                phoneNumber: medecin.numero,
                email: medecin.email,
                // Corrected line
              ),
            ),
          );
          // Action à effectuer lors du clic sur la carte du médecin
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailPage(
                userId: medecin.userId, // Utilisez userId de l'instance medecin
                firstName: medecin.nom,
                lastName: medecin.prenom,
                prefix: 'Dr.',
                specialty: 'psychologue/orthophoniste',
                imagePath: medecin.imageUrl,
                rank: 4.5,
                phoneNumber: '+1234567890',
              ),
            ),
          );*/
        },
      ),
    );
  }
}
