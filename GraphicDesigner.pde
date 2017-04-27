class GraphicDesigner extends Observable {

  Graphic graphic;
  
  
  GraphicDesigner() {
    this.addObserver(progressManager.progressWatcher);
  }
  

  PGraphics createGrphic(Poster poster) {
    
    PGraphics result;
    
    if (random(0, 1) > 0.5) {
      graphic = new OffsetGraphic();
    } else {
      graphic = new PatternGraphic();
    }
    
    setChanged();
    notifyObservers();
    
    return poster;
  }
  
  
  
  
  
  
}