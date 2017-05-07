class GraphicDesigner {

  ArrayList<ProbabilityObject> graphicProbabilityDataSet = new ArrayList<ProbabilityObject>();
  String graphicType;


  //Main Func
  public StageInfo design(Poster poster) {
    PGraphics generatedPGraphics = createGraphics(posterWidth, posterHeight);

    initProbabilitySet();
    chooseGraphicType();

    addBackgroundColorToPoster(poster);


    Graphic g = new Graphic(poster, graphicType);
    generatedPGraphics = g.getResult(); 

    applyGraphicToPoster(generatedPGraphics, poster);

    /* Apply data to StageInfo */
    String details = "-Graphic Type:\n" + graphicType + "\n" + g.details;
    StageInfo stageInfo = new StageInfo(details, generatedPGraphics);
    return stageInfo;
  }

  private void initProbabilitySet() {
    graphicProbabilityDataSet.add(new ProbabilityObject("offset", 0));
    graphicProbabilityDataSet.add(new ProbabilityObject("pattern", 100));
    graphicProbabilityDataSet.add(new ProbabilityObject("empty", 0));
  }

  private void chooseGraphicType() {
    graphicType = getObjectByProbability(graphicProbabilityDataSet).value.toString();
  }



  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    poster.content.image(pg, 0, 0);
    poster.content.endDraw();
  }

  void addBackgroundColorToPoster(Poster poster) {
    poster.content.beginDraw();
    poster.content.background(poster.colorScheme.backgroundColor);
    poster.content.endDraw();
  }
}