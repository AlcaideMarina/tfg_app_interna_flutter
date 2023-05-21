class Utils {

  dynamic getKey(Map map, dynamic target) {
    dynamic keys = map.keys;
    for (var k in keys) {
      if (map[k] == target) return k;
    }
    return null;
  }

}