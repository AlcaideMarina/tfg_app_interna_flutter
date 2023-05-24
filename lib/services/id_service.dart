import 'package:flutter/material.dart';

import '../flutterfire/firebase_utils.dart';

class IDService extends ChangeNotifier {
  int newId = 0;

  bool isLoading = true;

  IDService() {
    loadNextUserId();
  }

  Future<int?> loadNextUserId() async {
    isLoading = true;
    notifyListeners();

    newId = await FirebaseUtils.instance.getNextUserId();

    isLoading = false;
    notifyListeners();

    return newId;
  }
}