import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/editor.dart';

const _startupFirstName = 'First Name';
const _startupSecondName = 'Second Name';
const _modifyButton =  'Modificar';
const _deleteButton =  'Exluir';

class EditSuggestion extends StatelessWidget {
  final TextEditingController _suggestionFirstController = TextEditingController();
  final TextEditingController _suggestionSecondController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _suggestionFirstController.text = args!['first'].toString();
    _suggestionSecondController.text = args!['second'].toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Suggestion'),
      ),
      body: Column(
        children: [
          Editor(labeltext: _startupFirstName, controlador: _suggestionFirstController),
          Editor(labeltext: _startupSecondName, controlador: _suggestionSecondController),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, ['M',_suggestionFirstController.text,_suggestionSecondController.text]);
                },
                child: Text('$_modifyButton'),
              ),
            ),
          ),Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, ['D',args!['first'].toString(),args!['second'].toString()]);
                },
                child: Text('$_deleteButton'),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
