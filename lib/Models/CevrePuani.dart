import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CevrePuani with ChangeNotifier, DiagnosticableTreeMixin {
  int _cevrePuani = 0;
  int get cevrePuani => _cevrePuani;

  void equals(int value) {
    _cevrePuani = value;
    notifyListeners();
  }
  void incDesc(int value){
    _cevrePuani += value;
    notifyListeners();
  }

  /// Makes `CevrePuani` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', cevrePuani));
  }

}