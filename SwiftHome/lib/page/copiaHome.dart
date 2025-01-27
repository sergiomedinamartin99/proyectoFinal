import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.idPersona});

  final int idPersona;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  final ScrollController scrollController =
      ScrollController(); // Añade un ScrollController separado
  bool isExpanded = false;

  List<Personas> listPersonas = [
    Personas(
      2,
      "Juan Pérez",
      "Madrid",
      "Estudiante",
      "Juan es un joven de 24 años, de estatura media, aproximadamente 1,75 metros, con una complexión atlética. Tiene el cabello castaño oscuro, que lleva corto y despeinado, enmarcando un rostro cuadrado con una barba de varios días. Sus ojos son pequeños, de un color marrón oscuro, y están llenos de determinación. Su sonrisa es tímida y sincera, revelando su carácter reservado y observador.",
      ["images/imagen3.jpg", "images/imagen2.jpg", "images/imagen3.jpg"],
    ),
    Personas(
      3,
      "Ana López",
      "Barcelona",
      "Ingeniera",
      "Ana es una mujer de 30 años, alta y delgada, con una altura de aproximadamente 1,80 metros. Tiene el cabello rubio y lacio, que lleva recogido en una coleta alta. Su rostro es alargado y sus ojos son de un azul intenso, llenos de inteligencia y curiosidad. Su sonrisa es amplia y confiada, reflejando su carácter decidido y ambicioso.",
      ["images/imagen2.jpg", "images/imagen3.jpg", "images/imagen2.jpg"],
    )
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextImage(int index) {
    if (_currentIndex < listPersonas[index].imagenes.length - 1) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
          preferredSize: Size(20, 50),
          child: AppbarAlreadyRegistered(
              namePage: 'home', idPersona: widget.idPersona)),
      body: SafeArea(
        child: SingleChildScrollView(
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
                cardTotalImage(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.left),
                        hoverColor: Colors.red.shade100,
                        splashRadius:
                            28, // Ajusta el radio del efecto splash si es necesario
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (states) => Colors.transparent,
                          ),
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder>(
                            (states) => CircleBorder(
                              side: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.red.shade100;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.green,
                        ),
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.right),
                        hoverColor: Colors.green.shade100,
                        splashRadius: 28,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (states) => Colors.transparent,
                          ),
                          shape:
                              WidgetStateProperty.resolveWith<OutlinedBorder>(
                            (states) => CircleBorder(
                              side: BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                          ),
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(WidgetState.hovered)) {
                                return Colors.green.shade100;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardTotalImage() {
    return Container(
      width: 500,
      height: 1200,
      child: CardSwiper(
        controller: controller,
        isLoop: false,
        scale: 0.6,
        allowedSwipeDirection:
            AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
        cardsCount: listPersonas.length,
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
            cardImage(listPersonas[index], index),
      ),
    );
  }

  Widget cardImage(Personas personas, int index) {
    return Column(
      children: [
        Container(
          width: 500,
          height: 500,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: personas.imagenes.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    personas.imagenes[index], // Ruta de la imagen
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
                        onPressed: () => _nextImage(index),
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
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        personas.nombre,
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
          ),
        ),
        if (isExpanded)
          cardProfileExpanded(
            listPersonas[index].ubicacion,
            listPersonas[index].ocupacion,
            listPersonas[index].descripcion,
          )
      ],
    );
  }

  Widget cardProfileExpanded(
      String ubicacion, String ocupacion, String descripcion) {
    return Container(
      width: 500,
      color: Colors.black,
      child: Column(
        children: [
          cardInformation("Ubicación: ", ubicacion),
          cardInformation("Ocupación: ", ocupacion),
          cardInformation("Descripción: ", descripcion),
        ],
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

class Personas {
  int id;
  String nombre;
  String ubicacion;
  String ocupacion;
  String descripcion;
  List<String> imagenes;

  Personas(this.id, this.nombre, this.ubicacion, this.ocupacion,
      this.descripcion, this.imagenes);
}
