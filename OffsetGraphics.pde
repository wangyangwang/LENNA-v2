class OffsetGraphics extends Graphics {

  String shape;
  String strokeStyle;
  int numberOfShape;
  float offsetDist;
  float scaler;
  boolean oversize;
  boolean layerBlending;
  PVector offsetDirection;

  OffsetGraphics (Poster poster, int _w, int _h, int _myGridIndex) {
    super(poster, _w, _h, _myGridIndex);
  }

  void makeDecisions() {
    //Pick shape
    String[] shapes = new String[] {"rectangle", "triangle", "letter", "ellipse"};
    int[] shapeProbabilities = new int[] {20, 25, 25, 30};//default

    shape = pickByProbability(shapes, shapeProbabilities).toString();
    addToDetails("\nShape: " + shape);

    //pick style
    String[] strokeStyles = new String[] {"fill", "stroke"};
    int[] strokeStyleProbabilities = new int[] {90, 10};
    strokeStyle = pickByProbability(strokeStyles, strokeStyleProbabilities).toString();
    addToDetails("\nShape Style: " + strokeStyle);


    //Pick number of object
    Integer[] number = new Integer[] {2, 3, 4};
    int[] numberProbability = new int[] {60, 30, 10}; //default

    if (shape=="letter") {
      numberProbability = new int[] {100, 0, 0};
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
      offsetDistanceProbabilities = new int[] {70, 20, 10, 0, 0};
      break;
    }
    if (scaler != 1) {
      offsetDistanceProbabilities = new int[] {100, 0, 0, 0, 0};
    }

    offsetDist = (Float)pickByProbability(offsetDistances, offsetDistanceProbabilities);
    addToDetails("\nOffset by " + offsetDist + " of the shape's size");

    //pick offsetDirection
    PVector[] offsetDirections = new PVector[] {new PVector(1, -1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, 0), new PVector(0, 0), new PVector(-1, -1)};
    for (PVector p : offsetDirections) {
      p.normalize();
    }
    int[] offsetDirectionProbabilities = new int[] {16, 16, 16, 16, 20, 16};
    if (offsetDist == 0.0) {
      offsetDirectionProbabilities = new int[] {0, 0, 0, 0, 100, 0};
    }
    offsetDirection = (PVector)pickByProbability(offsetDirections, offsetDirectionProbabilities);
    addToDetails("\nOffsetting direction: " + degrees(offsetDirection.heading()) + " degree" );

    //layer blending or not
    Boolean[] ifLayerBlend = new Boolean[] {true, false};
    int[] layerBlendProbability = new int[] {50, 50};
    if (shape == "letter") {
      layerBlendProbability = new int[] {100, 0};
    }
    if (offsetDist == 0.0) {
      layerBlendProbability = new int[] {100, 0};
    }
    layerBlending = (boolean)pickByProbability(ifLayerBlend, layerBlendProbability);
  }

  void design() {

    int strokeWeight = 50;

    int shapeSize = floor(min(w, h) * 0.5);
    switch (shape) {
    case "letter":
      shapeSize = floor(min(w, h) * 1);
      break;
    }

    w = graphics.width;
    h = graphics.height;

    /////////////////////Centering the graphics
    float hypotenuse = offsetDist * (numberOfShape - 1) * shapeSize;
    float theta = offsetDirection.heading();
    float offsetWidth = cos(theta) * hypotenuse;
    float offsetHeight = sin(theta) * hypotenuse;
    float xAdjustment = w/2 - offsetWidth/2;
    float yAdjustment = h/2 - offsetHeight/2;
    addToDetails("\nOffset Width:  "+ offsetWidth + "\nOffset Height:   " + offsetHeight);

    //////////////////// Resize the graphics
    hypotenuse = pow(numberOfShape, scaler) * shapeSize - ((numberOfShape - 1) * (1-offsetDist) * shapeSize);
    float graphicsWidth = abs(cos(theta) * hypotenuse);
    float graphicsHeight = abs(sin(theta) * hypotenuse);
    float xScaleFactor = (w - padding * 2) / graphicsWidth;
    float yScaleFactor = (h - padding * 2) / graphicsHeight;
    float globalScaler = min(xScaleFactor, yScaleFactor);
    addToDetails("\nGraphics scaled by: " + globalScaler);


    ///////////////////////start drawing
    graphics.beginDraw();

    graphics.background(poster.colorScheme.backgroundColor);

    graphics.pushMatrix();
    graphics.translate(xAdjustment, yAdjustment);
    //graphics.scale(globalScaler);

    //layer blending
    if (layerBlending) {
      graphics.blendMode(MULTIPLY);
    }

    for (int i=0; i<numberOfShape; i++) { // numberOfShape
      graphics.pushMatrix();
      graphics.translate(i * offsetDist * shapeSize * offsetDirection.x, i * offsetDist * shapeSize * offsetDirection.y); // offsetDist + offsetDirection
      // shape
      int scaledSize = floor(shapeSize * pow(scaler, i));

      //strokeStyle
      switch(strokeStyle) {
      case "fill":
      default:
        graphics.fill(poster.colorScheme.colors[((1+i)%4)]); //color
        graphics.noStroke();
        break;

      case "stroke":
        graphics.noFill();
        graphics.stroke(poster.colorScheme.colors[((1+i)%4)]);
        graphics.strokeWeight(strokeWeight);
        break;
      }

      switch(shape) {
      case "rectangle":
        graphics.rectMode(CENTER);
        graphics.rect(0, 0, scaledSize, scaledSize);
        break;

      case "letter":
        graphics.textFont(createFont("Helvetica-Bold", 500));
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
    //////////////////// DEBUG draws ///////////
    // graphics.fill(0,100);
    // graphics.noStroke();
    // graphics.rectMode(CENTER);
    // // graphics.rect(0,0,constrain(graphicsWidth,30,1000000),constrain(graphicsHeight,30,1000000));
    //
    //
    // graphics.ellipse(0,0,50,50);
    // graphics.strokeWeight(10);
    // graphics.stroke(0);
    // graphics.line(0,0,hypotenuse * offsetDirection.x,   hypotenuse * offsetDirection.y);
    // graphics.popMatrix();

    ////////////////////////////end drawing
    graphics.endDraw();
  }
}