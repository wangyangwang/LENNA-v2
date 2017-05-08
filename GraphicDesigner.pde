class GraphicDesigner {

  ArrayList<ProbabilityObject> graphicProbabilityDataSet = new ArrayList<ProbabilityObject>();
  String graphicType;
  Grid myGrid;

  //Main Func
  StageInfo design(Poster poster) {
    addBackgroundColorToPoster(poster);
    myGrid = poster.grids.get( poster.partitionArrangement.get("graphics") );
    PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);

    initProbabilitySet();
    chooseGraphicType();

    String detailsFromGraphics = "Null";

    switch (graphicType) {
    case "offset":
      OffsetGraphics offsetGraphics = new OffsetGraphics(poster, myGrid.w, myGrid.h);
      generatedPGraphics = offsetGraphics.getGraphics();
      detailsFromGraphics = offsetGraphics.details;
      break;

    case "pattern":
      PatternGraphics patternGraphics = new PatternGraphics(poster, myGrid.w, myGrid.h);
      generatedPGraphics = patternGraphics.getGraphics();
      detailsFromGraphics = patternGraphics.details;
      break;

    default:
      generatedPGraphics = empty();
      break;
    }

    applyGraphicToPoster(generatedPGraphics, poster);

    String partitionLoc;
    if (myGrid.index==0) {
      partitionLoc = "Top";
    } else if (myGrid.index==1) {
      partitionLoc = "Bottom";
    } else {
      partitionLoc = null;
    }
    String details = "-Graphic Type:\n" + graphicType + "\n" + "Graphic Partition:\n" + partitionLoc + "\n" + detailsFromGraphics;
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

    if (myGrid.index == 0) {
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


  private PGraphics empty() {
    PGraphics emptyGraphics = createGraphics(myGrid.w, myGrid.h);
    emptyGraphics.beginDraw();
    emptyGraphics.endDraw();
    return emptyGraphics;
  }
}