class GraphicDesigner extends Observable {

  GraphicDesigner() {
    //this.addObserver(progressManager.progressWatcher);
  }

  /* main */
  public PGraphics design(Poster poster) {

    /* create a PGraphics */
    PGraphics designResult;
    designResult = createGraphics(poster.w, poster.h);
    /* make graphics */
    makeGraphics(designResult, poster); 
    applyGraphicToPoster(designResult, poster);
    return designResult;
  }

  private void makeGraphics(PGraphics pg, Poster poster) {
    pg.beginDraw();
    pg.noStroke();
    pg.rectMode(CORNER);
    println("Graphic Designer picked background color: " + hex(poster.colorScheme.colors[0]));
    pg.fill(poster.colorScheme.colors[0]);
    pg.rect(0, 0, poster.w, poster.h);
    pg.endDraw();
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    poster.content.image(pg, 0, 0);
    poster.content.endDraw();
  }
}