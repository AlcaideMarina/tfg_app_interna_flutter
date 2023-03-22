import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import '../values/firebase_constants.dart';

Future<Map<String, double>?> getEggTypes() async {
  try {
    final databaseReference = FirebaseFirestore.instance;
    dynamic document = await databaseReference
        .collection(FirebaseConstants.defaultConstantsName)
        .where(
          FirebaseConstants.defaultConstantsConstantName, 
          isEqualTo: FirebaseConstants.defaultConstantsMap[DefaultConstantsEnum.eggTypes])
        .get();

    if (document.docs.isEmpty) {
      return null;
    } else {
      return document.docs[0].id;
    }
  } catch (e) {
    developer.log('Error: ' + e.toString());
    return null;
  }
  
}
