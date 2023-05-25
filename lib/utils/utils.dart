import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hueveria_nieto_interna/utils/constants.dart';
import 'package:intl/intl.dart';

class Utils {

  dynamic getKey(Map map, dynamic target) {
    dynamic keys = map.keys;
    for (var k in keys) {
      if (map[k] == target) return k;
    }
    return null;
  }

  int rolesStringToInt(String rolStr) {
    return Constants().roles[rolStr] ?? -1;
  }

  String? parseTimestmpToString(Timestamp? timestamp) {
    if (timestamp == null) {
      return null;
    } else {
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      return formattedDate;
    }
  }

}
