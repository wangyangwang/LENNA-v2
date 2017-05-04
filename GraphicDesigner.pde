class GraphicDesigner {

  GraphicDesigner() {
  }

  /* main */
  public StageInfo design(Poster poster) {
    /* create a PGraphics */
    PGraphics designResult;
    designResult = createGraphics(posterWidth, posterHeight);
    /* make graphics */
    makeGraphics(designResult, poster); 
    applyGraphicToPoster(designResult, poster);

    /* Apply data to StageInfo */
    String details = "[placeholder] Type: Pattern Graphics\nGraphics: Type A";
    StageInfo stageInfo = new StageInfo(details, designResult);
    return stageInfo;
  }

  private void makeGraphics(PGraphics pg, Poster poster) {
    pg.beginDraw();
    pg.noStroke();
    pg.rectMode(CORNER);
    pg.fill(poster.colorScheme.colors[0]);
    pg.rect(0, 0, posterWidth, posterHeight);
    pg.endDraw();
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    poster.content.image(pg, 0, 0);
    poster.content.endDraw();
  }
}