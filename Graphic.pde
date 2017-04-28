/* Parent Class */
class Graphic extends Observable {
  
  PGraphics finalGraphic;
  
  
  
  PGraphics getGraphic() {
    return finalGraphic;
  }
  
  
}


/* Children Classes */
////////////////////////////////////////////////////


class FullScreenTypeGraphic extends Graphic {
  
}

////////////////////////////////////////////////////

class PatternGraphic extends Graphic {
  
}


////////////////////////////////////////////////////

class OffsetGraphic extends Graphic {
  
}

////////////////////////////////////////////////////