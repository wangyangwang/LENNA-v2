import controlP5.*;
import java.util.Observable;
import java.util.Observer;

/* TODO: APR 30
 
 1. Add graphics to progressManager, display them correctly.
 2. .....
 
 */
Stage STAGE;
int stageNumber = STAGE.values().length;

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

void setup () {
  size(1440, 900);

  //Create our design crew
  colorDesigner = new ColorDesigner("colorSchemes.txt");
  typeDesigner = new TypeDesigner();
  graphicDesigner = new GraphicDesigner();
  progressManager = new ProgressManager();
  printerManager = new PrinterManager();
  inspector = new Inspector();


  //init, happen first
  STAGE = Stage.CREATION;
}


void draw() {
  background(100);

  /* for each stage the thumbnail will be updated */
  PGraphics thumbnail;

  switch (STAGE) {
  case CREATION:
    poster = new Poster(posterWidth, posterHeight);
    progressManager.update(STAGE);
    STAGE = STAGE.next();
    delay(progressManager.stageDelay);
    break;

  case COLOR_DESIGN:
    thumbnail = colorDesigner.design(poster);
    progressManager.update(STAGE, thumbnail);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case GRAPHIC_DESIGN:
    graphicDesigner.design(poster);
    thumbnail = graphicDesigner.design(poster);
    progressManager.update(STAGE, thumbnail);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case TYPE_DESIGN:
    typeDesigner.design(poster);
    thumbnail = typeDesigner.design(poster);
    progressManager.update(STAGE, thumbnail);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case INSPECTION:
    inspector.inspect(poster, progressManager.posterCount);
    progressManager.update(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case PRINT:
    printerManager.print(poster, progressManager.posterCount);
    progressManager.update(STAGE);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;


  case FINISH:
    progressManager.update(STAGE);
    progressManager.reset();
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