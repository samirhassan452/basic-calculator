import 'package:flutter/cupertino.dart';

class ThemeChanger extends ChangeNotifier {
  bool isDark = false;

  void changeTheme() {
    isDark = !isDark;

    notifyListeners();
  }
}
