import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

const defaultConstantsName = 'default_constants';
const defaultConstantsConstantName = 'constant_name';

enum DefaultConstantsEnum {
  eggTypes,
}

Map<DefaultConstantsEnum, String> defaultConstantsMap = {
  DefaultConstantsEnum.eggTypes: 'egg_types',
};

Future<Map<String, double>?> getEggTypes() async {
  try {
final databaseReference = FirebaseFirestore.instance;
    dynamic document = await databaseReference
        .collection(defaultConstantsName)
        .where(
          defaultConstantsConstantName, 
          isEqualTo: defaultConstantsMap[DefaultConstantsEnum.eggTypes])
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
