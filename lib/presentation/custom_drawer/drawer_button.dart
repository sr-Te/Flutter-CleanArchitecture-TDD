import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() function;
  const DrawerButton({
    @required this.icon,
    @required this.title,
    @required this.function,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: function,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
