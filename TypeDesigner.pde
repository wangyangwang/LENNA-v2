class TypeDesigner {  //<>// //<>// //<>//

  ArrayList<ProbabilityObject> columnWidthProbabilities;

  TypeDesigner () {
    setupColumnWidthAndProbability();
  }


  StageInfo design(Poster poster) {


    PGraphics designResult;
    designResult = createGraphics(poster.w, poster.h);
    designTypography(designResult, poster);
    applyGraphicToPoster(designResult, poster);

    String details = "Chose font: Helvetica\nHeadline: 1\nParagraph:0";


    //decide if headline exists
    //decide headline width, font, position
    //decide if paragraph exists
    //decide paragraph font
    //decide paragraph column number
    //decide paragraph position

    //draw Headline and Paragraph(s)
    //return result in PGraphic object
    StageInfo stageInfo = new StageInfo(details, designResult);
    return stageInfo;
  }

  private void designTypography(PGraphics pg, Poster poster) {
    pg.beginDraw();
    PFont helvetica;
    helvetica = createFont("helvetica", 100);
    pg.textFont(helvetica);
    pg.fill(poster.colorScheme.textColor);
    pg.noStroke();
    pg.textSize(400);
    pg.textAlign(CENTER, CENTER);
    pg.text("LENNA", poster.w/2, poster.h/2);
    pg.endDraw();
  }

  void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();
    poster.content.image(pg, 0, 0);
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
}