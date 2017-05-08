import controlP5.*;
import org.apache.commons.lang3.*;
import org.jsoup.*;
import org.jsoup.examples.*;
import org.jsoup.helper.*;
import org.jsoup.nodes.*;
import org.jsoup.parser.*;
import org.jsoup.safety.*;
import org.jsoup.select.*;
import org.apache.commons.lang3.text.*;
import http.requests.*;
import java.io.IOException;
import processing.pdf.*;


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

//////////////////////////////////

Stage STAGE;
int stageNumber = STAGE.values().length;

ColorDesigner colorDesigner;
ProgressManager progressManager;
PrinterManager printerManager;
TypeDesigner typeDesigner;
GraphicDesigner graphicDesigner;
Inspector inspector;

int posterWidth = 595;
int posterHeight = 842;

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
  background(126);

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

/* Object with a probability*/
public class ProbabilityObject {
  public Object value;
  public int probability;
  public ProbabilityObject(Object _value, int _probability) {
    value = _value;
    probability = _probability;
  }
}

//////////////////////////////////

ProbabilityObject getObjectByProbability(ArrayList<ProbabilityObject> list) {
  IntList probabilityPool = new IntList();
  int listIndex = 0;
  for (ProbabilityObject PO : list) {
    for (int i = 0; i < PO.probability; i++) {
      probabilityPool.append(listIndex);
    }
    listIndex++;
  }
  int rando = floor(random(probabilityPool.size()));
  return list.get(probabilityPool.get(rando));
}