class PatternGraphics extends Graphics {

  PatternGraphics (Poster poster, int _w, int _h) {
   super(poster, _w, _h);
  }

  void initProbabilitySet() {

  }

  void makeDecisions() {

  }

  void design() {
    graphics.beginDraw();
    int size = min(graphics.width/2, graphics.height/2);
    graphics.noStroke();
  	graphics.ellipse(graphics.width/2, graphics.height/2, size, size);
  	graphics.endDraw();
  }
}
