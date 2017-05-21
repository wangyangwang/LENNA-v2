class PatternGraphics extends Graphics {

  final int maxRowNumber = 200;
  final int maxColNumber = 200; 
  final float maxSizeChange = 1.2;
  final float localRotationMaxDegree = 10;
  final float localRotateProbability = 0.3;
  final float localGradientColorProbability = 0.2;
  final float globalGradientColorProbability = 0.2;


  boolean boundary;
  boolean oneDirection;
  int rowNumber;
  int colNumber;
  int vectorNumber;
  float xSize, ySize; 
  float sizeXChange;
  float sizeYChange;
  float localRotationChange;
  float xgap, ygap;
  boolean localGradientColor, globalGradientColor;
  color lc1, lc2;
  color gc1, gc2;

  PatternGraphics (Poster poster, Grid myGrid) {
    super(poster, myGrid);
  }

  void makeDecisions() {
    //boundary or not
    float boundaryProbability = 0.9;
    if (random(0, 1)<boundaryProbability) {
      boundary = true;
    } else {
      boundary = false;
    }

    //number of row  || col
    Integer[] numbers = new Integer[] {10, 40};
    int[] numberProbabilities = new int[] {1, 1};
    int number = (int)pickByProbability(numbers, numberProbabilities);

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
    addToDetails("Row Number:   " + rowNumber + "\nColumn Number:   "+colNumber + "\n");

    //vector number;
    Integer[] vectorNumbers = new Integer[]{3, 4, 10};
    int[] vectorNumberProbabilities = new int[]{5, 3, 3};
    vectorNumber = (int)pickByProbability(vectorNumbers, vectorNumberProbabilities);
    if (oneDirection) {
      vectorNumber = 4; //if One Direction, then it got to be rect.
    }
    addToDetails("Shape Vectices Number:   " + vectorNumber + "\n");

    //size
    int availableWidth, availableHeight;
    availableHeight = myGrid.h - poster.padding;
    if (boundary) {
      availableWidth = posterWidth - poster.padding * 2;
    } else {
      availableWidth = posterWidth;
    }
    xSize = availableWidth / colNumber;
    ySize = availableHeight / rowNumber;
    addToDetails("Single Shape Width:  "+xSize+"\nSingle Shape Height:   " + ySize + "\n");


    //gap
    float rando = random(0, 1);
    xgap = rando * xSize;
    ygap = rando * ySize;
    
    if (colNumber==1)xgap=0;
    if (rowNumber==1)ygap=0;

    addToDetails("xgap:   " + xgap + "\nygap:   " + ygap + "\n");


    //size change
    if (rowNumber == 1) {
      sizeYChange = 1;
      sizeXChange = random(1, maxSizeChange);
    }
    if (colNumber == 1) {
      sizeXChange = 1;
      sizeYChange = random(1, maxSizeChange);
    }
    addToDetails("Single Shape Size Change by:   " + sizeXChange+"," + sizeYChange + "\n");

    //rotation
    if (random(0, 1) < localRotateProbability) {
      localRotationChange = random(radians(0), radians(localRotationMaxDegree));
    } else {
      localRotationChange = 0;
    }


    //color
    gc1 = poster.colorScheme.graphicsColor[0];
    lc1 = gc1;

    if (random(0, 1) < globalGradientColorProbability) {
      globalGradientColor = true;
      gc2 = poster.colorScheme.graphicsColor[1];
    } else {
      gc2 = gc1;
    }
    if (random(0, 1) < localGradientColorProbability) {
      localGradientColor = true;
      lc2 = color(red(lc1), green(lc1), blue(lc1), 0);
    } else {
      lc2 = lc1;
    }
  }

  void design() {
    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(0, yoffset);
    for (int xn = 0; xn < colNumber; xn++) {
      for (int yn = 0; yn < rowNumber; yn++) {
        float xpos = poster.padding + xSize/2 + xn * xSize;
        float ypos = ySize/2 + yn * ySize;
        PIShape(poster.content, vectorNumber, xpos, ypos, xSize - xgap, ySize - ygap, poster.colorScheme.graphicsColor[0], localGradientColor);
      }
    }
    poster.content.popMatrix();
    poster.content.endDraw();
  }
}

/////////////
/////////////

void PIShape(PGraphics pg, int verticesNumber, float x, float y, float xsize, float ysize, color c1) {
  PIShape(pg, verticesNumber, x, y, xsize, ysize, c1, false);
}

void PIShape(PGraphics pg, int verticesNumber, float x, float y, float xsize, float ysize, color c1, boolean ifGradient) {
  float rx = xsize/2;
  float ry = ysize/2;
  color c2;
  if (ifGradient) {
    c2 = color(red(c1), green(c1), blue(c1), 0);
  } else {
    c2 = c1;
  }
  float angle = TWO_PI/verticesNumber;

  //pg.beginDraw();
  ////////////
  pg.pushMatrix();
  pg.translate(x, y);
  pg.scale(rx, ry);

  if (verticesNumber == 4) {
    pg.beginShape();
    pg.noStroke();
    pg.fill(c1);
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
        pg.fill(c1);
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