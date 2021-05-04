import 'package:flutter/material.dart';

class DrawerCategoryButton extends StatelessWidget {
  final String title;
  final void Function() function;
  const DrawerCategoryButton({
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
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Expanded(child: Container()),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
