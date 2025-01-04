import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swifthome/page/login.dart';
import 'package:swifthome/page/registration_step_one.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      body: Text("ChatListPage"),
    );
  }
}
