import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {

  final void Function()? onTap;
  final btnText;
  final color;

  const ButtonWidget({super.key,
    required this.onTap,
    required this.color,
    required this.btnText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16)
        ),
        child:  Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              btnText,
              style: const TextStyle(
                  color: Colors.white
              ),),
          ),
        ),
      ),
    );
  }
}
