public abstract class Graphics {

  PGraphics graphics;
  String details;
  int w, h;
  float padding;
  Grid myGrid;

  Graphics (Poster poster, Grid _grid){
    myGrid = _grid;
    w = myGrid.w;
    h = myGrid.h;
    padding = poster.padding;
    initPGraphics();
    makeDecisions();
    design();
    inspector.addToMeta(details);
  }

  abstract void makeDecisions();

  abstract void design();

  public PGraphics getGraphics () {
    return graphics;
  }

  void addToDetails(String s) {
    details += s;
  }

  void initPGraphics(){
    graphics = createGraphics(w,h);
  }

}