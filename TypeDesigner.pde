class TypeDesigner {

  String[] allFonts = new String[] {"Helvetica-Medium", "Futura", "Avenir-Medium", "Univers-Roman", "Gotham"};
  String[] allFontsBold = new String[] {"Helvetica-Bold", "Futura-Medium", "Avenir-Heavy", "Univers-Bold", "Gotham-Medium"};

  ArrayList<PFont> fonts;
  ArrayList<PFont> boldFonts;
  Grid myGrid;
  int textAlignX;

  TypeDesigner () {
    setupFonts();
  }

  void setupFonts() {
    fonts = new ArrayList<PFont>();
    boldFonts = new ArrayList<PFont>();

    for (int i = 0; i < allFonts.length; i++) {
      fonts.add(createFont(allFonts[i], 500));
      boldFonts.add(createFont(allFontsBold[i], 500));
    }
  }

  ///////////////////////////
  StageInfo design(Poster poster) {
    String details = "";

    myGrid = poster.grids.get(poster.partitionArrangement.get("letters"));
    PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);

    // choose font
    int randomFontIndex = floor(random(fonts.size()));
    PFont font = fonts.get(randomFontIndex);
    PFont boldFont = boldFonts.get(randomFontIndex);
    details+="Font:   "+font.getName() + "\n";

    //text vertical alignment
    textAlignX = LEFT;
    details+="Global X Alignment:   "+textAlignX + "\n";

    // headline font size
    float minHeadlineSize = 0.025 * posterHeight;
    float maxHeadlineSize = 0.06 * posterHeight;
    int headlineFontSize = (int)random(minHeadlineSize, maxHeadlineSize);
    details+="headlineFontSize:   " + headlineFontSize + "\n";

    // headline width
    Float[] headlineWidths = new Float[] {0.9};
    int[] headlineWidthProbabilities = new int[] {100};
    int headlineWidth = floor(((float)pickByProbability(headlineWidths, headlineWidthProbabilities)) * (posterWidth - poster.padding * 2));

    //headline underline
    // boolean underline = false;
    // if(random(0,1)>0.0){
    //     underline = true;
    // }

    // paragraph font size
    float minColumnFontSize = 0.010 * posterHeight;
    float maxColumnFontSize = 0.012 * posterHeight;
    int columnFontSize = (int)random(minColumnFontSize, maxColumnFontSize);
    details += "Paragraph Font Size:   " + columnFontSize + "\n";

    // headline vs paragraph arrangement
    int[] headlinePosition = new int[]{poster.padding, 0};
    int headlineLocation;
    int headlineAlignX = textAlignX;
    int headlineAlignY;

    if (random(0, 1) > 0.5) { //headline on top
      headlinePosition[1] = poster.padding;
      headlineAlignY = TOP;
      headlineLocation = 0;
    } else { //headline on bottom
      headlinePosition[1] = myGrid.h - poster.padding;
      headlineAlignY = BOTTOM;
      headlineLocation = 1;
    }

    //column Count
    int columnCount;
    Integer[] columnCounts = new Integer[] {1, 2, 3};
    int[] columnCountsProbabilities = new int[] {30, 60, 10};
    columnCount = (int)pickByProbability(columnCounts, columnCountsProbabilities);

    details += "Paragraph Count:   " + columnCount + "\n";

    //column width
    int columnWidth = floor(((posterWidth - poster.padding * 2) / columnCount) * random(0.7, 0.9));

    //space between headline and columns
    int spaceingBetweenHeadlineAndColumns = floor( posterHeight * 0.024 );

    //column max height
    int columnMaxHeight = floor( myGrid.h - poster.padding * 2 - headlineFontSize - spaceingBetweenHeadlineAndColumns );

    //column spacing
    float spacingBetweenColumns = posterWidth * 0.03;

    //headline color
    color headlineColor = poster.colorScheme.textColor;

    //column color
    color columnColor = poster.colorScheme.textColor;

    details += "Text Color:   " + columnColor + "\n";


    float yoffset = myGrid.index * (posterHeight - myGrid.h);

    // create headline objects
    Text headline = new Text("headline", headlineFontSize);
    int headlineRectHeight = 10000;
    if (headlineLocation==1) headlineRectHeight *= -1;
    headline.setBound(headlinePosition[0], headlinePosition[1] + (int)yoffset, headlineWidth, headlineRectHeight);
    headline.setContent(getPomoHeadline());
    headline.setColor(headlineColor);
    headline.setFont(boldFont);
    headline.setAlign(headlineAlignX, headlineAlignY);
    // if(underline){
    //     headline.addLine(posterWidth - poster.padding * 2, 5);
    // }

    // create column objects
    ArrayList<Text> columns = new ArrayList<Text>();
    for (int i = 0; i < columnCount; i++) {
      Text col = new Text("column", columnFontSize);
      int colY = floor((headlineFontSize + spaceingBetweenHeadlineAndColumns) * (1 - headlineLocation)  +  poster.padding);
      col.setBound(floor(poster.padding + i * (columnWidth + spacingBetweenColumns)), colY+(int)yoffset, columnWidth, columnMaxHeight);
      col.setContent(getContent(15, 25));
      col.setColor(columnColor);
      col.setFont(font);
      col.setAlign(textAlignX, TOP);
      columns.add(col);
    }


    //Draw them to the graphics
    poster.content.beginDraw();
    poster.content.blendMode(BLEND);
    poster.content.endDraw();

    headline.drawOn(poster.content);
    for (Text col : columns) {
      col.drawOn(poster.content);
    }

    //"print" the design on main PGraphics

    //applyGraphicToPoster(generatedPGraphics, poster);

    StageInfo stageInfo = new StageInfo(details);

    inspector.addToMeta(details);

    return stageInfo;
  }

  //  void applyGraphicToPoster(PGraphics pg, Poster poster) {
  //    poster.content.beginDraw();
  //    float y = myGrid.index * (posterHeight - myGrid.h);
  //    poster.content.image(pg, 0, (int)y);
  //    poster.content.endDraw();
  //  }
}