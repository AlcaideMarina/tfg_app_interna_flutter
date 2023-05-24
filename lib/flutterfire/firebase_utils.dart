import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hueveria_nieto_interna/data/models/client_model.dart';
import 'package:hueveria_nieto_interna/data/models/internal_user_model.dart';
import 'dart:developer' as developer;

import '../values/firebase_constants.dart';

class FirebaseUtils {
  static FirebaseUtils? _instance;
  FirebaseUtils._() : super();

  static FirebaseUtils get instance {
    return _instance ??= FirebaseUtils._();
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
        QueryDocumentSnapshot lastDocument = query.docs[query.docs.length - 1];
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

  Future<int> getNextInternalUserId() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('user_info')
          .orderBy('id')
          .get();

      if (query.docs.isEmpty || !query.docs[query.docs.length - 1].exists) {
        return 0;
      } else {
        QueryDocumentSnapshot lastDocument = query.docs[query.docs.length - 1];
        Map<String, dynamic> lastMap =
            query.docs[query.docs.length - 1].data() as Map<String, dynamic>;
        InternalUserModel internalUserModel = InternalUserModel.fromMap(lastMap, lastDocument.id);
        int newId = internalUserModel.id + 1;
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getClients() {
    return FirebaseFirestore.instance
        .collection('client_info')
        .orderBy('id')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getInternalUsers() {
    return FirebaseFirestore.instance
        .collection('user_info')
        .orderBy('id')
        .snapshots();
  }

  Future<bool> updateClient(ClientModel clientModel) async {
    try {
      Map<Object, Object?> dataMap = clientModel.toMap();
      await FirebaseFirestore.instance
          .collection('client_info')
          .doc(clientModel.documentId)
          .update(dataMap);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> createAuthAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return userCredential.user!.uid;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getClientWithDocId(
      String documentId) {
    return FirebaseFirestore.instance
        .collection('client_info')
        .doc(documentId)
        .snapshots();
  }

  Future<bool> createInternalUser(InternalUserModel internalUserModel) async {
    try {
      await FirebaseFirestore.instance
        .collection("user_info")
        .add(internalUserModel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDocument(String collection, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update(
            {'deleted': true}
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDocumentsFromCollection(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders(String clientDocumentId) {
    return FirebaseFirestore.instance
        .collection("client_info")
        .doc(clientDocumentId)
        .collection("orders")
        .snapshots();
  }
}
