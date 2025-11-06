import 'package:flutter/material.dart';

class Categorybutton extends StatelessWidget {
  final int id;
  final String categoryName;
  final String imageUrl;

  const Categorybutton({
    super.key,
    required this.id,
    required this.categoryName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: WidgetStatePropertyAll(4.0),
          backgroundColor: WidgetStatePropertyAll(
            const Color.fromARGB(255, 240, 239, 239),
          ),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))))),
      onPressed: () {
        Navigator.pushNamed(
          context,
          "/categorySearch",
          arguments: {"id":id,"name":categoryName}
        );
      },
      child: Column(
        children: [
          Image.network(imageUrl,fit: BoxFit.cover,height: 60,width: 60,),
          Text(
            categoryName,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
