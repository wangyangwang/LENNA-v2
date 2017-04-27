class PatternGraphic extends Graphic {
  
  
  
  void finishGraphic () {
   setChanged();
   notifyObservers();
  }
  
}