public abstract class Graphics {

  //PGraphics graphics;
  String details = "";
  int w, h;
  float padding;
  Grid myGrid;
  int yoffset;

  Graphics (Poster poster, Grid _grid) {
    myGrid = _grid;
    w = myGrid.w;
    h = myGrid.h;
    padding = poster.padding;
    calculateYoffset();
    makeDecisions();
    addBackgroundToPoster();
    design();
    inspector.addToMeta(details);
  }

  abstract void makeDecisions();

  void addBackgroundToPoster() {
    poster.content.beginDraw();
    poster.content.background(poster.colorScheme.backgroundColor);
    poster.content.endDraw();
  }

  abstract void design();

  //public PGraphics getGraphics () {
  //  return graphics;
  //}

  void addToDetails(String s) {
    details += s;
  }

  void calculateYoffset() {
    if (myGrid.index == 0 || myGrid.fullHeight) {
      yoffset = 0;
    } else {
      yoffset = poster.grids.get(0).h;
    }
  }

  //void initPGraphics(){
  //  graphics = createGraphics(w,h);
  //}
}