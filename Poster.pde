class Poster {

  int w;
  int h;

  ArrayList<Section> sections; //usually one poster can only have two sections, divided by golden ratio/silver ratio or 5/5
  float rotation;
  ColorScheme colorScheme;

  PGraphics content;



  Poster(int _posterW, int _posterH) {
    w = _posterW;
    h = _posterH;
    initSections();
    setupRotation();
    content = createGraphics(w, h);
  }


  void initSections() {
    // decide the global partition of this poster

    //TESTING
    //USE GOLDEN RATIO
    float aSectionHeight = h / 1.618;
    float bSectionHeight = h - aSectionHeight;


    //sections.add(new Section());
  }

  void setupRotation() {
    // decide the global rotation of this poster

    //TESTING
    rotation = 0;
  }
}


//////////////////////////////////////////////////


class Section {
  boolean occupied;
  float h, w;
  color background;
}