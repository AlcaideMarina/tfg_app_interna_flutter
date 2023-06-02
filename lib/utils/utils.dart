import 'dart:math';

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

  String rolesIntToString(int rolCode) {
    return getKey(Constants().roles, rolCode);
  }

  int rolesStringToInt(String rolStr) {
    return Constants().roles[rolStr] ?? -1;
  }

  String? parseTimestmpToString(Timestamp? timestamp, {String dateFormat = "dd/MM/yyyy"}) {
    if (timestamp == null) {
      return null;
    } else {
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat(dateFormat).format(dateTime);
      return formattedDate;
    }
  }

  Timestamp parseStringToTimestamp(String dateStr, {String dateFormat = 'dd/MM/yyyy'}) {
    return Timestamp.fromDate(DateFormat(dateFormat).parse(dateStr));
  }

  DateTime addToDate(DateTime date, {int daysToAdd = 0, int monthsToAdd = 0, int yearsToAdd = 0}) {
    return DateTime(date.year + yearsToAdd, date.month + monthsToAdd, date.day + daysToAdd, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  double roundDouble(double value, int places){ 
    num mod = pow(10.0, places); 
    return ((value * mod).round().toDouble() / mod); 
  }

}
