import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swifthome/widget/appbarStart.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.idPersona});

  final int idPersona;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  List<Widget> cards = [
    Image.asset(
      'images/imagen3.jpg', // Otra imagen local
      fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
    ),
    Image.asset(
      'images/imagen3.jpg', // / Otra imagen local
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/imagen3.jpg', // / Otra imagen local
      fit: BoxFit.cover,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
          preferredSize: Size(20, 50),
          child: AppbarAlreadyRegistered(idPersona: widget.idPersona)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra la columna verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.idPersona.toString(),
                style: TextStyle(fontSize: 100),
              ),
              Text(
                "RoomSwipe: Encuentra tu compañero ideal",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 500,
                height: 500,
                child: CardSwiper(
                  controller: controller,
                  isLoop: false,
                  scale: 0.6,
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                      vertical: false, horizontal: true),
                  cardsCount: cards.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) =>
                          cards[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      hoverColor: Colors.red.shade100,
                      elevation: 0,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.left),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      hoverColor: Colors.green.shade100,
                      elevation: 0,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.right),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
