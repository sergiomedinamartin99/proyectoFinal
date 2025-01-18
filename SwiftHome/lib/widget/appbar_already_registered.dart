import 'package:flutter/material.dart';
import 'package:swifthome/page/chat_list.dart';
import 'package:swifthome/page/home.dart';
import 'package:swifthome/page/profile.dart';

class AppbarAlreadyRegistered extends StatelessWidget {
  String namePage;
  int idPersona;
  AppbarAlreadyRegistered({required this.namePage, required this.idPersona});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: (Navigator.of(context).canPop())
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(
                idPersona: idPersona,
              ),
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
            onPressed: namePage != 'home'
                ? () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          idPersona: idPersona,
                        ),
                      ),
                    );
                  }
                : null),
        IconButton(
          icon: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
          onPressed: namePage != 'chatList'
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatListPage(),
                    ),
                  );
                }
              : null,
        ),
        IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: namePage != 'profile'
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        idPersona: idPersona,
                      ),
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
