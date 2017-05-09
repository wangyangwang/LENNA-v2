class OffsetGraphics extends Graphics {

  ArrayList<ProbabilityObject> shapeProbabilitySet;
  String shape;
  String strokeStyle;
  int numberOfShape;
  float offsetDist;
  float scaler;
  PVector offsetDirection;

  // for shape[letter]



  OffsetGraphics (Poster poster, int _w, int _h) {
    super(poster, _w, _h);
  }

  void makeDecisions() {
    //Pick shape
    String[] shapes = new String[] {"rectangle", "triangle", "letter", "ellipse"};
    int[] shapeProbabilities = new int[] {20, 25, 25, 30};//default

    shape = pickByProbability(shapes, shapeProbabilities).toString();
    addToDetails("\nShape: " + shape);

    //pick style
    String[] strokeStyles = new String[] {"fill", "stroke"};
    int[] strokeStyleProbabilities = new int[]{90, 10};
    strokeStyle = pickByProbability(strokeStyles, strokeStyleProbabilities).toString();
    addToDetails("\nShape Style: " + strokeStyle);


    //Pick number of object
    Integer[] number = new Integer[] {2, 3, 4};
    int[] numberProbability = new int[] {60, 30, 10}; //default

    if (shape=="letter") {
      numberProbability = new int[] {90, 10, 0};
    }
    numberOfShape = (int)pickByProbability(number, numberProbability);
    addToDetails("\nNumber of Shapes: " + numberOfShape);

    //Pick scaler
    Float[] scalers = new Float[] {1.0, 1.382, 1.618};
    int[] scalerProbabilites = new int[] {80, 10, 10};//default
    if (shape=="letter") {
      scalerProbabilites = new int[] {100, 0, 0};
    }
    scaler = (Float)pickByProbability(scalers, scalerProbabilites);
    addToDetails("\nShape scales by: " + scaler);

    //pick offsetDistance
    Float[] offsetDistances = new Float[] {0.0, 0.382, 0.5, 0.618, 1.0};
    int[] offsetDistanceProbabilities = new int[] {12, 35, 35, 15, 3}; //default
    switch(shape) {
    case "letter":
      offsetDistanceProbabilities = new int[] {70, 30, 0, 0, 0};
      break;
    }
    if (scaler != 1) {
      offsetDistanceProbabilities = new int[] {100, 0, 0, 0, 0};
    }

    offsetDist = (Float)pickByProbability(offsetDistances, offsetDistanceProbabilities);
    addToDetails("\nOffset by " + offsetDist + " of the shape's size");

    //pick offsetDirection
    PVector[] offsetDirections = new PVector[] {new PVector(1, 1), new PVector(0, 1), new PVector(1, 0), new PVector(-1, 0), new PVector(-1, -1), new PVector(0, -1), new PVector(0, 0), new PVector(-1, 1), new PVector(1, -1)};
    for (PVector p : offsetDirections) {
      p.normalize();
    }
    int[] offsetDirectionProbabilities = new int[]{7, 10, 10, 10, 7, 10, 32, 7, 7};
    offsetDirection = (PVector)pickByProbability(offsetDirections, offsetDirectionProbabilities);
    addToDetails("\nOffsetting direction: " + degrees(offsetDirection.heading()) + " degree" );
  }

  void design() {
    w = graphics.width;
    h = graphics.height;
    color mainColor = poster.colorScheme.graphicsColor[1];
    int strokeWeight = 50;
    int shapeSize = floor(min(w, h) * 0.5);

    graphics.beginDraw();
    ///////////////////////start drawing
    graphics.pushMatrix();
    // float widthOfGraphics = w
    // float heightOfGraphics = h;
    graphics.translate(w/2, h/2);

    //strokeStyle
    switch(strokeStyle) {
    case "fill":
    default:
      graphics.fill(mainColor);
      graphics.noStroke();
      break;

    case "stroke":
      graphics.noFill();
      graphics.stroke(mainColor);
      graphics.strokeWeight(strokeWeight);
      break;
    }
    graphics.blendMode(SCREEN);
    for (int i=0; i<numberOfShape; i++) { // numberOfShape
      graphics.pushMatrix();
      graphics.translate(i * offsetDist * shapeSize * offsetDirection.x, i * offsetDist * shapeSize * offsetDirection.y); // offsetDist + offsetDirection
      // shape
      int scaledSize = floor(shapeSize * pow(scaler, i));

      switch(shape) {
      case "rectangle":
        graphics.rectMode(CENTER);
        graphics.rect(0, 0, scaledSize, scaledSize);
        break;

      case "letter":
        String alphabet = "QWERTYUIOPLKJHGFDSAZXCVBNMmnbvcxzasdfghjklpoiuytrewq";
        char ourChar = alphabet.charAt(floor(random(alphabet.length())));
        graphics.textAlign(CENTER, CENTER);
        graphics.textSize(scaledSize);
        graphics.text(ourChar, 0, 0);
        break;

      case "triangle":
        graphics.triangle(0, -scaledSize/2, scaledSize/2, scaledSize/2, -scaledSize/2, scaledSize/2);
        break;

      case "ellipse":
        graphics.ellipse(0, 0, scaledSize, scaledSize);
        break;

      default:
        System.err.println("can't recognize shape");
        break;
      }
      graphics.popMatrix();
    }
    graphics.popMatrix();


    ////////////////////////////end drawing
    graphics.endDraw();
  }
}