import 'package:flutter/material.dart';

class SnackbarPersonalized {
  final String title;
  SnackbarPersonalized({required this.title});

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(title),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
