class TypeDesigner {

  //const
  final String[] allFonts = new String[] {
    "Helvetica",
    "Futura",
    "Avenir-Medium",
    "LexendDeca-Regular",
    "Montserrat-Medium",
    "Inconsolata-Regular",
    "Urbanist-Medium",
    "Arimo-Medium"
  };

  final String[] allFontsBold = new String[] {
    "Helvetica-Bold",
    "Futura-Medium",
    "Avenir-Heavy",
    "LexendDeca-Regular",
    "Montserrat-Bold",
    "Inconsolata-Bold",
    "Urbanist-Black",
    "Arimo-SemiBold"
  };

  final ArrayList<PFont> fonts = new ArrayList<PFont>();
  final ArrayList<PFont> boldFonts = new ArrayList<PFont>();

  final int textAlignX = LEFT;
  final int columnTextMinNumber = 10;
  final int columnTextMaxNumber = 20;

  // poster by poster
  Grid myGrid;
  float noColumnProbability = 0.1;



  TypeDesigner () {
    setupFonts();
  }

  void setupFonts() {
    //fonts = new ArrayList<PFont>();
    //boldFonts = new ArrayList<PFont>();

    for (int i = 0; i < allFonts.length; i++) {
      fonts.add(createFont(allFonts[i], 500));
      boldFonts.add(createFont(allFontsBold[i], 500));
    }
  }

  ///////////////////////////
  StageInfo design(Poster poster) {
    String details = "";
    myGrid = poster.grids.get(poster.partitionArrangement.get("letters"));

    // choose font
    int randomFontIndex = floor(random(fonts.size()));
    PFont font = fonts.get(randomFontIndex);
    PFont boldFont = boldFonts.get(randomFontIndex);
    String fontname = font.getName();
    details+="Font:   " + fontname + "\n";
    log.print("Picked font: \033[1;34m["+fontname+"\033[0m\033[0m\n");


    //text vertical alignment
    details+="Global X Alignment:   "+textAlignX;
    log.print("Text vertical align\033[1;34m"+textAlignX+"\033[0m\n");


    // headline width
    Float[] headlineWidths = new Float[] {1.0};
    int[] headlineWidthProbabilities = new int[] {1};
    int headlineWidth = floor(((float)pickByProbability(headlineWidths, headlineWidthProbabilities)) * (posterWidth - poster.padding * 2));

    // paragraph font size
    float minColumnFontSize = 0.009 * posterHeight;
    float maxColumnFontSize = 0.014 * posterHeight;
    int columnFontSize = (int)random(minColumnFontSize, maxColumnFontSize);
    details += "Paragraph Font Size:   " + columnFontSize + "\n";
    log.print("Column font size\033[1;34m"+columnFontSize+"\033[0m\n");

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

    // headline font size
    float minHeadlineSize = 0.13 * posterHeight;
    float maxHeadlineSize = 0.20 * posterHeight;
    int headlineFontSize;
    headlineFontSize= (int)random(minHeadlineSize, maxHeadlineSize);
    details+="headlineFontSize:   " + headlineFontSize + "\n";
    log.print("Headline font size: \033[1;34m "+headlineFontSize+"\033[0m\n");

    //column Count
    int columnCount;
    Integer[] columnCounts = new Integer[] {1, 2, 4};
    int[] columnCountsProbabilities = new int[] {1, 4, 5};
    columnCount = (int)pickByProbability(columnCounts, columnCountsProbabilities);
    details += "Paragraph Count:   " + columnCount + "\n";
    log.print("Column number\033[1;34m"+columnCount+"\033[0m\n");


    //column width
    float columnWidth = ((posterWidth - poster.padding * 2) / columnCount) * 0.9;
    log.print("Column width\033[1;34m"+columnWidth+"\033[0m\n");

    //space between headline and columns
    int spaceingBetweenHeadlineAndColumns = floor( posterHeight * 0.024 );

    //column max height
    int columnMaxHeight;
    if (headlineLocation==1) {
      columnMaxHeight = floor( myGrid.h - poster.padding * 2 - headlineFontSize - spaceingBetweenHeadlineAndColumns );
    } else {
      columnMaxHeight = 10000;
    }
    //int columnMaxHeight = 10000;

    //column spacing
    float spacingBetweenColumns = ((posterWidth - poster.padding * 2) / columnCount) * 0.1;

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
    headline.setContent(getRandomTOEFLword());
    log.print("Title decided: \033[1;34m "+headline.content+"\033[0m\n");
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
      col.setBound(floor(poster.padding + i * (columnWidth + spacingBetweenColumns)), colY+(int)yoffset, (int)columnWidth, columnMaxHeight);
      col.setContent(phdWriter.getOneSentence());
      log.print("column " + i + "content: \033[1;34m "+col.content+"\033[0m\n");
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
