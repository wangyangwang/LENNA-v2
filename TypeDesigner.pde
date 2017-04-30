class TypeDesigner {  //<>//

  ArrayList<PassabilityObject> columnWidthPassabilities;

  TypeDesigner () {
    setupColumnWidthAndPassability();
  }


  PGraphics design(Poster poster) {
    PGraphics designResult;
    designResult = createGraphics(poster.w, poster.h);
    designTypography(designResult, poster);
    applyGraphicToPoster(designResult, poster);
    return designResult;

    //decide if headline exists
    //decide headline width, font, position
    //decide if paragraph exists
    //decide paragraph font
    //decide paragraph column number
    //decide paragraph position



    //draw Headline and Paragraph(s)
    //return result in PGraphic object
  }

  private void designTypography(PGraphics pg, Poster poster) {
    pg.beginDraw();
    PFont helvetica;
    helvetica = createFont("helvetica", 100);
    pg.textFont(helvetica);


    println("Graphic Designer picked background color: " + hex(poster.colorScheme.colors[1]));
    pg.fill(poster.colorScheme.colors[1]);


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


  void setupColumnWidthAndPassability() {

    float[] widths = {1/2, 1/3, 1/4};
    float[] passabilities = {1/3, 1/3, 1/3};

    columnWidthPassabilities = new ArrayList<PassabilityObject>();
    if (widths.length == passabilities.length) {
      for (int i=0; i<widths.length; i++) {
        columnWidthPassabilities.add(new PassabilityObject(widths[i], passabilities[i]));
      }
    } else {
      System.err.println("TypeDesigner - setup column width passability failed!");
    }
  }
}