import 'package:flutter/material.dart';
import 'package:simple_project/screens/chat.dart';
import 'package:simple_project/screens/homemedcin.dart';
import 'package:simple_project/screens/more.dart';
import 'package:simple_project/screens/profileavant.dart';
import 'package:simple_project/screens/profilemedcin.dart';
import 'package:simple_project/screens/score.dart';

class MyHomeMedcin extends StatefulWidget {
  const MyHomeMedcin({Key? key}) : super(key: key);

  @override
  _MyHomeMedcinState createState() => _MyHomeMedcinState();
}

class _MyHomeMedcinState extends State<MyHomeMedcin> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePagemedcin(),
    SearchPage(),
    MedecinList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 80, // Modifier la hauteur du logo ici
            width: 80, // Modifier la largeur du logo ici
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //
            },
            icon: const Icon(Icons.menu),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 115, 194, 250),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 87, 183, 252),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search'),
    );
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Account'),
    );
  }
}
