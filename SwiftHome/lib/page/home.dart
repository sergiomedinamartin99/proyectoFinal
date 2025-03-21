import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swifthome/api/constants.dart';
import 'package:swifthome/api/network/network_insert_data.dart';
import 'package:swifthome/api/network/network_profile.dart';
import 'package:swifthome/page/registration_step_third.dart';
import 'package:swifthome/widget/appbar_already_registered.dart';
import 'package:swifthome/widget/roomswipeheader.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.idPersona,
      required this.buscandoPiso,
      required this.isAdmin});
  final int idPersona;
  final bool buscandoPiso;
  final bool isAdmin;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardSwiperController controller = CardSwiperController();
  List<PersonasBuscador> listPersonasBuscador = [];
  List<PersonasPropietario> listPersonasPropietario = [];
  int indexCurrent = 2;
  bool checkUploadedData = false;
  bool noMoreCards = false;

  @override
  void initState() {
    super.initState();
    print("ELLLL VALORRRR ESSSSSSSSSSSS ${widget.buscandoPiso}");
    obtenerUserRoomSwipe(widget.idPersona.toString()).then(
      (value) {
        if (value != null && value['status'] == 1) {
          Map<String, dynamic> perfiles = value['perfil'];
          if (widget.buscandoPiso) {
            perfiles.forEach((key, perfil) {
              listPersonasPropietario.add(
                PersonasPropietario(
                  perfil['id'],
                  perfil['nombre'],
                  perfil['apellidos'],
                  perfil['fechaNacimiento'],
                  perfil['genero'],
                  perfil['ubicacion'],
                  perfil['precio'],
                  perfil['descripcionVivienda'],
                  perfil['imagenes'],
                ),
              );
            });
          } else {
            perfiles.forEach((key, perfil) {
              listPersonasBuscador.add(
                PersonasBuscador(
                  perfil['id'],
                  perfil['nombre'],
                  perfil['apellidos'],
                  perfil['fechaNacimiento'],
                  perfil['genero'],
                  perfil['ubicacion'],
                  perfil['ocupacion'],
                  perfil['biografia'],
                  perfil['imagenes'],
                ),
              );

              print("UWWWWWWWWWWWWWU");
              print(listPersonasPropietario);
            });
          }
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
      'La tarjeta $previousIndex se deslizó hacia ${direction.name}. Ahora la tarjeta $currentIndex está en la parte superior',
    );

    // Usar la lista correcta según widget.buscandoPiso:
    final targetId = widget.buscandoPiso
        ? listPersonasPropietario[previousIndex].id.toString()
        : listPersonasBuscador[previousIndex].id.toString();

    Map<String, dynamic>? comprobar = await insertarLikeDislike(
      widget.idPersona.toString(),
      targetId,
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
          buscandoPiso: widget.buscandoPiso,
          isAdmin: widget.isAdmin,
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
                : widget.buscandoPiso
                    ? listPersonasPropietario.isEmpty || noMoreCards
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
                              RoomSwipeHeader(),
                              cardPadre(),
                              // BOTONES HAY QUE VERLO
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () => controller
                                          .swipe(CardSwiperDirection.left),
                                      hoverColor: Colors.red.shade100,
                                      splashRadius: 28,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (states) => Colors.transparent),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (states) => const CircleBorder(
                                            side: BorderSide(
                                              color: Colors.red,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>((states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
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
                                        controller
                                            .swipe(CardSwiperDirection.right);

                                        print("El valor de $indexCurrent");
                                      },
                                      hoverColor: Colors.green.shade100,
                                      splashRadius: 28,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (states) => Colors.transparent),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (states) => const CircleBorder(
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>((states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
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
                          )
                    : listPersonasBuscador.isEmpty || noMoreCards
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
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () => controller
                                          .swipe(CardSwiperDirection.left),
                                      hoverColor: Colors.red.shade100,
                                      splashRadius: 28,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (states) => Colors.transparent),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (states) => const CircleBorder(
                                            side: BorderSide(
                                              color: Colors.red,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>((states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
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
                                        controller
                                            .swipe(CardSwiperDirection.right);

                                        print("El valor de $indexCurrent");
                                      },
                                      hoverColor: Colors.green.shade100,
                                      splashRadius: 28,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (states) => Colors.transparent),
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>(
                                          (states) => const CircleBorder(
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>((states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
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
                          )),
      ),
    );
  }

  /// Contenedor del CardSwiper con dimensiones 500x700
  Widget cardPadre() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
            numberOfCardsDisplayed: widget.buscandoPiso
                ? listPersonasPropietario.length > 1
                    ? 2
                    : 1
                : listPersonasBuscador.length > 1
                    ? 2
                    : 1,
            allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                vertical: false, horizontal: true),
            cardsCount: widget.buscandoPiso
                ? listPersonasPropietario.length
                : listPersonasBuscador.length,
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) =>
                    widget.buscandoPiso
                        ? PersonaCardPropietario(
                            personasPropietario: listPersonasPropietario[index])
                        : PersonaCardBuscador(
                            personasBuscador: listPersonasBuscador[index]),
          ),
        ),
      ),
    );
  }
}

class PersonaCardBuscador extends StatefulWidget {
  final PersonasBuscador personasBuscador;

  const PersonaCardBuscador({Key? key, required this.personasBuscador})
      : super(key: key);

  @override
  _PersonaCardBuscadorState createState() => _PersonaCardBuscadorState();
}

class _PersonaCardBuscadorState extends State<PersonaCardBuscador>
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
    if (_currentIndex < widget.personasBuscador.imagenes.length - 1) {
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
  Widget buildLineIndicator() {
    int totalImages = widget.personasBuscador.imagenes.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalImages, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              height: 4.0,
              decoration: BoxDecoration(
                color: index == _currentIndex ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
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
            itemCount: widget.personasBuscador.imagenes.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isExpanded ? Radius.zero : Radius.circular(12),
                    bottomRight:
                        isExpanded ? Radius.zero : Radius.circular(12)),
                child: Image.memory(
                  base64Decode(
                      widget.personasBuscador.imagenes[index]['datos']),
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
          // Flecha izquierda: se muestra si no es la primera imagen
          if (_currentIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Align(
                alignment:
                    Alignment.centerLeft, // O alignment: Alignment.center
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 30),
                    onPressed: _prevImage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ),

          if (_currentIndex < widget.personasBuscador.imagenes.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 30),
                    onPressed: _nextImage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          // Indicador de páginas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: buildLineIndicator(),
          ),
        ],
      ),
    );
  }

  /// Contenido cuando la tarjeta está "colapsada": solo se muestra la imagen
  Widget buildCollapsedContent() {
    final int edad = calcularEdad(widget.personasBuscador.fechaNacimiento);
    final String edadTexto = edad == 0 ? "N/A" : '$edad';

    return Stack(
      children: [
        // 1. Carrusel de imágenes
        buildImageCarousel(),

        // 2. Degradado oscuro en la parte inferior
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Contenido (texto) encima del degradado
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre, apellidos y edad
              Text(
                '${widget.personasBuscador.nombre} '
                '${widget.personasBuscador.apellidos}, '
                '$edadTexto',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24, // tamaño grande estilo Tinder
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Ubicación o distancia
              Text(
                "Ubicación: ${widget.personasBuscador.ubicacion}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Contenido expandido: se muestra la imagen (con alto fijo) y el contenido textual
  Widget buildExpandedContent() {
    final int edad = calcularEdad(widget.personasBuscador.fechaNacimiento);
    final String edadTexto = edad == 0 ? "N/A" : '$edad';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageCarousel(height: 300),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Datos personales",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.grey, thickness: 1, height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nombre completo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${widget.personasBuscador.nombre} "
                              "${widget.personasBuscador.apellidos}",
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Género",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(widget.personasBuscador.genero),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Edad",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${edadTexto} años"),
                            SizedBox(height: 8),
                            Text(
                              "Ubicación",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Expanded(
                                  child:
                                      Text(widget.personasBuscador.ubicacion),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Información del usuario",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.grey, thickness: 1, height: 20),
                Text(
                  "Ocupación",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.work, color: Colors.black, size: 18),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(widget.personasBuscador.ocupacion),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Biografía",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.personasBuscador.biografia),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isHoverButtonExpand = false;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Contenido expandido o colapsado
          Positioned.fill(
            child:
                isExpanded ? buildExpandedContent() : buildCollapsedContent(),
          ),

          // Indicador en la parte superior (a modo "Tinder")
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: buildLineIndicator(),
          ),

          // Botón de expandir/contraer
          Positioned(
            bottom: 16,
            right: 16,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHoverButtonExpand = true),
              onExit: (_) => setState(() => _isHoverButtonExpand = false),
              child: AnimatedScale(
                scale:
                    _isHoverButtonExpand ? 1.2 : 1.0, // Escala al hacer hover
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(), // Asegura la forma circular
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Icon(
                    isExpanded ? Icons.expand_more : Icons.expand_less,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Tarjeta de cada persona con funcionalidad de "expandir" para mostrar
/// tanto la imagen como el contenido textual en un scroll.
class PersonaCardPropietario extends StatefulWidget {
  final PersonasPropietario personasPropietario;

  const PersonaCardPropietario({Key? key, required this.personasPropietario})
      : super(key: key);

  @override
  _PersonaCardPropietarioState createState() => _PersonaCardPropietarioState();
}

class _PersonaCardPropietarioState extends State<PersonaCardPropietario>
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
    if (_currentIndex < widget.personasPropietario.imagenes.length - 1) {
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
  Widget buildLineIndicator() {
    int totalImages = widget.personasPropietario.imagenes.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalImages, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              height: 4.0,
              decoration: BoxDecoration(
                color: index == _currentIndex ? Colors.white : Colors.white54,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
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
            itemCount: widget.personasPropietario.imagenes.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isExpanded ? Radius.zero : Radius.circular(12),
                    bottomRight:
                        isExpanded ? Radius.zero : Radius.circular(12)),
                child: Image.memory(
                  base64Decode(
                      widget.personasPropietario.imagenes[index]['datos']),
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
          // Flecha izquierda: se muestra si no es la primera imagen
          if (_currentIndex > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Align(
                alignment:
                    Alignment.centerLeft, // O alignment: Alignment.center
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 30),
                    onPressed: _prevImage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ),

          if (_currentIndex < widget.personasPropietario.imagenes.length - 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 30),
                    onPressed: _nextImage,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          // Indicador de páginas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: buildLineIndicator(),
          ),
        ],
      ),
    );
  }

  /// Contenido cuando la tarjeta está "colapsada": solo se muestra la imagen
  Widget buildCollapsedContent() {
    final int edad = calcularEdad(widget.personasPropietario.fechaNacimiento);
    final String edadTexto = edad == 0 ? "N/A" : '$edad';

    return Stack(
      children: [
        // 1. Carrusel de imágenes
        buildImageCarousel(),

        // 2. Degradado oscuro en la parte inferior
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Contenido encima del degradado
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y edad
              Text(
                '${widget.personasPropietario.nombre} '
                '${widget.personasPropietario.apellidos}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '${double.parse(widget.personasPropietario.precio).toStringAsFixed(0)}€ / mes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Ubicación o distancia
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.personasPropietario.ubicacion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildExpandedContent() {
    final int edad = calcularEdad(widget.personasPropietario.fechaNacimiento);
    final String edadTexto = edad == 0 ? "N/A" : '$edad';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageCarousel(height: 300),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Datos personales",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.grey, thickness: 1, height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nombre completo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${widget.personasPropietario.nombre} "
                              "${widget.personasPropietario.apellidos}",
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Género",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person,
                                    color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Expanded(
                                  child:
                                      Text(widget.personasPropietario.genero),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Edad",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${edadTexto} años"),
                            SizedBox(height: 8),
                            Text(
                              "Ubicación",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                      widget.personasPropietario.ubicacion),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Información de la vivienda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.grey, thickness: 1, height: 20),
                Text(
                  "Precio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    '${double.parse(widget.personasPropietario.precio).toStringAsFixed(2)}€ / mes'),
                const SizedBox(height: 8),
                Text(
                  "Descripción",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.personasPropietario.descripcionVivienda),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isHoverButtonExpand = false;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Contenido expandido o colapsado
          Positioned.fill(
            child:
                isExpanded ? buildExpandedContent() : buildCollapsedContent(),
          ),

          // Indicador en la parte superior (a modo "Tinder")
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: buildLineIndicator(),
          ),

          // Botón de expandir/contraer
          Positioned(
            bottom: 16,
            right: 16,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHoverButtonExpand = true),
              onExit: (_) => setState(() => _isHoverButtonExpand = false),
              child: AnimatedScale(
                scale:
                    _isHoverButtonExpand ? 1.2 : 1.0, // Escala al hacer hover
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(), // Asegura la forma circular
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Icon(
                    isExpanded ? Icons.expand_more : Icons.expand_less,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

int calcularEdad(String fechaNacimiento) {
  try {
    final partes = fechaNacimiento.split('-');
    if (partes.length == 3) {
      final year = int.parse(partes[0]);
      final month = int.parse(partes[1]);
      final day = int.parse(partes[2]);
      final birthDate = DateTime(year, month, day);

      final hoy = DateTime.now();
      int edad = hoy.year - birthDate.year;

      // Ajuste si aún no ha cumplido años en el mes/día actual
      if (hoy.month < birthDate.month ||
          (hoy.month == birthDate.month && hoy.day < birthDate.day)) {
        edad--;
      }
      return edad;
    }
  } catch (e) {
    // Manejo de error si la fecha no está en el formato esperado
    debugPrint("Error al calcular edad: $e");
  }
  return 0; // Por defecto, si algo falla
}

Future<Map<String, dynamic>?> obtenerUserRoomSwipe(String perfilId) async {
  String url = '${ClassConstant.ipBaseDatos}${ClassConstant.urlUserRoomSwipe}';
  final id = {'idUsuario': perfilId};
  NetworkProfile network = NetworkProfile(url, id);
  return network.fetchProfile();
}

Future<Map<String, dynamic>?> insertarLikeDislike(
  String idUsuario1,
  String idUsuario2,
  String tipoIteracion,
) {
  String url =
      '${ClassConstant.ipBaseDatos}${ClassConstant.urlLikeDislikeMatch}';
  final userLikeDislike = {
    'idUsuario1': idUsuario1,
    'idUsuario2': idUsuario2,
    'tipoIteracion': tipoIteracion,
  };

  NetworkInsertData network = NetworkInsertData(url, userLikeDislike);
  return network.fetchData();
}

class PersonasBuscador {
  int id;
  String nombre;
  String apellidos;
  String fechaNacimiento;
  String genero;
  String ubicacion;
  String ocupacion;
  String biografia;
  List<dynamic> imagenes;

  PersonasBuscador(
      this.id,
      this.nombre,
      this.apellidos,
      this.fechaNacimiento,
      this.genero,
      this.ubicacion,
      this.ocupacion,
      this.biografia,
      this.imagenes);
}

class PersonasPropietario {
  int id;
  String nombre;
  String apellidos;
  String fechaNacimiento;
  String genero;
  String ubicacion;
  String precio;
  String descripcionVivienda;
  List<dynamic> imagenes;
  PersonasPropietario(
      this.id,
      this.nombre,
      this.apellidos,
      this.fechaNacimiento,
      this.genero,
      this.ubicacion,
      this.precio,
      this.descripcionVivienda,
      this.imagenes);
}
