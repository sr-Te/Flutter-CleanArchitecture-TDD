import 'package:flutter/material.dart';

class OnWillPopDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '¿Estás seguro que deseas salir?',
        textAlign: TextAlign.center,
      ),
      actionsOverflowButtonSpacing: 10,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.grey[900],
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Salir'),
              ),
              onPressed: () => Navigator.of(context).pop(true)),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.grey[900],
                ),
              ),
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false)),
        ],
      ),
    );
  }
}
