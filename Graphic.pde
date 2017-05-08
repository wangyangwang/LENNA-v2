//class Graphic {
//  String details;
//  PGraphics PGcanvas;

//  Graphic (Poster poster, String type, int w, int h) {
//    PGcanvas = createGraphics(w, h);
//    switch (type) {
//    case "offset":
//      OffsetGraphics offsetGraphics = new OffsetGraphics(poster);
//      PGcanvas = offsetGraphics.getGraphics();
//      break;

//    case "pattern":
//    PatternGraphics patternGraphics = new PatternGraphics(poster);
//      PGcanvas = patternGraphics.getGraphics();
//      break;

//    default:
//      PGcanvas = empty();
//      break;
//    }
//  }

//  public PGraphics getResult() {
//    return PGcanvas;
//  }

//  ///////////////////////////////////
//  ///////////////////////////////////
//  ///////////////////////////////////

//  //ALL TYPES OF GRAPHICS

//  private PGraphics offset(Poster poster) {
//    ArrayList<OffsetObject> offsetObjects = new ArrayList<OffsetObject>();

//    ArrayList<ProbabilityObject> offsetObjectNumberSet = new ArrayList<ProbabilityObject>();
//    offsetObjectNumberSet.add(new ProbabilityObject(2, 80));
//    offsetObjectNumberSet.add(new ProbabilityObject(3, 15));
//    offsetObjectNumberSet.add(new ProbabilityObject((int)random(5, 10), 5));
//    int numberOfShapes = (int)getObjectByProbability(offsetObjectNumberSet).value;

//    //what object?
//    ArrayList<ProbabilityObject> offsetObjectProbabilitySet = new ArrayList<ProbabilityObject>();
//    offsetObjectProbabilitySet.add(new ProbabilityObject("ellipse", 33));
//    offsetObjectProbabilitySet.add(new ProbabilityObject("triangle", 33));
//    offsetObjectProbabilitySet.add(new ProbabilityObject("rectangular", 33));
//    if (numberOfShapes > 3) {
//      offsetObjectProbabilitySet.add(new ProbabilityObject("letter", 0));
//    } else {
//      offsetObjectProbabilitySet.add(new ProbabilityObject("letter", 33));
//    }

//    String shape = getObjectByProbability(offsetObjectProbabilitySet).value.toString();


//    //how is the offsetValue?    < 0 > is 100% overlap, < 1 > is side by side
//    ArrayList<ProbabilityObject> offsetValueProbabilitySet = new ArrayList<ProbabilityObject>();
//    offsetValueProbabilitySet.add(new ProbabilityObject(0.0, 25));
//    offsetValueProbabilitySet.add(new ProbabilityObject(1 - 0.618, 30));
//    offsetValueProbabilitySet.add(new ProbabilityObject(0.618, 20));
//    offsetValueProbabilitySet.add(new ProbabilityObject(1 - 0.797, 10));
//    offsetValueProbabilitySet.add(new ProbabilityObject(0.797, 10));
//    offsetValueProbabilitySet.add(new ProbabilityObject(1.0, 5));

//    float offsetPercentage = (float)getObjectByProbability(offsetValueProbabilitySet).value;
//    details = "-Shape:\n" + shape + "\nNumber of Shapes:\n" + numberOfShapes + "\nOffset Percentage:\n" + offsetPercentage;

//    //drawOffsetObjects();

//    PGcanvas.beginDraw();
//    PGcanvas.background(poster.colorScheme.backgroundColor);
//    PGcanvas.endDraw();
//    return PGcanvas;
//  }
//  ///////////////////////////////////
//  ///////////////////////////////////
//  ///////////////////////////////////


//  private PGraphics pattern(Poster poster) {
//    PGcanvas.beginDraw();
//    PGcanvas.fill(poster.colorScheme.graphicsColor[1]);
//    PGcanvas.noStroke();

//    float horGridSize = PGcanvas.width/5;
//    float verGridSize = PGcanvas.height/5;

//    float elementSize =  min(horGridSize, verGridSize) * 0.90;

//    for (int x = 0; x < PGcanvas.width - horGridSize; x += horGridSize) {
//      for (int y = 0; y < PGcanvas.height - verGridSize; y += verGridSize) {
//        PGcanvas.ellipse( x + horGridSize/2, y + verGridSize/2, elementSize, elementSize);
//      }
//    }


//    PGcanvas.endDraw();
//    details = "?";
//    return PGcanvas;
//  }
//  private PGraphics empty() {
//    PGcanvas.beginDraw();
//    PGcanvas.endDraw();
//    return PGcanvas;
//  }
//}

/////////////////////////////////////
/////////////////////////////////////
/////////////////////////////////////


//class OffsetObject {
//  String type;

//  OffsetObject (Poster poster) {
//  }

//  void draw() {
//  }

//  void chooseShape () {
//  }
//}