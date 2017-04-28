import controlP5.*;
import java.util.Observable;
import java.util.Observer;


Stage STAGE;

ColorDesigner colorDesigner;
ProgressManager progressManager;
PrinterManager printerManager;
TypeDesigner typeDesigner;
GraphicDesigner graphicDesigner;
Inspector inspector;


int posterWidth = 3508;
int posterHeight = 4961;


//We will use this one object and rewrite it for every poster
Poster poster;


void settings () {
  size(1200, 600);
}

void setup () {
  pixelDensity(2);
  //Create our design crew
  colorDesigner = new ColorDesigner("colorSchemes.txt");
  typeDesigner = new TypeDesigner();
  graphicDesigner = new GraphicDesigner();
  progressManager = new ProgressManager();
  printerManager = new PrinterManager();
  inspector = new Inspector();

  //init
  STAGE = Stage.CREATION;
}


void draw() {
  background(20);

  switch (STAGE) {
  case CREATION:
    poster = new Poster(posterWidth, posterHeight);
    progressManager.updateTo(STAGE);
    STAGE = STAGE.next();
    delay(progressManager.stageDelay);
    break;

  case COLOR_DESIGN:
    colorDesigner.design(poster);
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;


  case GRAPHIC_DESIGN:
    graphicDesigner.design(poster);
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case TYPE_DESIGN:
    typeDesigner.design(poster);
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case INSPECTION:
    inspector.inspect(poster, progressManager.posterCount);
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case PRINT:
    printerManager.print(poster, progressManager.posterCount);
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;


  case FINISH:
    progressManager.updateTo(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;
  }

  progressManager.display();
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

//////////////////////////////////

/* Stage control */
public enum Stage {
  CREATION, COLOR_DESIGN, GRAPHIC_DESIGN, TYPE_DESIGN, INSPECTION, PRINT, FINISH {
    @Override
      public Stage next() {
      return values()[0];
    }
  };

  public Stage next() {
    return values()[ordinal() + 1];
  }
}