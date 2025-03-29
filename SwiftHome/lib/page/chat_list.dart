import 'package:flutter/material.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/footer.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    super.key,
    required this.idPersona,
    required this.buscandoPiso,
    required this.isAdmin,
  });

  final int idPersona;
  final bool buscandoPiso;
  final bool isAdmin;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppbarAlreadyRegistered(
          namePage: 'chat',
          idPersona: widget.idPersona,
          buscandoPiso: widget.buscandoPiso,
          isAdmin: widget.isAdmin,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Próximamente...",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
