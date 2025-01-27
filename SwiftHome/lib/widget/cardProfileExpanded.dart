import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardprofileExpanded extends StatefulWidget {
  const CardprofileExpanded({super.key});

  @override
  State<CardprofileExpanded> createState() => _CardprofileExpandedState();
}

class _CardprofileExpandedState extends State<CardprofileExpanded> {
  final CardSwiperController controller = CardSwiperController();
  bool isExpanded = false;

  final List<String> _images = [
    'images/imagen3.jpg', // Cambia estas rutas por las tuyas
    'images/imagen2.jpg',
    'images/imagen3.jpg',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextImage() {
    if (_currentIndex < _images.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return cardTotalImage();
  }

  Widget cardTotalImage() {
    return Column(
      children: [
        Container(
          width: 500,
          height: 500,
          child: CardSwiper(
            controller: controller,
            isLoop: false,
            scale: 0.6,
            allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                vertical: false, horizontal: true),
            cardsCount: 3,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) =>
                    cardImage(),
          ),
        ),
        if (isExpanded) cardProfileExpanded(),
      ],
    );
  }

  Widget cardImage() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Image.asset(
              _images[index], // Ruta de la imagen
              fit: BoxFit.cover,
            );
          },
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black, // Color de fondo
                    foregroundColor: Colors.white, // Color del ícono
                  ),
                  onPressed: _prevImage,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black, // Color de fondo
                    foregroundColor: Colors.white, // Color del ícono
                  ),
                  onPressed: _nextImage,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "María García",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black, // Color de fondo
                      foregroundColor: Colors.white, // Color del ícono
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget cardProfileExpanded() {
    return Container(
      width: 500,
      child: Card(
        color: Colors.black,
        child: Column(
          children: [
            cardInformation("Ubicación:", "Valencia"),
            cardInformation("Ocupación:", "Estudiante"),
            cardInformation("Descripción:",
                "María es una joven de 25 años, de estatura media, aproximadamente 1,65 metros, con una complexión delgada pero atlética. Tiene el cabello castaño claro, que lleva siempre suelto y ligeramente ondulado, enmarcando un rostro ovalado con pecas sutiles. Sus ojos son grandes, de un color verde esmeralda, y están llenos de curiosidad. Su sonrisa es cálida y contagiosa, revelando su carácter amigable y cercano.")
          ],
        ),
      ),
    );
  }

  Widget cardInformation(String title, String information) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        child: Card(
          color: Color.fromRGBO(17, 20, 24, 1),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              style: TextStyle(color: Colors.white, fontSize: 18),
              "${title} ${information}",
            ),
          ),
        ),
      ),
    );
  }
}
