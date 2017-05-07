class GraphicDesigner {

  ArrayList<ProbabilityObject> graphicProbabilityDataSet = new ArrayList<ProbabilityObject>();
  String graphicType;
  Grid myGrid;

  //Main Func
  public StageInfo design(Poster poster) {
    addBackgroundColorToPoster(poster);

    for (Grid g : poster.grids) {
      if (g.contentType == "graphics")myGrid = g;
    }

    PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);

    initProbabilitySet();
    chooseGraphicType();

    Graphic g = new Graphic(poster, graphicType, myGrid);
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

    if (myGrid.index==0) {
      poster.content.image(pg, 0, 0);
    } else {
      poster.content.image(pg, 0, poster.grids.get(0).h);
    }

    poster.content.endDraw();
  }

  void addBackgroundColorToPoster(Poster poster) {
    poster.content.beginDraw();
    poster.content.background(poster.colorScheme.backgroundColor);
    poster.content.endDraw();
  }
}