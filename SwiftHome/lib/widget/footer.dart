import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color.fromRGBO(229, 231, 235, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "© 2025 RoomSwipe. Todos los derechos reservados.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
