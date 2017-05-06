class Graphic {
  String details;
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

    g.beginDraw();
    g.background(poster.colorScheme.backgroundColor);
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