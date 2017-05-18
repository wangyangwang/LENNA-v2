class Text {
  String contentType;
  PVector pos;
  int fontSize;
  String content;
  int xAlign, yAlign;
  int w;
  int h;
  color c;
  boolean boundSet, contentSet, alignSet, fontSet;
  boolean underline;
  int lineWidth, lineHeight;
  PFont font;

  Text (String type, int _fontSize) {
    contentType = type;
    fontSize = _fontSize;
  }

  void setBound(int x, int y, int _w, int _h) {
    pos = new PVector(x, y);
    w = _w;
    h = _h;
    boundSet = true;
  }

  void setAlign(int xAlignment, int yAlignment) {
    xAlign = xAlignment;
    yAlign = yAlignment;
    alignSet = true;
  }

  void setContent(String _content) {
    content = _content;
    contentSet = true;
  }

  void setColor(color _c) {
    c = _c;
  }

  void setFont(PFont f) {
    font = f;
    fontSet = true;
  }

  void addLine( int lineW, int lineH ){
      lineWidth = lineW;
      lineHeight = lineH;
      underline = true;
  }

  void drawOn(PGraphics pg) {
    if (boundSet && contentSet && alignSet && fontSet ) {
      pg.beginDraw();
      pg.textFont(font);
      pg.textAlign(xAlign, yAlign);
      pg.textSize(fontSize);
      if (contentType == "headline") {
        pg.strokeCap(SQUARE);
        pg.textLeading(fontSize);
      }
      pg.fill(c);
      pg.text(content, pos.x, pos.y, w, h);
      if(underline){
          pg.pushStyle();
          pg.stroke(c);
          pg.strokeWeight(lineHeight);
          pg.line(pos.x, pos.y, lineWidth + pos.x, pos.y );
          pg.popStyle();
      }
      pg.endDraw();
    } else {
      System.err.println("Text hasn't been set fully");
    }
  }
}
