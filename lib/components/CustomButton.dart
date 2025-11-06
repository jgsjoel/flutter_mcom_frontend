import 'package:flutter/material.dart';

class CustomLongButton extends StatelessWidget {
  
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final bool? enabled;
  
  const CustomLongButton({
    super.key,
    this.enabled = true,
    this.text = "",
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    required this.onPressed,
    });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 4,
        minimumSize: Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text??"",
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
