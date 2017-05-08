public abstract class Graphics {

  PGraphics graphics;
  String details;
  int w, h;

  Graphics (Poster poster, int _w, int _h){
    w = _w;
    h = _h;
    initPGraphics();
    initProbabilitySet();
    makeDecisions();
    design();
  }

  abstract void initProbabilitySet();
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
