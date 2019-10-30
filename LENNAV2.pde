//import controlP5.*;
import org.apache.commons.lang3.*;
import org.jsoup.*;
//import org.jsoup.examples.*;
import org.jsoup.helper.*;
import org.jsoup.nodes.*;
import org.jsoup.parser.*;
import org.jsoup.safety.*;
import org.jsoup.select.*;
import org.apache.commons.lang3.text.*;
import http.requests.*;
import java.io.IOException;
import processing.pdf.*;
import java.lang.Runtime;

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

PrintWriter log;
Stage STAGE;
int stageNumber = STAGE.values().length;

ColorDesigner colorDesigner;
ProgressManager progressManager;
PrinterManager printerManager;
TypeDesigner typeDesigner;
GraphicDesigner graphicDesigner;
Inspector inspector;
color inspectorBackground = color(100);

final int posterWidth = 2408;
final int posterHeight = 3508;

//We will use this one object and rewrite it for every poster
Poster poster;

void setup () {
  size(540, 960, P3D);
  pixelDensity(2);
  textMode(SHAPE);
  smooth(4);
  log = createWriter("lenna.log");
  log.println("initializing objects...");

  //Create our design crew
  log.println("Intilazing color designer...");
  colorDesigner = new ColorDesigner("colorSchemes.txt");
  log.println("Intilazing type designer...");
  typeDesigner = new TypeDesigner();
  log.println("Intilazing graphic designer...");
  graphicDesigner = new GraphicDesigner();
  log.println("Intilazing progress interface manager...");
  progressManager = new ProgressManager();
  log.println("Intilazing print manager...");
  printerManager = new PrinterManager();
  log.println("Intilazing inspector...");
  inspector = new Inspector();


  //init, happen first
  STAGE = Stage.CREATION;
}


void draw() {
  background(inspectorBackground);

  /* for each stage the stageInfo will be updated */
  StageInfo stageInfo;

  switch (STAGE) {
  case CREATION:
    log.println("====================NEW POSTER========================");
    poster = new Poster(posterWidth, posterHeight);
    stageInfo = new StageInfo(poster.details);
    progressManager.update(STAGE, stageInfo);
    STAGE = STAGE.next();
    delay(progressManager.stageDelay);
    log.println("-------------");
    break;

  case COLOR_DESIGN:
    stageInfo = colorDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;

  case GRAPHIC_DESIGN:
    stageInfo = graphicDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;

  case TYPE_DESIGN:
    stageInfo = typeDesigner.design(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;

  case INSPECTION:
    stageInfo = inspector.inspect(poster, progressManager.posterCount);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;

  case PRINT:
    stageInfo = printerManager.print(poster);
    progressManager.update(STAGE, stageInfo);
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;

  case FINISH:
    progressManager.update(STAGE);
    progressManager.reset();
    inspector.reset();
    delay(progressManager.stageDelay);
    STAGE=STAGE.next();
    log.println("-------------");
    break;
  }

  progressManager.display();
  log.flush();
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

//////////////////////////////////

Object pickByProbability(Object[] objectList, int[] probabilityList) {
  if (objectList.length!=probabilityList.length) {
    System.err.println("objectList.length!=probabilityList.length, picking has to stop" + objectList[0]);
    // exit();
  }

  ArrayList<ProbabilityObject> set = new ArrayList<ProbabilityObject>();
  for (int i = 0; i < objectList.length; i++) {
    set.add(new ProbabilityObject(objectList[i], probabilityList[i]));
  }

  return getObjectByProbability(set).value;
}

//////////////////////////////

String getContent(int minWords, int maxWords) {
  JSONObject json;
  GetRequest get = new GetRequest("http://www.randomtext.me/api/gibberish/ul-1/"+minWords+"-"+maxWords);
  get.send();
  String content = get.getContent();
  try {
    json = JSONObject.parse(content);
    String text_out = json.getString("text_out");
    Document doc = Jsoup.parse(text_out);
    Elements li = doc.getElementsByTag("li");
    return li.get(0).html();
  }
  catch(Exception e) {
    System.err.println(e);
    return "A software bug is an error, flaw, failure or fault in a computer program or system that causes it to produce an incorrect or unexpected result";
  }
}

// String getPomoHeadline() {

// 	GetRequest get = new GetRequest("http://www.elsewhere.org/journal/pomo/");
// 	get.send();
// 	String content = get.getContent();
// 	Document doc = Jsoup.parse(content);
// 	Elements li = doc.getElementsByTag("h1");
// 	String result = li.get(0).html();
// 	result = result.replaceAll("<br>", "");
// 	if (result.contains(":")) {
// 		result = result.substring(0, result.indexOf(":"));
// 	}
// 	if (result.contains("in the")) {
// 		result = result.substring(0, result.indexOf("in the"));
// 	}

// 	if (result.length() > 20) {
// 		String[] words = result.split(" ");
// 		result = words[floor(random(words.length))];
// 		result = result.substring(0, 1).toUpperCase() + result.substring(1);
// 	}

// 	return result;
// }

String getRandomTOEFLword() {
  String theword;
  String[] lines = loadStrings("words.txt");
  int randomIndex = floor(random(lines.length));
  theword = lines[randomIndex];
  theword = theword.substring(0, 1).toUpperCase() + theword.substring(1);
  return theword;
}
