import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/editor.dart';

const _startupFirstName = 'First Name';
const _startupSecondName = 'Second Name';
const _modifyButton =  'Modificar';
const _deleteButton =  'Exluir';

class EditSuggestion extends StatelessWidget {
  final String _firstSuggestion;
  final String _secondSuggestion;
  final TextEditingController _suggestionFirstController = TextEditingController();
  final TextEditingController _suggestionSecondController = TextEditingController();


  EditSuggestion(this._firstSuggestion, this._secondSuggestion,);

  @override
  Widget build(BuildContext context) {
    _suggestionFirstController.text = _firstSuggestion;
    _suggestionSecondController.text = _secondSuggestion;
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
                  Navigator.pop(context, ['D',_firstSuggestion,_secondSuggestion]);
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
