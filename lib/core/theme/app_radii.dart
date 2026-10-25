import 'package:flutter/painting.dart';

abstract final class AppRadii {
  static const Radius _md = Radius.circular(16);
  static const Radius _lg = Radius.circular(28);
  static const BorderRadius md = BorderRadius.all(_md);
  static const BorderRadius lg = BorderRadius.all(_lg);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius bubbleIn = BorderRadius.only(
    topLeft: Radius.circular(6),
    topRight: _lg,
    bottomLeft: _lg,
    bottomRight: _lg,
  );
  static const BorderRadius bubbleOut = BorderRadius.only(
    topLeft: _lg,
    topRight: Radius.circular(6),
    bottomLeft: _lg,
    bottomRight: _lg,
  );
}
