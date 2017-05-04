class GraphicDesigner {

  ArrayList<ProbabilityObject> graphicProbabilityDataSet = new ArrayList<ProbabilityObject>();
  String graphicType;

  GraphicDesigner() {
  }

  /* main */
  public StageInfo design(Poster poster) {
    /* create a PGraphics */
    PGraphics designResult;
    designResult = createGraphics(posterWidth, posterHeight);

    initProbabilitySet();
    chooseGraphicType();
    Graphic g = new Graphic(poster, graphicType);
    designResult = g.getResult(); 
    applyGraphicToPoster(designResult, poster);

    /* Apply data to StageInfo */
    String details = "-Graphic Type:\n" + graphicType;
    StageInfo stageInfo = new StageInfo(details, designResult);
    return stageInfo;
  }
  private void initProbabilitySet() {
    graphicProbabilityDataSet.add(new ProbabilityObject("offset", 99));
    graphicProbabilityDataSet.add(new ProbabilityObject("pattern", 0));
  }

  private void chooseGraphicType() {
    graphicType = getRandomByProbabilityObject(graphicProbabilityDataSet).value.toString();
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    poster.content.image(pg, 0, 0);
    poster.content.endDraw();
  }
}