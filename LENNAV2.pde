import controlP5.*;


/*

 TODO: graphic design
 1. partition
 2. rotation
 
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

  /* for each stage the stageInfo will be updated */
  StageInfo stageInfo;

  switch (STAGE) {
  case CREATION:
    poster = new Poster(posterWidth, posterHeight);
    stageInfo = new StageInfo(poster.posterDetails);
    progressManager.update(STAGE, stageInfo);
    STAGE = STAGE.next();
    delay(progressManager.stageDelay);
    break;

  case COLOR_DESIGN:
    stageInfo = colorDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case GRAPHIC_DESIGN:
    stageInfo = graphicDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case TYPE_DESIGN:
    stageInfo = typeDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case INSPECTION:
    stageInfo = inspector.inspect(poster, progressManager.posterCount);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    break;

  case PRINT:
    stageInfo = printerManager.print(poster, progressManager.posterCount);
    progressManager.update(STAGE, stageInfo);
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