class Graphic {

  PGraphics g = createGraphics(posterWidth, posterHeight);
  Graphic (Poster poster, String type) {
    switch (type) {
    case "offset":
      g = offset(poster);
      break;

    case "pattern":
      g = pattern(poster);
      break;

    default:
      g = empty(poster);
      break;
    }
  }

  public PGraphics getResult() {
    return g;
  }

  ///////////////////////////////////
  //ALL TYPES OF GRAPHICS

  private PGraphics offset(Poster poster) {
    g.beginDraw();
    g.background(poster.colorScheme.colors[0]);
    g.noStroke();
    g.blendMode(MULTIPLY);
    g.fill(poster.colorScheme.graphicsColor[0]);
    g.ellipse(g.width/2 - posterHeight/10, g.height/2, g.width/3, g.width/3);
    g.fill(poster.colorScheme.graphicsColor[1]);
    g.ellipse(g.width/2 + posterHeight/10, g.height/2, g.width/3, g.width/3);
    g.endDraw();
    return g;
  }  
  private PGraphics pattern(Poster poster) {
    g.beginDraw();
    g.endDraw();
    return g;
  }  
  private PGraphics empty(Poster poster) {
    g.beginDraw();
    g.endDraw();
    return g;
  }
}