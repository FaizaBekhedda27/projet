/*import 'package:flutter/material.dart';
import 'package:simple_project/screens/chat.dart';

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
      builder: (context) => ChatScreen(doctorId: userId),
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
}*/
