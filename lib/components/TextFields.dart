import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? lineCount;
  final bool? enable;
  final bool? obscure;

  const CustomTextField({
    super.key,
    this.hintText,
    this.obscure =false,
    this.lineCount,
    this.enable = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    int maxlines;
    if (lineCount != null) {
      maxlines = lineCount! * 2;
    } else {
      maxlines = 1;
    }
    return TextField(
      controller: controller,
      obscureText: obscure!,
      enabled: enable,
      maxLines: maxlines,
      minLines: lineCount,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black38, style: BorderStyle.solid)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black38, style: BorderStyle.solid)),
        focusedBorder: const OutlineInputBorder(),
      ),
    );
  }
}
