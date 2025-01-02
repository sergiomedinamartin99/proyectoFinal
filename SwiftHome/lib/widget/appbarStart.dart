import 'package:flutter/material.dart';
import 'package:swifthome/page/login.dart';

class AppbarStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          true, // Esto habilita la flecha solo si hay una página anterior en la pila
      leading: (Navigator.of(context)
              .canPop()) // Verifica si hay una página anterior
          ? IconButton(
              icon:
                  Icon(Icons.arrow_back, color: Colors.white), // Flecha blanca
              onPressed: () {
                Navigator.of(context).pop(); // Volver a la página anterior
              },
            )
          : null, // No muestra la flecha si no hay página anterior
      title: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        child: Text(
          'RoomSwipe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
