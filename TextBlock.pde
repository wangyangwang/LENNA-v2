class SText {

  String text;
  int horizontalAlign;
  int verticalAlign;
  String font;
  int textSize;
  float[] rect;


  SText (String _text, float xAnchor, float yAnchor, int maxWidth) {
    text = _text;
    rect = new float[4];
    horizontalAlign = LEFT;
    verticalAlign = TOP;
    textSize = 15;
  }


  void draw() {
  }
}