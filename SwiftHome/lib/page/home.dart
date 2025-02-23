import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_insert_data.dart';
import 'package:swifthome/api/network/network_profile.dart';
import 'package:swifthome/page/registration_step_third.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.idPersona});
  final int idPersona;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  List<Personas> listPersonas = [];
  int indexCurrent = 2;
  bool checkUploadedData = false;
  bool noMoreCards = false;
  @override
  void initState() {
    super.initState();
    obtenerUserRoomSwipe(widget.idPersona.toString()).then(
      (value) {
        if (value != null && value['status'] == 1) {
          Map<String, dynamic> perfiles = value['perfil'];
          perfiles.forEach((key, perfil) {
            listPersonas.add(Personas(
                perfil['id'],
                perfil['nombre'],
                perfil['apellidos'],
                perfil['precio'],
                perfil['descripcionVivienda'],
                perfil['imagenes']));
          });
          checkUploadedData = true;
        } else if (value != null && value['status'] == 2) {
          checkUploadedData = true;
        } else {
          checkUploadedData = false;
        }
        setState(() {});
      },
    );
  }

  Future<bool> onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    Map<String, dynamic>? comprobar = await insertarLikeDislike(
      widget.idPersona.toString(),
      listPersonas[previousIndex].id.toString(),
      direction == CardSwiperDirection.left ? '0' : '1',
    );
    if (comprobar != null && comprobar['status'] == 1) {
      debugPrint("Se ha insertado correctamente");
    } else {
      debugPrint("Error al dar like/dislike");
      mostrarSnackBar(context, "Error al dar like/dislike");
    }

    return true;
  }

  Future<bool> onEnd(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppbarAlreadyRegistered(
          namePage: 'home',
          idPersona: widget.idPersona,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: !checkUploadedData
              ? Column(
                  children: [
                    Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.black,
                    ),
                    Text(
                      'Error al cargar datos',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              : listPersonas.isEmpty || noMoreCards
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          size: 100,
                          color: Colors.black,
                        ),
                        Text(
                          "Ya no quedan mas perfiles en tu area",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "RoomSwipe: Encuentra tu compañero ideal",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        cardPadre(),
                        // BOTONES HAY QUE VERLO
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.left),
                                hoverColor: Colors.red.shade100,
                                splashRadius: 28,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) => Colors.transparent),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>(
                                    (states) => const CircleBorder(
                                      side: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.red.shade100;
                                    }
                                    return null;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 32),
                              IconButton(
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.green),
                                onPressed: () {
                                  controller.swipe(CardSwiperDirection.right);

                                  print("El valor de $indexCurrent");
                                },
                                hoverColor: Colors.green.shade100,
                                splashRadius: 28,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) => Colors.transparent),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>(
                                    (states) => const CircleBorder(
                                      side: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.green.shade100;
                                    }
                                    return null;
                                  }),
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

  /// Contenedor del CardSwiper con dimensiones 500x700
  Widget cardPadre() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      width: 400,
      height: 667,
      child: CardSwiper(
        controller: controller,
        isLoop: false,
        scale: 0.7,
        onSwipe: onSwipe,
        onEnd: () {
          setState(() {
            noMoreCards = true;
          });
        },
        padding: EdgeInsets.zero,
        numberOfCardsDisplayed: listPersonas.length > 1 ? 2 : 1,
        allowedSwipeDirection:
            AllowedSwipeDirection.symmetric(vertical: false, horizontal: true),
        cardsCount: listPersonas.length,
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
            PersonaCard(persona: listPersonas[index]),
      ),
    );
  }
}

/// Tarjeta de cada persona con funcionalidad de "expandir" para mostrar
/// tanto la imagen como el contenido textual en un scroll.
class PersonaCard extends StatefulWidget {
  final Personas persona;

  const PersonaCard({Key? key, required this.persona}) : super(key: key);

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
        duration: const Duration(milliseconds: 500),
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Indicador de páginas para el carrusel de imágenes
  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.persona.imagenes.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
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

  /// Widget que construye el carrusel de imágenes con flechas de navegación.
  /// Si se especifica [height], se utiliza ese alto; de lo contrario, se adapta.
  Widget buildImageCarousel({double? height}) {
    return Container(
      height: height, // si es null, ocupará el espacio disponible
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.persona.imagenes.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isExpanded ? Radius.zero : Radius.circular(12),
                    bottomRight:
                        isExpanded ? Radius.zero : Radius.circular(12)),
                child: Image.memory(
                  base64Decode(widget.persona.imagenes[index]['datos']),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  gaplessPlayback: true,
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          // Flecha izquierda
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: _prevImage,
            ),
          ),
          // Flecha derecha
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.white, size: 30),
              onPressed: _nextImage,
            ),
          ),
          // Indicador de páginas
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: buildPageIndicator(),
          ),
        ],
      ),
    );
  }

  /// Contenido cuando la tarjeta está "colapsada": solo se muestra la imagen
  Widget buildCollapsedContent() {
    return buildImageCarousel();
  }

  /// Contenido expandido: se muestra la imagen (con alto fijo) y el contenido textual
  Widget buildExpandedContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrusel de imágenes con alto fijo
          buildImageCarousel(height: 300),
          // Contenido textual
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.persona.nombre,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ubicación: ${widget.persona.ubicacion}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ocupación: ${widget.persona.ocupacion}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Descripción:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.persona.descripcion,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Dependiendo del estado, se muestra el contenido expandido o solo la imagen
          Positioned.fill(
            child:
                isExpanded ? buildExpandedContent() : buildCollapsedContent(),
          ),
          // Botón de expandir/contraer en la esquina inferior derecha
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
    );
  }
}

Future<Map<String, dynamic>?> obtenerUserRoomSwipe(String perfilId) async {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlUserRoomSwipe}';
  final id = {'idUsuario': perfilId};
  NetworkProfile network = NetworkProfile(url, id);
  return network.fetchProfile();
}

Future<Map<String, dynamic>?> insertarLikeDislike(
  String idUsuario,
  String idPropietario,
  String tipoIteracion,
) {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlLikeDislikeBuscador}';
  final userLikeDislike = {
    'idUsuario': idUsuario,
    'idPropietario': idPropietario,
    'tipoIteracion': tipoIteracion,
  };

  NetworkInsertData network = NetworkInsertData(url, userLikeDislike);
  return network.fetchData();
}

class Personas {
  int id;
  String nombre;
  String ubicacion;
  String ocupacion;
  String descripcion;
  List<dynamic> imagenes;

  Personas(this.id, this.nombre, this.ubicacion, this.ocupacion,
      this.descripcion, this.imagenes);
}

class Usuario {
  final int id;
  final String nombre;
  final String apellidos;
  final String precio;
  final String descripcionVivienda;
  final List<Imagen> imagenes;
  Usuario(this.id, this.nombre, this.apellidos, this.precio,
      this.descripcionVivienda, this.imagenes);
}
