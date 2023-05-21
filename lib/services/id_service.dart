import 'package:flutter/material.dart';

import '../flutterfire/flutterfire.dart';

class IDService extends ChangeNotifier {
  int newId = 0;

  bool isLoading = true;

  IDService() {
    loadNextUserId();
  }

  Future<int?> loadNextUserId() async {
    isLoading = true;
    notifyListeners();

    newId = await getNextUserId();

    isLoading = false;
    notifyListeners();

    return newId;
  }
}