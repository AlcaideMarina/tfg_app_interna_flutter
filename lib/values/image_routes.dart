class ImageRoutes {
  static String getRoute(String key) {
    return imageRoutesMap[key] ?? "assets/ic_logo.png";
  }

  static final Map<String, String> imageRoutesMap = {
    'ic_logo': 'assets/ic_logo.png',
    'ic_next_arrow': 'assets/ic_next_arrow.png',
    'ic_right_tic': 'assets/ic_right_tic.png',
    'ic_wrong': 'assets/ic_wrong.png'
  };
}
