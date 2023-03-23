import 'package:flutter/material.dart';

import '../flutterfire/flutterfire.dart';

class IDService extends ChangeNotifier {
  String newId = '';

  bool isLoading = true;

  IDService() {
    loadNextUserId();
  }

  Future<String?> loadNextUserId() async {
    isLoading = true;
    notifyListeners();

    newId = await getNextUserId();

    isLoading = false;
    notifyListeners();

    return newId;
  }
}