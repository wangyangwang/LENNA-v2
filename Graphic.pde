class Graphic {
  String details;
  PGraphics PGcanvas;
  Grid myGrid;
  

  Graphic (Poster poster, String type, Grid _myGrid) {
    myGrid = _myGrid;
    PGcanvas = createGraphics(myGrid.w, myGrid.h);
    switch (type) {
    case "offset":
      PGcanvas = offset(poster);
      break;

    case "pattern":
      PGcanvas = pattern(poster);
      break;

    default:
      PGcanvas = empty();
      break;
    }
  }

  public PGraphics getResult() {
    return PGcanvas;
  }

  ///////////////////////////////////
  //ALL TYPES OF GRAPHICS

  private PGraphics offset(Poster poster) {
    ArrayList<OffsetObject> offsetObjects = new ArrayList<OffsetObject>();

    ArrayList<ProbabilityObject> offsetObjectNumberSet = new ArrayList<ProbabilityObject>();
    offsetObjectNumberSet.add(new ProbabilityObject(2, 80));
    offsetObjectNumberSet.add(new ProbabilityObject(3, 15));
    offsetObjectNumberSet.add(new ProbabilityObject((int)random(5, 10), 5));
    int numberOfShapes = (int)getObjectByProbability(offsetObjectNumberSet).value;

    //what object?
    ArrayList<ProbabilityObject> offsetObjectProbabilitySet = new ArrayList<ProbabilityObject>();
    offsetObjectProbabilitySet.add(new ProbabilityObject("ellipse", 33));
    offsetObjectProbabilitySet.add(new ProbabilityObject("triangle", 33));
    offsetObjectProbabilitySet.add(new ProbabilityObject("rectangular", 33));
    if (numberOfShapes > 3) {
      offsetObjectProbabilitySet.add(new ProbabilityObject("letter", 0));
    } else {
      offsetObjectProbabilitySet.add(new ProbabilityObject("letter", 33));
    }

    String shape = getObjectByProbability(offsetObjectProbabilitySet).value.toString();


    //how is the offsetValue?    < 0 > is 100% overlap, < 1 > is side by side
    ArrayList<ProbabilityObject> offsetValueProbabilitySet = new ArrayList<ProbabilityObject>();
    offsetValueProbabilitySet.add(new ProbabilityObject(0.0, 25));
    offsetValueProbabilitySet.add(new ProbabilityObject(1 - 0.618, 30));
    offsetValueProbabilitySet.add(new ProbabilityObject(0.618, 20));
    offsetValueProbabilitySet.add(new ProbabilityObject(1 - 0.797, 10));
    offsetValueProbabilitySet.add(new ProbabilityObject(0.797, 10));
    offsetValueProbabilitySet.add(new ProbabilityObject(1.0, 5));

    float offsetPercentage = (float)getObjectByProbability(offsetValueProbabilitySet).value;
    details = "-Shape:\n" + shape + "\nNumber of Shapes:\n" + numberOfShapes + "\nOffset Percentage:\n" + offsetPercentage;

    //drawOffsetObjects();

    PGcanvas.beginDraw();
    PGcanvas.background(poster.colorScheme.backgroundColor);
    PGcanvas.endDraw();
    return PGcanvas;
  }

  private PGraphics pattern(Poster poster) {
    PGcanvas.beginDraw();
    PGcanvas.stroke(poster.colorScheme.graphicsColor[0]);
    PGcanvas.strokeWeight(30);
    PGcanvas.noFill();
    float rectSize =  PGcanvas.width/10;

    for (int x = 0; x < PGcanvas.width - rectSize; x += PGcanvas.width/5) {
      for (int y = 0; y < PGcanvas.height - rectSize; y += PGcanvas.height/5) {
        PGcanvas.rect(x, y, rectSize, rectSize);
      }
    }
    PGcanvas.endDraw();
    String loc;  
    details = "Graphics is in:\n" + myGrid.index + "\n(0 means top, 1 means bottom)";
    return PGcanvas;
  }
  private PGraphics empty() {
    PGcanvas.beginDraw();
    PGcanvas.endDraw();
    return PGcanvas;
  }
}



/////////////////////////
class OffsetObject {
  String type;

  OffsetObject (Poster poster) {
  }

  void draw() {
  }

  void chooseShape () {
  }
}