import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/edit_suggestion.dart';
import 'package:flutter_application_1/screens/random_words.dart';


void main() => runApp(StartupGenerator());

class StartupGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}



