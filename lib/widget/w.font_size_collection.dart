class FontSizeCollection {
  static final FontSizeCollection _instance = FontSizeCollection._internal();

  factory FontSizeCollection() {
    return _instance;
  }

  FontSizeCollection._internal();

  double get buttonFontSize => 18.0;
  double get buttonSize => 40.0;
  double get settinFontSize => 18.0;
  double get subjectFontSize => 28.0;
}
