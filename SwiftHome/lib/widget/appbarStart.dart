import 'package:flutter/material.dart';
import 'package:swifthome/page/leading.dart';
import 'package:swifthome/page/login.dart';

class AppbarStart extends StatelessWidget {
  final String page;
  AppbarStart({required this.page});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      title: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LeadingPage(),
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
        if (page != "leading")
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
