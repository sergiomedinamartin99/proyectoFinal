import 'package:flutter/material.dart';
import 'package:swifthome/page/leading.dart';

class AppbarStart extends StatelessWidget {
  final String page;
  AppbarStart({required this.page});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      title: TextButton(
        onPressed: (page != "leading")
            ? () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LeadingPage(),
                  ),
                );
              }
            : null,
        child: Text(
          'RoomSwipe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
