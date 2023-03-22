import 'package:flutter/material.dart';

import '../flutterfire/flutterfire.dart';

class ProductsService extends ChangeNotifier {
  Map<String, double> products = {};

  bool isLoading = true;

  ProductsService() {
    loadEggTypes();
  }
  // TODO: Hacer fetch de products

  Future<Map<String, double>?> loadEggTypes() async {
    isLoading = true;
    notifyListeners();

    products = await getEggTypes() ?? {};

    isLoading = false;
    notifyListeners();

    return products;
  }
}