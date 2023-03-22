import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/model/products_model.dart';
import 'dart:developer' as developer;

import '../values/firebase_constants.dart';

Future<Map<String, double>?> getEggTypes() async {
  try {
    final databaseReference = FirebaseFirestore.instance;
    QuerySnapshot query = await databaseReference
        .collection(FirebaseConstants.defaultConstantsName)
        .where(
          FirebaseConstants.defaultConstantsConstantName, 
          isEqualTo: FirebaseConstants.defaultConstantsMap[DefaultConstantsEnum.eggTypes])
        .get();

    if (query.docs.isEmpty || !query.docs[0].exists) {
      return null;
    } else {
      Map<String, dynamic> data = query.docs[0].data() as Map<String, dynamic>;
      ProductsModel productsModel = ProductsModel.fromMap(data);

      return productsModel.values;
    }
  } catch (e) {
    developer.log('Error - FlutterFire - getEggTypes(): ' + e.toString());
    return null;
  }
  
}
