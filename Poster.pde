class Poster {

  float posterWidth;
  float posterHeight;

  ArrayList<Section> sections; //usually one poster can only have two sections, divided by golden ratio/silver ratio or 5/5
  float rotation;


  Poster(int _posterW, int _posterH) {
    posterWidth = _posterW;
    posterHeight = _posterH;
    initSections();
    setupRotation();
    
    if (typeDesigner==null) {
      TypeDesigner typeDesigner = new TypeDesigner();
      typeDesigner.design(this);
    } else {
      typeDesigner.design(this);
    }


    if (graphicDesigner==null) {
      GraphicDesigner graphicDesigner = new GraphicDesigner();
      graphicDesigner.design(this);
    } else {
      graphicDesigner.design(this);
    }
  }

  void sendToPrinter() {
  }


  void initSections() {
    // decide the global partition of this poster

    //TESTING
    //USE GOLDEN RATIO
    float aSectionHeight = posterHeight / 1.618;
    float bSectionHeight = posterHeight - aSectionHeight;


    sections.add(new Section());
  }

  void setupRotation() {
    // decide the global rotation of this poster

    //TESTING
    rotation = 0;
  }
}