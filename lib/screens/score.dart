import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class CARSIIPage extends StatefulWidget {
  @override
  _CARSIIPageState createState() => _CARSIIPageState();
}

class _CARSIIPageState extends State<CARSIIPage> {
  final List<TextEditingController> controllers = List.generate(
    15,
    (index) => TextEditingController(),
  );

void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double totalScore = 0;
  double autismPercentage = 0;

  void calculateScores() {
    totalScore = 0;
    for (var controller in controllers) {
      if (controller.text.isNotEmpty) {
        totalScore +=
            double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
      }
    }

    // Calculer le pourcentage d'autisme en utilisant la table de correspondance
    autismPercentage = getAutismPercentage(totalScore);
  }

  double getAutismPercentage(double score) {
    // Tableau CARS II contenant les percentiles et les scores bruts correspondants
    List<Map<String, dynamic>> cars2Table = [
      {"percentile": 98, "score": 47},
      {"percentile": 97, "score": 46.5},
      {
        "percentile": 96,
        "score": [45.5, 46]
      },
      {"percentile": 95, "score": 45},
      {
        "percentile": 93,
        "score": [44, 44.5]
      },
      {"percentile": 92, "score": 43.5},
      {
        "percentile": 90,
        "score": [42, 42.5]
      },
      {
        "percentile": 88,
        "score": [41, 41.5]
      },
      {"percentile": 86, "score": 41},
      {"percentile": 84, "score": 40.5},
      {
        "percentile": 82,
        "score": [39, 39.5]
      },
      {
        "percentile": 79,
        "score": [38, 38.5]
      },
      {"percentile": 76, "score": 38},
      {"percentile": 72, "score": 37.5},
      {"percentile": 69, "score": 37},
      {
        "percentile": 65,
        "score": [36, 36.5]
      },
      {"percentile": 62, "score": 35.5},
      {"percentile": 58, "score": 35},
      {
        "percentile": 54,
        "score": [34, 34.5]
      },
      {
        "percentile": 50,
        "score": [33, 33.5]
      },
      {"percentile": 46, "score": 32.5},
      {"percentile": 42, "score": 32},
      {"percentile": 38, "score": 31.5},
      {
        "percentile": 35,
        "score": [30, 30.5]
      },
      {"percentile": 31, "score": 30},
      {"percentile": 28, "score": 29.5},
      {
        "percentile": 24,
        "score": [28, 28.5]
      },
      {"percentile": 21, "score": 27},
      {"percentile": 19, "score": 27.5},
      {"percentile": 16, "score": 26},
      {"percentile": 14, "score": 26.5},
      {"percentile": 12, "score": 26},
      {
        "percentile": 10,
        "score": [25, 25.5]
      },
      {"percentile": 8, "score": 24.5},
      {"percentile": 7, "score": 24},
      {"percentile": 6, "score": 23.5},
      {"percentile": 5, "score": 23},
      {
        "percentile": 4,
        "score": [22, 22.5]
      },
      {"percentile": 3, "score": 21.5},
      {"percentile": 2, "score": 21},
      {"percentile": 1, "score": 20},
    ];

    // Recherche linéaire du score brut dans le tableau CARS II
    for (var item in cars2Table) {
      if (item["score"] is List) {
        // Si le score est un intervalle
        double minScore = item["score"][0];
        double maxScore = item["score"][1];
        if (score >= minScore && score <= maxScore) {
          return item["percentile"].toDouble();
        }
      } else {
        // Si le score est unique
        if (item["score"] == score) {
          return item["percentile"].toDouble();
        }
      }
    }

    // Retourner null si le score n'est pas trouvé dans le tableau
    return 0;
  }

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
                'assets/images/appbar.png', // Chemin de votre image
                height: 90, // Hauteur de l'image
                width: 90, // Largeur de l'image
              ),
              SizedBox(width: 0), // Espacement entre l'image et le texte
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "  Diagnostic",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              SizedBox(height: 20),
              for (int i = 1; i <= 15; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getCategoryLabel(i),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 61, 109),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: controllers[i - 1],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Score',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/icon.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-3](\.[05]?)?)?$|^4(\.0?)?$')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (_) {
                          setState(() {
                            calculateScores();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 38, 174, 248).withOpacity(0.1),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score total : ${totalScore.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 15, 15, 15),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pourcentage d\'autisme : ${autismPercentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 27, 26, 26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 102, 183, 249),
                  ),
                ),
                onPressed: () {
                  // Ajoutez votre logique pour enregistrer ici
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
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

  String getCategoryLabel(int category) {
    switch (category) {
      case 1:
        return 'Compréhension socioémotionnelle';
      case 2:
        return 'Expression émotionnelle et régulation des émotions';
      case 3:
        return 'Relation avec autrui';
      case 4:
        return 'Utilisation du corps';
      case 5:
        return 'Utilisation des objets';
      case 6:
        return 'Adaptation aux changements et intérêt restreints';
      case 7:
        return 'Réponses visuelles';
      case 8:
        return 'Réponses auditives';
      case 9:
        return 'Goût, odorat, toucher, utilisation des sens';
      case 10:
        return 'Peur et anxiété';
      case 11:
        return 'Communication verbale';
      case 12:
        return 'Communication non verbale';
      case 13:
        return 'Les habiletés cognitives';
      case 14:
        return 'Niveau d\'intelligence';
      case 15:
        return 'Impression générale';
      default:
        return 'Score catégorie $category';
    }
  }
}
