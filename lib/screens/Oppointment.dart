import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListeRendezVousScreen extends StatefulWidget {
  @override
  _ListeRendezVousScreenState createState() => _ListeRendezVousScreenState();
}

class _ListeRendezVousScreenState extends State<ListeRendezVousScreen> {
  String selectedWeek = ''; // Initial value

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _formattedSelectedDate = ''; // Updated variable

  Map<String, Color> timeColors = {
    'Morning': const Color.fromARGB(255, 43, 105, 46),
    'Afternoon': const Color.fromARGB(255, 43, 105, 46),
    'Evening': const Color.fromARGB(255, 43, 105, 46),
  };

  bool _areTimeButtonsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 102, 183, 249),
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 242, 245, 245),
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://example.com/images/doctor.png'), // Placeholder URL
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('medecins')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Text('Docteur introuvable');
                        }
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        var firstName = userData['prenom'] as String? ?? '';
                        var lastName = userData['nom'] as String? ?? '';
                        var fullName = '$firstName $lastName';
                        return Text(
                          'Dr. ${fullName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Rendez-vous',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TableCalendar(
                    firstDay: DateTime.utc(2022, 1, 1),
                    lastDay: DateTime.utc(2060, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      // Use `selectedDay` to determine if a day is selected
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) async {
                      // Vérifier si la date sélectionnée est antérieure à aujourd'hui
                      if (selectedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                        // Afficher un message ou une alerte indiquant que la date est antérieure à aujourd'hui
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Sélection de date invalide"),
                              content: Text("Vous ne pouvez pas sélectionner une date antérieure à aujourd'hui."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return; // Sortir de la fonction si la date est antérieure à aujourd'hui
                      }
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // Mettre également à jour `_focusedDay`
                        _updateSelectedWeek(); // Appeler la méthode pour mettre à jour la semaine sélectionnée
                        _resetTimeButtons(); // Réinitialiser les boutons de temps
                        _areTimeButtonsEnabled = true;
                        _formattedSelectedDate =
                            "${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}";
                      });

                      // Récupérer les informations sur les créneaux horaires depuis Firestore
                      _fetchAppointmentInfoFromFirestore(selectedDay);
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(selectedWeek),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeSection('Matin',
                        ['8:30 - 9:30', '9:30 - 10:30', '10:30 - 11:30']),
                    SizedBox(height: 20),
                    _buildTimeSection('Après-midi',
                        ['13:30 - 14:30', '14:30 - 15:30', '15:30 - 16:30']),
                    SizedBox(height: 20),
                    _buildTimeSection('Soir', ['16:30 - 17:30']),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _areTimeButtonsEnabled ? _handleModifyButtonPressed : null,
                    child: Text('Modifier'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 102, 183, 249),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _areTimeButtonsEnabled ? _handleSaveButtonPressed : null,
                    child: Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 102, 183, 249),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            for (final time in times)
              _buildTimeButton(time,
                  true), // Passer true pour indiquer que le créneau est initiallement disponible
          ],
        ),
      ],
    );
  }

  Widget _buildTimeButton(String time, bool isAvailable) {
    Color buttonColor = timeColors[time] ?? const Color.fromARGB(255, 163, 211, 250);
    bool isFriday = _selectedDay?.weekday == DateTime.friday;
    return ElevatedButton(
      onPressed: _areTimeButtonsEnabled && !isFriday
          ? () => _showTimeDialog(
              time, isAvailable) // Passer l'état de disponibilité
          : null,
      child: Text(time),
      style: ElevatedButton.styleFrom(
        primary: isFriday ? Colors.grey : buttonColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showTimeDialog(String time, bool isAvailable) {
    bool selectedIsAvailable =
        isAvailable; // Initialisez l'état sélectionné à l'état initial
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Text('Choix temps disponible de rendez-vous pour $time'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIsAvailable = true; // Marquez comme disponible
                        timeColors[time] = Colors.green;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Disponible'),
                    style: ElevatedButton.styleFrom(
                      primary: selectedIsAvailable
                          ? Colors.green
                          : null, // Mise en évidence si sélectionné
                      onPrimary: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIsAvailable = false; // Marquez comme occupé
                        timeColors[time] = Colors.red;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Occupé'),
                    style: ElevatedButton.styleFrom(
                      primary: selectedIsAvailable
                          ? Colors.red
                          : null, // Mise en évidence si sélectionné
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateSelectedWeek() {
    // Adjust start of the week to Sunday
    DateTime startOfWeek = _focusedDay
        .subtract(Duration(days: (_focusedDay.weekday - DateTime.sunday) % 7));
    // Find the end of the week (Saturday)
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    // Format the week's dates
    String formattedWeek =
        'Semaine du ${startOfWeek.day} au ${endOfWeek.day} ${months[startOfWeek.month - 1]}';
    setState(() {
      selectedWeek = formattedWeek;
    });
  }

  void _resetTimeButtons() {
    setState(() {
      timeColors = {
        'Morning': const Color.fromARGB(255, 43, 105, 46),
        'Afternoon': const Color.fromARGB(255, 43, 105, 46),
        'Evening': const Color.fromARGB(255, 43, 105, 46),
      };
    });
  }

  void _handleModifyButtonPressed() {
    String appointmentDate =
        "${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}";
    String doctorId = FirebaseAuth.instance.currentUser!.uid;

    // Parcourir les créneaux horaires et mettre à jour le statut dans Firestore
    timeColors.forEach((time, color) {
      String status = color == Colors.green ? 'disponible' : 'occupé';
      FirebaseFirestore.instance.collection('appointments').where('doctor_id', isEqualTo: doctorId)
        .where('appointment_date', isEqualTo: appointmentDate)
        .where('appointment_time', isEqualTo: time)
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            // Mettre à jour le statut
            doc.reference.update({'status': status}).then((_) {
              print('Statut du créneau horaire $time mis à jour avec succès !');
            }).catchError((error) {
              print('Erreur lors de la mise à jour du statut du créneau horaire $time : $error');
            });
          });
        })
        .catchError((error) {
          print('Erreur lors de la récupération des créneaux horaires : $error');
        });
    });
  }

  void _handleSaveButtonPressed() {
  // Check if a day is selected
  if (_selectedDay != null) {
    // Format the selected date
    _formattedSelectedDate =
        "${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}";

    String doctorId = FirebaseAuth.instance.currentUser!.uid;

    List<String> availableTimes = [];
    List<String> occupiedTimes = [];

    // Separate available and occupied time slots
    timeColors.forEach((key, value) {
      if (value == Colors.green) {
        // Available time slots
        availableTimes.add(key);
      } else if (value == Colors.red) {
        // Occupied time slots
        occupiedTimes.add(key);
      }
    });

    // Save available time slots to Firestore with status "disponible"
    availableTimes.forEach((time) {
      FirebaseFirestore.instance.collection('appointments').add({
        'doctor_id': doctorId,
        'appointment_date': _formattedSelectedDate,
        'appointment_time': time,
        'status': 'disponible',
      }).then((value) {
        print('Rendez-vous pour $time enregistré avec succès !');
      }).catchError((error) {
        print(
            'Erreur lors de l\'enregistrement du rendez-vous pour $time : $error');
      });
    });

    // Save occupied time slots to Firestore with status "occupé"
    occupiedTimes.forEach((time) {
      FirebaseFirestore.instance.collection('appointments').add({
        'doctor_id': doctorId,
        'appointment_date': _formattedSelectedDate,
        'appointment_time': time,
        'status': 'occupé',
      }).then((value) {
        print('Rendez-vous pour $time enregistré avec succès !');
      }).catchError((error) {
        print(
            'Erreur lors de l\'enregistrement du rendez-vous pour $time : $error');
      });
    });
  } else {
    print('No day selected');
  }
}



  void _fetchAppointmentInfoFromFirestore(DateTime selectedDay) async {
    String formattedDate =
        "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointment_date', isEqualTo: formattedDate)
          .get();
      querySnapshot.docs.forEach((doc) {
        String appointmentTime = doc['appointment_time'];
        String status = doc['status'];
        Color buttonColor = status == 'disponible' ? Colors.green : Colors.red;
        setState(() {
          timeColors[appointmentTime] = buttonColor;
        });
      });
    } catch (e) {
      print(
          "Erreur lors de la récupération des informations sur les créneaux horaires depuis Firestore: $e");
    }
  }

  List<String> months = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre'
  ];

  @override
  void initState() {
    super.initState();
  }
}

void main() {
  runApp(MaterialApp(
    home: ListeRendezVousScreen(),
  ));
}
