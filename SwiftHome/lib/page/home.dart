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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
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
                              MaterialStateProperty.resolveWith<Color?>(
                            (states) => Colors.transparent,
                          ),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (states) => CircleBorder(
                              side: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.red.shade100;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 32), // Espacio entre botones
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
                              MaterialStateProperty.resolveWith<Color?>(
                            (states) => Colors.transparent,
                          ),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (states) => CircleBorder(
                              side: BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.hovered)) {
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
      height: 700, // Ajusta la altura según tus necesidades
      child: CardSwiper(
        controller: controller,
        isLoop: false,
        scale: 0.95,
        allowedSwipeDirection:
            AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
        cardsCount: listPersonas.length,
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
            PersonaCard(persona: listPersonas[index]),
      ),
    );
  }
}

class PersonaCard extends StatefulWidget {
  final Personas persona;

  PersonaCard({required this.persona});

  @override
  _PersonaCardState createState() => _PersonaCardState();
}

class _PersonaCardState extends State<PersonaCard>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextImage() {
    if (_currentIndex < widget.persona.imagenes.length - 1) {
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Método para construir los puntos del indicador
  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.persona.imagenes.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentIndex == index ? 12.0 : 8.0,
          height: _currentIndex == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.white : Colors.white54,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: 500,
        height: isExpanded ? 700 : 500, // Ajusta la altura según el estado
        child: Column(
          children: [
            // Indicador de Puntos arriba de las imágenes
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: buildPageIndicator(),
            ),
            // Card de Imagen
            Expanded(
              flex: isExpanded ? 2 : 1,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.persona.imagenes.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.persona.imagenes[index],
                        fit: BoxFit.cover,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  // Botones de navegación de imágenes
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: _prevImage,
                      color: Colors.black45,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward,
                          color: Colors.white, size: 30),
                      onPressed: _nextImage,
                      color: Colors.black45,
                    ),
                  ),
                  // Botón para expandir/contraer
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card de Texto
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? 200 : 0,
              child: isExpanded
                  ? SingleChildScrollView(
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.persona.nombre,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Ubicación: ${widget.persona.ubicacion}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Ocupación: ${widget.persona.ocupacion}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Descripción:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.persona.descripcion,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
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
