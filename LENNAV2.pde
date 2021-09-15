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

// PrintWriter log;

ArrayList<String> onScreenLog = new ArrayList<String>();

Stage STAGE;
int stageNumber = STAGE.values().length;

ColorDesigner colorDesigner;
//ProgressManager progressManager;
PrinterManager printerManager;
TypeDesigner typeDesigner;
GraphicDesigner graphicDesigner;
Inspector inspector;
PhdWriter phdWriter;
color inspectorBackground = color(100);

int posterCount = 0;
int stageDelay = 1000;

final int posterWidth = 2408;
final int posterHeight = 3508;

//We will use this one object and rewrite it for every poster
Poster poster;

void setup () {
  size(200, 200, P3D);
  textMode(SHAPE);
  smooth(0);
  // log = createWriter("server/lenna.log");

  //add css
  // print("<html><head><script src=\"jquery-3.6.0.min.js\"></script><script src=\"main.js\"></script><style>img { width: 100%; margin: 20px 0px; } body {fontSize: 25px; padding: 20px; background:rgb(230,230,230);line-height:1.2em;} </style></head><body>");

  //Create our design crew
  print("Intilazing color designer...");
  colorDesigner = new ColorDesigner("colorSchemes.txt");
  background(255,0,0);
  print("Intilazing type designer...");
  typeDesigner = new TypeDesigner();
  background(0,255,0);
  print("Intilazing graphic designer...");
  graphicDesigner = new GraphicDesigner();
  background(0,0,255);
  print("Intilazing progress interface manager...");
  //progressManager = new ProgressManager();
  print("Intilazing print manager...");
  printerManager = new PrinterManager();
  print("Intilazing inspector...");
  inspector = new Inspector();
  phdWriter = new PhdWriter();


  //init, happen first
  STAGE = Stage.CREATION;
}


void draw() {
  background(inspectorBackground);

  /* for each stage the stageInfo will be updated */
  StageInfo stageInfo;

  switch(STAGE) {
  case CREATION:
    print("\n\n--------------------Staring a new design--------------------\n");
    poster = new Poster(posterWidth, posterHeight);
    stageInfo = new StageInfo(poster.details);
    //progressManager.update(STAGE, stageInfo);
    STAGE = STAGE.next();
    delay(stageDelay);
    print("...");
    break;

  case COLOR_DESIGN:
    stageInfo = colorDesigner.design(poster);
    //progressManager.update(STAGE, stageInfo);
    delay(stageDelay);
    STAGE = STAGE.next();
    print("...");
    break;

  case GRAPHIC_DESIGN:
    stageInfo = graphicDesigner.design(poster);
    //progressManager.update(STAGE, stageInfo);
    delay(stageDelay);
    STAGE = STAGE.next();
    print("...");
    break;

  case TYPE_DESIGN:
    stageInfo = typeDesigner.design(poster);
    //progressManager.update(STAGE, stageInfo);
    delay(stageDelay);
    STAGE = STAGE.next();
    //print("...");
    break;

  case INSPECTION:
    stageInfo = inspector.inspect(poster, posterCount);
    //progressManager.update(STAGE, stageInfo);
    delay(stageDelay);
    STAGE = STAGE.next();
    //print("...");
    break;

  case PRINT:
    stageInfo = printerManager.print2paper(poster);
    //progressManager.update(STAGE, stageInfo);
    delay(stageDelay);
    STAGE = STAGE.next();
    //print("...");
    break;

  case FINISH:
    //progressManager.update(STAGE);
    //progressManager.reset();
    posterCount++;
    inspector.reset();
    delay(stageDelay);
    STAGE = STAGE.next();
    //print("...");
    break;
  }

  //progressManager.display();
  //log.flush();
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
    System.err.print("objectList.length!=probabilityList.length, picking has to stop" + objectList[0]);
    // exit();
  }

  ArrayList<ProbabilityObject> set = new ArrayList<ProbabilityObject>();
  for (int i = 0; i < objectList.length; i++) {
    set.add(new ProbabilityObject(objectList[i], probabilityList[i]));
  }

  return getObjectByProbability(set).value;
}

//////////////////////////////




// String getPomoHeadline() {

// 	GetRequest get = new GetRequest("http://www.elsewhere.org/journal/pomo/");
// 	get.send();
// 	String content = get.getContent();
// 	Document doc = Jsoup.parse(content);
// 	Elements li = doc.getElementsByTag("h1");
// 	String result = li.get(0).html();
// 	result = result.replaceAll("\n", "");
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
