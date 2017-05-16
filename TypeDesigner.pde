class TypeDesigner {

  String[] allFonts = new String[] {"Helvetica-Bold", "Futura", "Avenir-Heavy", "PT-mono"};
  ArrayList<PFont> fonts;
  Grid myGrid;
  String details;
  int textAlignX;


  TypeDesigner () {
    setupFonts();
  }
  void setupFonts() {
    fonts = new ArrayList<PFont>();
    for (String f : allFonts) {
      fonts.add(createFont(f, 500));
    }
  }

  ///////////////////////////
  StageInfo design(Poster poster) {

    myGrid = poster.grids.get(poster.partitionArrangement.get("letters"));
    PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);

    // choose font
    PFont font = fonts.get(floor(random(fonts.size())));

    generatedPGraphics.beginDraw();
    generatedPGraphics.textFont(font);
    generatedPGraphics.endDraw();

    //text vertical alignment
    textAlignX = LEFT;

    // headline font size
    float minHeadlineSize = 0.03 * posterHeight;
    float maxHeadlineSize = 0.09 * posterHeight;
    int headlineFontSize = (int)random(minHeadlineSize, maxHeadlineSize);


    // headline width
    Float[] headlineWidths = new Float[] {0.9};
    int[] headlineWidthProbabilities = new int[] {100};
    int headlineWidth = floor(((float)pickByProbability(headlineWidths, headlineWidthProbabilities)) * (posterWidth - poster.padding * 2));

    //headline color
    color headlineColor = color(0);

    // paragraph font size
    float minColumnFontSize = 0.008 * posterHeight;
    float maxColumnFontSize = 0.011 * posterHeight;
    int columnFontSize = (int)random(minColumnFontSize, maxColumnFontSize);

    // headline vs paragraph arrangement
    int[] headlinePosition = new int[]{poster.padding, 0};
    int headlineLocation;
    int headlineAlignX = textAlignX;
    int headlineAlignY;
    if (random(0, 1) > 0.5) {
      headlinePosition[1] = poster.padding;
      headlineAlignY = TOP;
      headlineLocation = 0;
    } else {
      headlinePosition[1] = myGrid.h - poster.padding;
      headlineAlignY = BOTTOM;
      headlineLocation = 1;
    }

    //column Count
    int columnCount;
    Integer[] columnCounts = new Integer[] {1, 2, 3, 4};
    int[] columnCountsProbabilities = new int[] {5, 45, 30, 10};
    columnCount = (int)pickByProbability(columnCounts, columnCountsProbabilities);

    //column color
    color columnColor = color(0);

    //column width
    int columnWidth = floor(((posterWidth - poster.padding * 2) / columnCount) * random(0.7, 0.9));

    //space between headline and columns
    int spaceingBetweenHeadlineAndColumns = floor(headlineFontSize * 0.3);

    //column max height
    int columnMaxHeight = floor( myGrid.h - poster.padding * 2 - headlineFontSize - spaceingBetweenHeadlineAndColumns );

    //column spacing
    float spacingBetweenColumns = posterWidth * 0.03;

    // create headline objects
    Text headline = new Text("headline", headlineFontSize);
    headline.setBound(headlinePosition[0], headlinePosition[1], headlineWidth, 99999);
    headline.setContent(getContent(1, 1));
    headline.setColor(headlineColor);
    headline.setAlign(headlineAlignX, headlineAlignY);

    // create column objects
    ArrayList<Text> columns = new ArrayList<Text>();
    for (int i = 0; i < columnCount; i++) {
      Text col = new Text("column", columnFontSize);
      int colY = floor((headlineFontSize + spaceingBetweenHeadlineAndColumns) * (1 - headlineLocation)  +  poster.padding);
      col.setBound(floor(poster.padding + i * (columnWidth + spacingBetweenColumns)), colY, columnWidth, columnMaxHeight);
      col.setContent(getContent(15, 25));
      col.setColor(columnColor);
      col.setAlign(textAlignX, TOP);
      columns.add(col);
    }

    //Draw them to the graphics
    headline.drawOn(generatedPGraphics);
    for (Text col : columns) {
      col.drawOn(generatedPGraphics);
    }


    //"print" the design on main PGraphics
    applyGraphicToPoster(generatedPGraphics, poster);

    details = "Chose font:   "+font.getName()+"\nHeadline:   1\nParagraph:   0\nTypography Grid Width:   " + myGrid.w + "\nTypography Grid Height:   " + myGrid.h;
    StageInfo stageInfo = new StageInfo(details, generatedPGraphics);
    return stageInfo;
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    int y;
    if (!myGrid.fullHeight) {
      y = myGrid.index * poster.grids.get(0).h;
    } else {
      y = 0;
    }
    poster.content.image(pg, 0, y);
    poster.content.endDraw();
  }
}