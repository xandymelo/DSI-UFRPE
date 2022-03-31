import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final String labeltext;
  final TextEditingController controlador;
  final IconData? icon;

  Editor({
    required this.labeltext,
    required this.controlador,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon) : null,
          labelText: labeltext,
        ),
      ),
    );
  }
}
