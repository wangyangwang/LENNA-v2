//decide if headline exists //<>//
//decide headline width, font, position
//decide if paragraph exists
//decide paragraph font
//decide paragraph column number
//decide paragraph position

//draw Headline and Paragraph(s)
//return result in PGraphic object


class TypeDesigner {

  ArrayList<ProbabilityObject> columnWidthProbabilities;
  ArrayList<PFont> fonts;
  Grid myGrid;



  TypeDesigner () {
    setupColumnWidthAndProbability();
    setupFonts();
  }



  //Main Function
  StageInfo design(Poster poster) {
    //setup variables
    PGraphics generatedTypes;
    for (Grid g : poster.grids) {
      if (g.contentType == "letters")myGrid = g;
    }
    println(myGrid.w + " , " + myGrid.h);
    generatedTypes = createGraphics(myGrid.w, myGrid.h);


    getColumnNumber();
    //getHeadlineContent();
    //getParagraphContent();

    designTypography(generatedTypes, poster);
    applyGraphicToPoster(generatedTypes, poster);

    String details = "Chose font: Helvetica\nHeadline: 1\nParagraph:0";
    StageInfo stageInfo = new StageInfo(details, generatedTypes);
    return stageInfo;
  }

  void getColumnNumber() {
  }

  private void designTypography(PGraphics pg, Poster poster) {
    String headlineContent = getContent(1, 1);
    pg.beginDraw();
    pg.fill(poster.colorScheme.textColor);
    pg.noStroke();
    pg.textSize(400);
    int yPadding  = 500;
    pg.textAlign(LEFT, TOP);
    if (myGrid.index == 0) {
      pg.text(headlineContent, 0, myGrid.h - yPadding );
    } else {
      pg.text(headlineContent, 0, yPadding);
    }
    pg.endDraw();
  }


  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    int y = myGrid.index * poster.grids.get(0).h;
    poster.content.image(pg, 0, y);
    poster.content.endDraw();
  }


  void setupColumnWidthAndProbability() {
    float[] widths = {1/2, 1/3, 1/4};
    int[] probabilities = {33, 33, 34};
    columnWidthProbabilities = new ArrayList<ProbabilityObject>();
    if (widths.length == probabilities.length) {
      for (int i=0; i<widths.length; i++) {
        columnWidthProbabilities.add(new ProbabilityObject(widths[i], probabilities[i]));
      }
    } else {
      System.err.println("TypeDesigner - setup column width probability failed!");
    }
  }

  void setupFonts() {
    fonts = new ArrayList<PFont>();
    fonts.add(createFont("Helvetica", 500));
  }


  String getContent(int minWords, int maxWords) {
    JSONObject json;
    GetRequest get = new GetRequest("http://www.randomtext.me/api/gibberish/ul-1/"+minWords+"-"+maxWords);
    get.send();
    String content = get.getContent();
    json = JSONObject.parse(content);
    String text_out = json.getString("text_out");
    Document doc = Jsoup.parse(text_out);
    Elements li = doc.getElementsByTag("li");
    return li.get(0).html();
  }
}