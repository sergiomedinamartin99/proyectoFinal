import 'package:flutter/material.dart';
import 'package:swifthome/page/chat_list.dart';
import 'package:swifthome/page/home.dart';
import 'package:swifthome/page/leading.dart';
import 'package:swifthome/page/profile.dart';

class AppbarAlreadyRegistered extends StatelessWidget {
  String namePage;
  int idPersona;
  bool buscandoPiso;
  bool isAdmin;
  AppbarAlreadyRegistered(
      {required this.namePage,
      required this.idPersona,
      required this.buscandoPiso,
      required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      title: TextButton(
        onPressed: (!isAdmin && namePage != 'home')
            ? () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      idPersona: idPersona,
                      buscandoPiso: buscandoPiso,
                      isAdmin: isAdmin,
                    ),
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
      actions: [
        if (!isAdmin)
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
                            buscandoPiso: buscandoPiso,
                            isAdmin: isAdmin,
                          ),
                        ),
                      );
                    }
                  : null),
        if (!isAdmin)
          IconButton(
            icon: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            onPressed: namePage != 'chat'
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatListPage(
                          idPersona: idPersona,
                          buscandoPiso: buscandoPiso,
                          isAdmin: isAdmin,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        if (!isAdmin)
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: namePage != 'profile'
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          idPersona: idPersona,
                          buscandoPiso: buscandoPiso,
                          isAdmin: isAdmin,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LeadingPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
