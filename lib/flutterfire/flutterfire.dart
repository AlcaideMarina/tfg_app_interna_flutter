import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/model/client_model.dart';
import 'package:hueveria_nieto_interna/model/products_model.dart';
import 'dart:developer' as developer;

import '../values/firebase_constants.dart';

Future<Map<String, double>?> getEggTypes() async {
  try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(FirebaseConstants.defaultConstantsName)
        .where(FirebaseConstants.defaultConstantsConstantName,
            isEqualTo: FirebaseConstants
                .defaultConstantsMap[DefaultConstantsEnum.eggTypes])
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

Future<int> getNextUserId() async {
  try {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('client_info')
        .orderBy('id')
        .get();

    if (query.docs.isEmpty || !query.docs[query.docs.length - 1].exists) {
      return 0;
    } else {
      QueryDocumentSnapshot lastDocument =
          query.docs[query.docs.length - 1];
      Map<String, dynamic> lastMap =
          query.docs[query.docs.length - 1].data() as Map<String, dynamic>;
      ClientModel clientModel = ClientModel.fromMap(lastMap, lastDocument.id);
      int newId = clientModel.id + 1;
      return newId;
    }
  } catch (e) {
    developer.log('Error - FlutterFire - getNextUserId(): ' + e.toString());
    return -1;
  }
}

Stream<QuerySnapshot<Map<String, dynamic>>> getAllClients() {
  return FirebaseFirestore.instance.collection('client_info').snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getActiveClients() {
  return FirebaseFirestore.instance
      .collection('client_info')
      .where('deleted', isEqualTo: false)
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getDeletedClients() {
  return FirebaseFirestore.instance
      .collection('client_info')
      .where('deleted', isEqualTo: true)
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getActiveInternalUsers() {
  return FirebaseFirestore.instance
      .collection('user_info')
      .where('deleted', isEqualTo: false)
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getDeletedInternalUsers() {
  return FirebaseFirestore.instance
      .collection('user_info')
      .where('deleted', isEqualTo: true)
      .snapshots();
}
