class Type {
  
  String text;
  int horizontalAlign;
  int verticalAlign;
  String font;
  int textSize;
  float[] rect;
  
  
  Type (String _text) {
    text = _text;
    rect = new float[4];
    horizontalAlign = LEFT;
    verticalAlign = TOP;
    textSize = 15;
  }
  
  
  void draw() {
    textAlign(horizontalAlign, verticalAlign);
    
  }
  
  
  
}