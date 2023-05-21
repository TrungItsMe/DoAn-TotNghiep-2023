import 'package:fe/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

class SecurityModel with ChangeNotifier {
  late LocalStorage storage;
  late int sttMenu;
  SecurityModel(this.storage) {
    sttMenu = storage.getItem("sttMenu") ?? 1;
  }

  getSttPage() {
    return storage.getItem("sttMenu");
  }

  changeSttMenu(int newSttMenu) {
    storage.setItem("sttMenu", newSttMenu);
    notifyListeners();
  }

  User user = User();
  changeUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}
