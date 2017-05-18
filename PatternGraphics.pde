class PatternGraphics extends Graphics {

  PatternGraphics (Poster poster, Grid myGrid) {
    super(poster, myGrid);
  }

  void initProbabilitySet() {
  }

  void makeDecisions() {
  }

  void design() {
    float canvaswidth = myGrid.w - poster.padding * 2;
    float canvasheight = myGrid.h;

    int xnumber = 5;
    float ellipseSize = canvaswidth / xnumber;

    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(0, yoffset);
    poster.content.pushStyle();
    poster.content.fill(poster.colorScheme.graphicsColor[0]);
    poster.content.noStroke();
    for (int x = poster.padding; x < canvaswidth; x += ellipseSize) {
      for (int y = 0; y < canvasheight; y += ellipseSize) {
        poster.content.ellipseMode(CORNER);
        poster.content.ellipse(x, y, ellipseSize, ellipseSize);
      }
    }
    poster.content.popStyle();
    poster.content.popMatrix();
    poster.content.endDraw();
    String details = "pattern";
    addToDetails(details);
  }
}