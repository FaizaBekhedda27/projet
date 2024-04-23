import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_project/widgets/text_widget.dart';
import 'package:simple_project/screens/auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool position = false;
  var opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() async {
    setState(() {
      opacity = opacity == 0 ? 1 : 0;
      position = !position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: position ? screenHeight * 0.05 : screenHeight * 0.3,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextWidget(
                      "Enfants Autistes",
                      35,
                      Colors.black,
                      FontWeight.bold,
                      letterSpace: 5,
                    ),
                    const SizedBox(height: 5),
                    TextWidget(
                      "Psychologie ",
                      35,
                      Colors.black,
                      FontWeight.bold,
                      letterSpace: 5,
                    ),
                    const SizedBox(height: 5),
                    TextWidget(
                      "Phoniatre",
                      30,
                      Colors.black,
                      FontWeight.bold,
                      letterSpace: 5,
                    ),
                    const SizedBox(height: 20),
                    TextWidget(
                      "Protection précoce\npour la santé\nde votre enfant",
                      18,
                      Colors.black.withOpacity(.7),
                      FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: screenHeight * 0.002,
              left: position ? screenWidth * 0.3 : screenWidth * 0.4,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.8,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/s.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: screenHeight * 0.12,
              duration: const Duration(milliseconds: 400),
              left: position ? screenWidth * 0.05 : -screenWidth * 0.2,
              child: InkWell(
                onTap: () {
                  position = false;
                  opacity = 0;
                  setState(() {});
                  Timer(
                    const Duration(milliseconds: 400),
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      );
                    },
                  );
                },
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 144, 201, 201),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextWidget(
                        "Commencer",
                        17,
                        Colors.white,
                        FontWeight.bold,
                        letterSpace: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
