 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_project/screens/chat.dart';


class Medecin {
  final String userId; // Add userId here
  final String nom;
  final String prenom;
  final String adresse;
  final String imageUrl;

  Medecin({
    required this.userId, // Update the constructor to accept userId
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.imageUrl,
  });
}

class MedecinList extends StatefulWidget {
  @override
  _MedecinListState createState() => _MedecinListState();
}

class _MedecinListState extends State<MedecinList> {
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
        await FirebaseFirestore.instance.collection('medecins').get();
    setState(() {
      medecins = medecinSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medecin(
          userId: doc.id, // Retrieve the user ID
          nom: data['nom'] ?? '',
          prenom: data['prenom'] ?? '',
          adresse: data['adresse'] ?? '',
          imageUrl: data['image_url'] ?? '',
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
                  "Liste Des Médecins",
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
                      contentPadding: EdgeInsets.symmetric(vertical: 15), // Ajuste la hauteur du champ de recherche
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
        backgroundColor: Color.fromARGB(255, 144, 201, 201),
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
          // Action à effectuer lors du clic sur la carte du médecin
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
          );
        },
      ),
    );
  }
}

//
class DoctorDetailPage extends StatelessWidget {
  final String userId; // Add userId here
  final String firstName;
  final String lastName;
  final String prefix;
  final String specialty;
  final String imagePath;
  final double rank;
  final String phoneNumber;

  DoctorDetailPage({
    required this.userId, // Add userId to the constructor
    required this.firstName,
    required this.lastName,
    required this.prefix,
    required this.specialty,
    required this.imagePath,
    required this.rank,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 144, 201, 201),
        title: Text(
          'Détails du médecin',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(221, 252, 251, 251),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                radius: 65, // Increase the radius of the avatar
                backgroundImage: NetworkImage(imagePath),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$prefix $firstName $lastName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              specialty,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 20), // Space between avatar and call button
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Appelle',
                  onTap: () => _callDoctor(context),
                ),
                Spacer(), // Flexible space between buttons
                _buildActionButton(
                  icon: Icons.message,
                  label: 'Message',
                  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(doctorId: userId, doctorName: '',),
    ),
  );
},

                ),
                SizedBox(
                    width: 20), // Space between message button and avatar
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam lobortis justo nec nibh commodo, eget vestibulum libero tempor. Sed sed sapien sit amet ligula bibendum hendrerit. Integer sit amet ipsum justo. In eget dolor sit amet sapien feugiat pellentesque ut ac magna. Aliquam a arcu a velit tempor aliquet.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Address:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '123 Main Street,\nCity, Country',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  void _callDoctor(BuildContext context) {
    // Add functionality to make a call
    print('Calling Doctor: $phoneNumber');
  }
}