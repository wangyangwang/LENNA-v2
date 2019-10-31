class OffsetGraphics extends Graphics {

  String shape;
  String strokeStyle;
  int numberOfShape;
  float offsetDist;
  float scaler;
  boolean oversize;
  boolean layerBlending;
  PVector offsetDirection;
  int blendmode;
  float rotateX;


  OffsetGraphics (Poster _poster, Grid _mygrid) {
    super(_poster, _mygrid);
  }

  void makeDecisions() {
    //Pick shape
    log.print("Choosing Shape...");
    String[] shapes = new String[] {"rectangle", "triangle", "letter", "ellipse", "box", "sphere"};
    int[] shapeProbabilities = new int[] {15, 15, 25, 30, 3, 3};//default
    shape = pickByProbability(shapes, shapeProbabilities).toString();
    log.print("Shape type: [" + shape+"]");
    addToDetails("Shape: " + shape);

    // rotate x
    if (shape=="sphere" || shape=="box") {
      rotateX = random(0, TWO_PI);
    } else {
      rotateX = 0;
    }

    //pick style
    String[] strokeStyles = new String[] {"fill", "stroke"};
    int[] strokeStyleProbabilities = new int[] {90, 10};
    if (shape == "box" || shape == "sphere") {
      strokeStyleProbabilities = new int[] {0, 1};
    }
    strokeStyle = pickByProbability(strokeStyles, strokeStyleProbabilities).toString();
    log.print("stroke: [" + ((strokeStyle == "fill")?"No Stroke":"Only Stroke"+"]") );
    addToDetails("\nShape Style: [" + strokeStyle+"]");

    //Pick number of object
    Integer[] number = new Integer[] {1, 2, 3, 4};
    int[] numberProbability = new int[] {0, 50, 30, 10}; //default
    if (shape=="letter") {
      numberProbability = new int[] {5, 90, 10, 0};
    }
    if (shape=="sphere") {
      numberProbability = new int[] {1, 0, 0, 0};
    }
    numberOfShape = (int)pickByProbability(number, numberProbability);
    log.print("Shape number: ["+numberOfShape+"]");
    addToDetails("\nNumber of Shapes: " + numberOfShape);

    //Pick scaler
    Float[] scalers = new Float[] {1.0, 1.382, 1.618};
    int[] scalerProbabilites = new int[] {80, 10, 10};//default
    //if (shape=="letter") {
    //scalerProbabilites = new int[] {100, 0, 0};
    //}
    scaler = (Float)pickByProbability(scalers, scalerProbabilites);
    log.print("The graphics scales by: [" + scaler+"]");
    addToDetails("\nShape scales by: " + scaler);

    //pick offsetDistance
    Float[] offsetDistances = new Float[] {0.0, 0.382, 0.5, 0.618, 1.0};
    int[] offsetDistanceProbabilities = new int[] {12, 35, 35, 15, 3}; //default
    //int[] offsetDistanceProbabilities = new int[] {0, 0, 0, 0, 0, 5, 5}; //default
    switch(shape) {
    case "letter":
      offsetDistanceProbabilities = new int[] {3, 2, 0, 0, 0};
      break;
    }
    if (scaler != 1) {
      offsetDistanceProbabilities = new int[] {100, 0, 0, 0, 0};
    }

    offsetDist = (Float)pickByProbability(offsetDistances, offsetDistanceProbabilities);
    log.print("Shape offset 1by1 by: ["+offsetDist + "] % of shape's size" );
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
    log.print("Shapes offset by: ["+degrees(offsetDirection.heading()) + "] degree");

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
    log.print("Layer blending? [" + layerBlending+"]");

    //layer blend mode
    //Integer[] blendmodes = new Integer[]{MULTIPLY, ADD, SUBTRACT, DARKEST, LIGHTEST, EXCLUSION, REPLACE};
    //int[] blendmodeProbabilities = new int[]{2, 1, 1, 1, 1, 1, 1};
    //blendmode = (int)pickByProbability(blendmodes, blendmodeProbabilities);
    blendmode = MULTIPLY;
    log.print("Blend mode: ["+blendmode+"]");
    addToDetails("\nBlend Mode:   "+blendmode);
  }

  void design() {
    int strokeWeight = floor(h * random(0.003, 0.009));
    int shapeSize = floor(min(w, h) * random(0.4, 0.9));

    switch (shape) {
    case "letter":
      shapeSize = floor(min(w, h) * 1);
      break;
    }
    log.print("Drawing shapes according to all parameters generated above...");
    /////////////////////Centering the graphics
    float hypotenuse = offsetDist * (numberOfShape - 1) * shapeSize;
    float theta = offsetDirection.heading();
    float offsetWidth = cos(theta) * hypotenuse;
    float offsetHeight = sin(theta) * hypotenuse;
    float xAdjustment = w/2 - offsetWidth/2;
    float yAdjustment = h/2 - offsetHeight/2;
    addToDetails("\nOffset Width:  "+ offsetWidth + "\nOffset Height:   " + offsetHeight);

    //////////////////// Resize the graphics
    hypotenuse = (numberOfShape * shapeSize) - (numberOfShape - 1) * (1-offsetDist) * shapeSize;
    float graphicsWidth = abs(cos(theta) * hypotenuse) + (shapeSize - abs(cos(theta)*shapeSize));
    float graphicsHeight = abs(sin(theta) * hypotenuse) + (shapeSize - abs(sin(theta)*shapeSize));

    addToDetails("\nGraphics width:   "+graphicsWidth +"\nGraphics Height:   "+graphicsHeight);

    if (scaler != 1 && offsetDist == 0.0) {
      graphicsWidth = shapeSize * pow(scaler, numberOfShape);
      graphicsHeight = graphicsWidth;
    }

    float xScaleFactor = (w - padding * 2) / graphicsWidth;
    float yScaleFactor = (h - padding * 2) / graphicsHeight;
    float globalScaler = min(xScaleFactor, yScaleFactor);
    addToDetails("\nGraphics scaled by: " + globalScaler);

    ///////////////////////start drawing
    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(xAdjustment, yAdjustment + yoffset);
    poster.content.rotateX(rotateX);
    //poster.content.scale(globalScaler);

    //layer blending
    if (layerBlending) {
      poster.content.blendMode(blendmode);
    }

    for (int i=0; i<numberOfShape; i++) { // numberOfShape
      poster.content.pushMatrix();
      poster.content.translate(i * offsetDist * shapeSize * offsetDirection.x, i * offsetDist * shapeSize * offsetDirection.y); // offsetDist + offsetDirection
      // shape
      int scaledSize = floor(shapeSize * pow(scaler, i));
      color cc = poster.colorScheme.graphicsColor[((i)%poster.colorScheme.graphicsColor.length)];

      //strokeStyle
      switch(strokeStyle) {
      case "fill":
      default:
        poster.content.fill(cc); //color
        poster.content.noStroke();
        break;

      case "stroke":
        poster.content.noFill();
        poster.content.stroke(cc);
        poster.content.strokeWeight(strokeWeight);
        break;
      }

      switch(shape) {
      case "rectangle":
        poster.content.pushStyle();
        poster.content.rectMode(CENTER);
        poster.content.rect(0, 0, scaledSize, scaledSize);
        poster.content.popStyle();
        break;

      case "letter":
        poster.content.textFont(createFont("Helvetica-Bold", 500));
        String alphabet = "QWERTYUIOPLKJHGFDSAZXCVBNMmnbvcxzasdfghjklpoiuytrewq";
        char ourChar = alphabet.charAt(floor(random(alphabet.length())));
        poster.content.textAlign(CENTER, CENTER);
        poster.content.textSize(scaledSize);
        poster.content.text(ourChar, 0, 0);
        break;

      case "triangle":
        poster.content.triangle(0, -scaledSize/2, scaledSize/2, scaledSize/2, -scaledSize/2, scaledSize/2);
        break;

      case "ellipse":
        poster.content.ellipse(0, 0, scaledSize, scaledSize);
        break;

      case "box":
        poster.content.box(scaledSize * 0.8);
        break;

      case "sphere":
        poster.content.sphereDetail(floor(random(3, 5)));
        poster.content.sphere(scaledSize * 0.6);
        break;

      default:
        System.err.println("can't recognize shape");
        break;
      }
      poster.content.popMatrix();
    }
    poster.content.endDraw();
    log.print("Finished drawing graphics.");
  }
}