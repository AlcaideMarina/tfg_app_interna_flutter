import 'package:hueveria_nieto_interna/utils/constants.dart';

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

}
