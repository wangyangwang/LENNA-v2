public abstract class Graphics {

  PGraphics graphics;
  String details;
  int w, h;
  int myGridIndex;

  Graphics (Poster poster, int _w, int _h, int _myGridIndex){
    w = _w;
    h = _h;
    myGridIndex = _myGridIndex;
    initPGraphics();
    makeDecisions();
    design();
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
