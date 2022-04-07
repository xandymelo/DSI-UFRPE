import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/edit_suggestion.dart';
import 'package:flutter_application_1/screens/random_words.dart';
import 'package:flutter_application_1/screens/save_suggestions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StartupGenerator());
  }

class StartupGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
          ).copyWith(
            secondary: Colors.yellow[800],
          )
      ),
      title: 'Startup Name Generator',
      home: RandomWords(),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/edit': (context) => EditSuggestion(),
        '/saved': (contexxt) => SaveSuggestions(),
      },
    );
  }
}



