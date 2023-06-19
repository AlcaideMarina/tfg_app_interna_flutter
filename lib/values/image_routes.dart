class ImageRoutes {
  static String getRoute(String key) {
    return imageRoutesMap[key] ?? "assets/ic_logo.png";
  }

  static final Map<String, String> imageRoutesMap = {
    'ic_logo': 'assets/ic_new_logo.png',
    'ic_next_arrow': 'assets/ic_next_arrow.png',
    'ic_right_tic': 'assets/ic_right_tic.png',
    'ic_wrong': 'assets/ic_wrong.png',
    'ic_economy': 'assets/ic_economy.png',
    'ic_farm': 'assets/ic_farm.png',
    'ic_home': 'assets/ic_home.png',
    'ic_material': 'assets/ic_material.png',
    'ic_orders': 'assets/ic_orders.png',
    'ic_users': 'assets/ic_users.png',
    'ic_logout': 'assets/ic_logout.png',
    'ic_settings': 'assets/ic_settings.png',
  };
}
