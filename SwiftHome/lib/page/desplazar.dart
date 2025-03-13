import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// ScrollBehavior personalizado que permite arrastrar con mouse y touch.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
