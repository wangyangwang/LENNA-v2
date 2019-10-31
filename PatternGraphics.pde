class PatternGraphics extends Graphics {

  final int maxRowNumber = 200;
  final int maxColNumber = 200; 
  //final float maxSizeChange = 1.05;
  final float localRotationMaxDegree = 7;
  final float localRotateProbability = 0.3;
  final float localGradientColorProbability = 0.2;
  final float globalGradientColorProbability = 0.2;

  boolean oneDirection;
  int rowNumber;
  int colNumber;
  int vectorNumber;
  float xSize, ySize; 
  //float sizeXChange;
  //float sizeYChange;
  float localRotationChange;
  float xgap, ygap;
  boolean localGradientColor, globalGradientColor;
  color gc1, gc2;


  PatternGraphics (Poster poster, Grid myGrid) {
    super(poster, myGrid);
  }

  void makeDecisions() {

    //number of row  || col
    Integer[] numbers = new Integer[] {15, 40};
    int[] numberProbabilities = new int[] {1, 1};
    int number = (int)pickByProbability(numbers, numberProbabilities);
    log.print("Number of shapes: ["+number+"]");

    //number of row && col
    float oneDirectionProbability = 0.5;
    if (random(0, 1)<oneDirectionProbability) {
      oneDirection = true;
      if (random(0, 1) < 0.5) {
        rowNumber = 1;
        colNumber = number;
      } else {
        colNumber = 1;
        rowNumber = number;
      }
    } else {
      colNumber = rowNumber = number;
    }
    rowNumber = constrain(rowNumber, 1, maxRowNumber);
    colNumber = constrain(colNumber, 1, maxColNumber);
    log.print("Row/Column number: [" + rowNumber+"]["+colNumber +"]");
    addToDetails("Row Number:   " + rowNumber + "\nColumn Number:   "+colNumber + "\n");

    //vector number;
    Integer[] vectorNumbers = new Integer[]{3, 4, 5};
    int[] vectorNumberProbabilities = new int[]{5, 3, 3};
    vectorNumber = (int)pickByProbability(vectorNumbers, vectorNumberProbabilities);
    if (oneDirection) {
      vectorNumber = 4; //if One Direction, then it got to be rect.
    }
    log.print("Each shape will have: ["+vectorNumber+"] vectices");
    addToDetails("Shape Vectices Number:   " + vectorNumber + "\n");

    //size
    int availableWidth, availableHeight;
    availableHeight = myGrid.h - poster.padding * 2;
    availableWidth = posterWidth - poster.padding * 2;
    xSize = availableWidth / colNumber;
    ySize = availableHeight / rowNumber;
    log.print("Width of single shape: ["+xSize+"] height: ["+ySize+"]");
    addToDetails("Single Shape Width:  "+xSize+"\nSingle Shape Height:   " + ySize + "\n");


    //gap
    float rando = random(0.1, 0.9);
    xgap = rando * xSize;
    ygap = rando * ySize;

    if (colNumber==1)xgap=0;
    if (rowNumber==1)ygap=0;
    log.print("Horizontal gap: ["+xgap+"]" + "vertical gap: ["+ygap+"]");
    addToDetails("xgap:   " + xgap + "\nygap:   " + ygap + "\n");


    //    //size change
    //    sizeXChange = random(1, maxSizeChange);
    //    sizeYChange = sizeXChange;

    //    if (rowNumber == 1) {
    //      sizeYChange = 1;
    //      sizeXChange = random(1, maxSizeChange);
    //    }
    //    if (colNumber == 1) {
    //      sizeXChange = 1;
    //      sizeYChange = random(1, maxSizeChange);
    //    }

    //    addToDetails("Single Shape Size Change by:   " + sizeXChange+"," + sizeYChange + "\n");

    //rotation
    if (random(0, 1) < localRotateProbability && !oneDirection) {
      localRotationChange = random(radians(0), radians(localRotationMaxDegree));
    } else {
      localRotationChange = 0;
    }

    log.print("Shape rotates 1by1 by ["+degrees(localRotationChange)+"]");


    //color
    gc1 = poster.colorScheme.graphicsColor[0];
    if (random(0, 1) < globalGradientColorProbability) {
      globalGradientColor = true;
      gc2 = poster.colorScheme.graphicsColor[2];
    } else {
      gc2 = gc1;
    }
    if (random(0, 1) < localGradientColorProbability) {
      localGradientColor = true;
    }
    addToDetails("Shape Color 1   " + hex(gc1) + "\nColor 2:   " + hex(gc2) + "\n");
  }

  void design() {
    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(0, yoffset);

    int index = 0;
    float sum = colNumber * rowNumber;
    log.print("Drawing the pattern on our poster...");
    for (int xn = 0; xn < colNumber; xn++) {
      for (int yn = 0; yn < rowNumber; yn++) {

        color c = lerpColor(gc1, gc2, index / sum);
        float xpos = poster.padding + xSize/2 + xn * xSize;
        float ypos = poster.padding + ySize/2 + yn * ySize;
        PIShape(poster.content, index, vectorNumber, xpos, ypos, xSize - xgap, ySize - ygap, localRotationChange, c, localGradientColor);
        index++;
      }
    }
    poster.content.popMatrix();
    poster.content.endDraw();
  }
}

/////////////
/////////////
void PIShape(PGraphics pg, int index, int verticesNumber, float x, float y, float xsize, float ysize, float rotationChange, color c, boolean ifGradient) {
  float rx = xsize/2;
  float ry = ysize/2;
  float angle = TWO_PI/verticesNumber;
  color c2;
  if (ifGradient) {
    c2 = color(red(c), green(c), blue(c), 0);
  } else {
    c2 = c;
  }
  //pg.beginDraw();
  ////////////
  pg.pushMatrix();
  pg.translate(x, y);
  pg.scale(rx, ry);
  pg.rotate(rotationChange * index);


  if (verticesNumber == 4) {
    pg.beginShape();
    pg.noStroke();
    pg.fill(c);
    pg.vertex(1, 1);
    pg.vertex(-1, 1);
    pg.fill(c2);
    pg.vertex(-1, -1);
    pg.vertex(1, -1);
    pg.endShape(CLOSE);
  } else {
    pg.beginShape();
    pg.noStroke();
    for (int i=0; i<verticesNumber; i++) {
      if (i<verticesNumber/2) {
        pg.fill(c);
      } else {
        pg.fill(c2);
      }
      float xx = cos(i * (angle) + PI/verticesNumber );
      float yy = sin(i * (angle) + PI/verticesNumber );
      pg.vertex(xx, yy);
    }
    pg.endShape(CLOSE);
  }
  pg.popMatrix();
  ///////////
  //pg.endDraw();
}