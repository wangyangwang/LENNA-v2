import controlP5.*;
import java.util.Observable;
import java.util.Observer;


Stage STAGE;


ProgressManager progressManager;
PrinterManager printerManager;
TypeDesigner typeDesigner;
GraphicDesigner graphicDesigner;
Inspector inspector;


int posterWidth = 2480;
int posterHeight = 3508;


//We will use this one object and rewrite it for every poster
Poster poster;

void settings () {
  size(1440, 900);
}

void setup () {
  
  //Create our design crew
  typeDesigner = new TypeDesigner();
  graphicDesigner = new GraphicDesigner();
  progressManager = new ProgressManager();
  printerManager = new PrinterManager();
  inspector = new Inspector();

  //init
  STAGE = Stage.CREATION;

}


void draw() {

  switch (STAGE) {
  case CREATION:
    poster = new Poster(posterWidth, posterHeight);
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;

  case TYPEDESIGN:
    typeDesigner.design(poster);
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;

  case GRAPHICDESIGN:
    graphicDesigner.design(poster);
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;

  case INSPECTION:
    inspector.inspect(poster);
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;

  case PRINT:
    printerManager.print(poster);
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;


  case FINISH:
    progressManager.updateTo(STAGE);
    STAGE.next();
    break;
  }

}


//////////////////////////////////
//////////////////////////////////

/* Object with a passability*/
public class PassabilityObject {
  public Object value;
  public float passability;
  public PassabilityObject(Object _value, float _passability) {
    value = _value;
    passability = _passability;
  }
}


/* Stage control */
public enum Stage {
  CREATION, TYPEDESIGN, GRAPHICDESIGN, INSPECTION, PRINT, FINISH {
    @Override
      public Stage next() {
      return values()[0];
    }
  };

  public Stage next() {
    return values()[ordinal() + 1];
  }
}