class FontSizeCollection {
  static final FontSizeCollection _instance = FontSizeCollection._internal();

  factory FontSizeCollection() {
    return _instance;
  }

  FontSizeCollection._internal();

  double get buttonFontSize => 18.0;
}
