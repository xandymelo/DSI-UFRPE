import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/editor.dart';

const _startupName = 'Startup Name';

class EditSuggestion extends StatelessWidget {
  final String suggestion;
  final TextEditingController _suggestionController = TextEditingController();

  EditSuggestion({
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    _suggestionController.text = suggestion;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Suggestion'),
      ),
      body: Column(
        children: [
          Editor(labeltext: _startupName, controlador: _suggestionController),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _suggestionController.text);
              },
              child: Text('Modificar'),
            ),
          )
        ],
      ),
    );
  }
}
