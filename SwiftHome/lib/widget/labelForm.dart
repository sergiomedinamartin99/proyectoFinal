import 'package:flutter/material.dart';

class labelForm extends StatelessWidget {
  final String title;
  labelForm({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          text: title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(
              text: "\t*",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
