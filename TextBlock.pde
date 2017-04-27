class TextBlock {
  
  String text;
  int horizontalAlign;
  int verticalAlign;
  String font;
  int textSize;
  float[] rect;
  
  
  TextBlock (String _text) {
    text = _text;
    rect = new float[4];
    horizontalAlign = LEFT;
    verticalAlign = TOP;
    textSize = 15;
  }
  
  
  void draw() {
    
    
  }
  
  
  
}