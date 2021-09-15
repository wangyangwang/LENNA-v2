class GraphicDesigner {
  String graphicType;
  Grid myGrid;

  StageInfo design(Poster poster) {
    addBackgroundColorToPoster(poster);
    myGrid = poster.grids.get( poster.partitionArrangement.get("graphics") );
    print("Init grid background...");
    //PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);
    chooseGraphicType();
    String detailsFromGraphics = "";

    print("Creating graphics...\n");
    switch (graphicType) {
    case "offset":
      OffsetGraphics offsetGraphics = new OffsetGraphics(poster, myGrid);
      //generatedPGraphics = offsetGraphics.getGraphics();
      detailsFromGraphics = offsetGraphics.details;
      break;

    case "pattern":
      PatternGraphics patternGraphics = new PatternGraphics(poster, myGrid);
      //generatedPGraphics = patternGraphics.getGraphics();
      detailsFromGraphics = patternGraphics.details;
      break;

    default:
      //generatedPGraphics = empty();
      break;
    }
    //applyGraphicToPoster(generatedPGraphics, poster);


    String details = "Graphic Type:   " + graphicType + "\n" + "Graphic Partition Location:   " + myGrid.index + "\n" + detailsFromGraphics;
    StageInfo stageInfo = new StageInfo(details);
    return stageInfo;
  }

  private void chooseGraphicType() {
    print("Choosing graphics type...");
    String[] graphicTypes = new String[] {"offset", "pattern", "empty"};
    int[] graphicTypeProbabilities = new int[]{7, 2, 0};
    if (myGrid.fullHeight) {
      graphicTypeProbabilities = new int[]{1, 0, 0};
    }
    graphicType = pickByProbability(graphicTypes, graphicTypeProbabilities).toString();
    print("Graphics type is\033[1;34m"  + graphicType+"\033[0m\n");
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();

    if (myGrid.index == 0 || myGrid.fullHeight) {
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
