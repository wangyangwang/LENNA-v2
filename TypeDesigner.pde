class TypeDesigner extends Observable {
  PGraphics result;
  ArrayList<PassabilityObject> columnWidthPassabilities;

  TypeDesigner () {
    setupColumnWidthAndPassability();
  }


  PGraphics design() {


    //decide if headline exists
    //decide headline width, font, position
    //decide if paragraph exists
    //decide paragraph font
    //decide paragraph column number
    //decide paragraph position
    
    
    
    //draw Headline and Paragraph(s)
    //return result in PGraphic object 
    
    
    return 
   
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