import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.apache.commons.lang3.*; 
import org.jsoup.*; 
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

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LENNAV2 extends PApplet {

//import controlP5.*;


//import org.jsoup.examples.*;











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
int inspectorBackground = color(100);

final int posterWidth = 2408;
final int posterHeight = 3508;

//We will use this one object and rewrite it for every poster
Poster poster;

public void setup () {
	
	
	textMode(SHAPE);
	
	log = createWriter("lenna.log");
	log.print("initializing objects...");

	//Create our design crew
	log.print("Intilazing color designer...");
	colorDesigner = new ColorDesigner("colorSchemes.txt");
	log.print("Intilazing type designer...");
	typeDesigner = new TypeDesigner();
	log.print("Intilazing graphic designer...");
	graphicDesigner = new GraphicDesigner();
	log.print("Intilazing progress interface manager...");
	progressManager = new ProgressManager();
	log.print("Intilazing print manager...");
	printerManager = new PrinterManager();
	log.print("Intilazing inspector...");
	inspector = new Inspector();


	//init, happen first
	STAGE = Stage.CREATION;
}


public void draw() {
	background(inspectorBackground);

	/* for each stage the stageInfo will be updated */
	StageInfo stageInfo;

	switch (STAGE) {
	case CREATION:
		log.print("====================NEW POSTER========================");
		poster = new Poster(posterWidth, posterHeight);
		stageInfo = new StageInfo(poster.details);
		progressManager.update(STAGE, stageInfo);
		STAGE = STAGE.next();
		delay(progressManager.stageDelay);
		log.print("-------------");
		break;

	case COLOR_DESIGN:
		stageInfo = colorDesigner.design(poster);
		progressManager.update(STAGE, stageInfo);
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
		break;

	case GRAPHIC_DESIGN:
		stageInfo = graphicDesigner.design(poster);
		progressManager.update(STAGE, stageInfo);
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
		break;

	case TYPE_DESIGN:
		stageInfo = typeDesigner.design(poster);
		progressManager.update(STAGE, stageInfo);
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
		break;

	case INSPECTION:
		stageInfo = inspector.inspect(poster, progressManager.posterCount);
		progressManager.update(STAGE, stageInfo);
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
		break;

	case PRINT:
		stageInfo = printerManager.print(poster, progressManager.posterCount);
		progressManager.update(STAGE, stageInfo);
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
		break;

	case FINISH:
		progressManager.update(STAGE);
		progressManager.reset();
		inspector.reset();
		delay(progressManager.stageDelay);
		STAGE=STAGE.next();
		log.print("-------------");
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


public ProbabilityObject getObjectByProbability(ArrayList<ProbabilityObject> list) {
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

public Object pickByProbability(Object[] objectList, int[] probabilityList) {
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

public String getContent(int minWords, int maxWords) {
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

public String getPomoHeadline() {

	GetRequest get = new GetRequest("http://www.elsewhere.org/journal/pomo/");
	get.send();
	String content = get.getContent();
	Document doc = Jsoup.parse(content);
	Elements li = doc.getElementsByTag("h1");
	String result = li.get(0).html();
	result = result.replaceAll("<br>", "");
	if (result.contains(":")) {
		result = result.substring(0, result.indexOf(":"));
	}
	if (result.contains("in the")) {
		result = result.substring(0, result.indexOf("in the"));
	}

	if (result.length() > 20) {
		String[] words = result.split(" ");
		result = words[floor(random(words.length))];
		result = result.substring(0, 1).toUpperCase() + result.substring(1);
	}

	return result;
}

public String getRandomTOEFLword() {
	String theword;
	String[] lines = loadStrings("words.txt");
	int randomIndex = floor(random(lines.length));
	theword = lines[randomIndex];
	theword = theword.substring(0, 1).toUpperCase() + theword.substring(1);
	return theword;
}
class ColorDesigner {

  ArrayList<ColorScheme> allColorSchemes;
  PVector prewviewColorRectSize = new PVector(400, 400);

  ColorDesigner(String colorSchemeFileName) {
    allColorSchemes = new ArrayList<ColorScheme>();
    loadColorSchemes(colorSchemeFileName);
    log.print("Loading all color schemes into memoery...");
  }

  public StageInfo design(Poster poster) {
    StageInfo thisStageInfo;
    PGraphics colorPalette;
    String colorInfo = "";
    colorPalette = createGraphics(200, 200);

    if (allColorSchemes.size() != 0) {
      poster.colorScheme = allColorSchemes.get(floor(random(0, allColorSchemes.size())));

      if (random(0, 1) < 0.1f) {
        poster.colorScheme.shuffle();
      }

      if (random(0, 1) < 0) {
        poster.colorScheme.setBackgroundWhite();
      }

      log.print("Color scheme selected: [" + poster.colorScheme.colors + "]");
      log.print("Background Color: ["+ hex( poster.colorScheme.backgroundColor ) + "]");
      log.print("Text Color: ["+ hex( poster.colorScheme.textColor ) + "]");

      poster.colorScheme.addDetailsToInspector();
      log.print("Draw color to a thumbnail for the interface...");
      colorPalette.beginDraw();
      colorPalette.background(inspectorBackground);
      float colorNodeSize = colorPalette.width/5;
      for (int i = 0; i < poster.colorScheme.colors.length; i++) {
        colorPalette.fill(poster.colorScheme.colors[i]);
        colorPalette.noStroke();
        colorPalette.ellipse(colorNodeSize/2, (colorPalette.height/4) * i + colorPalette.width/5/2, colorNodeSize, colorNodeSize);
        colorInfo += hex(poster.colorScheme.colors[i]).toString() + "\n";
      }
      colorPalette.endDraw();
    } else {
      println("Err: no color scheme saved in ColorDesigner");
    }
    thisStageInfo = new StageInfo(colorInfo, colorPalette);
    return thisStageInfo;
  }

  ///////////////Load colors from local text file
  public void loadColorSchemes(String filename) {
    String[] lines = loadStrings(filename); //get all the lines in the file.
    for (String line : lines) { //iterate through all the lines
      String[] colors = split(line, ","); //in each line, get each color (4 in total )in String format
      int[] oneSet = new int[colors.length];
      for (int i=0; i<colors.length; i++) {  //convert each colro to color
        int realColor = unhex("FF"+colors[i].substring(1));
        if (realColor==0)println("Err: color is 0, color import failed");
        oneSet[i] = realColor;
      }
      ColorScheme colorScheme = new ColorScheme(oneSet);
      allColorSchemes.add(colorScheme);
    }
  }
}

class ColorScheme {
  public int[] colors;

  int backgroundColor;
  int[] graphicsColor = new int[3];
  int textColor;
  String details;

  ColorScheme(int[] colorArray) {
    this.colors = colorArray;
    backgroundColor = colors[0];
    graphicsColor[0] = colors[1];
    graphicsColor[1] = colors[2];
    graphicsColor[2] = colors[3];

    if (brightness(backgroundColor) > (255 * 0.85f) && saturation(backgroundColor) < 255 * 0.1f) {
      //black-ish on light background
      textColor = color(30);
      for (int c : colors) {
        if (brightness(c)<255*0.1f) {
          textColor = c;
        }
      }
    } else {
      //white-ish on dark background
      textColor = color(250);
    }

    details = "Background Color:   " + hex(backgroundColor) + "\n";
    for (int i = 0; i < graphicsColor.length; i++) {
      details += "Graphics Color " + i + ":   " + hex(graphicsColor[i]) + "\n";
    }
    details+="Text Color:   " + hex(textColor) + "\n";
  }


  public void addDetailsToInspector() {
    inspector.addToMeta(details);
  }

  public void shuffle() {
    this.colors = shuffleColorArray(colors);
    log.print("Shuffing colors...");
  }

  public void setBackgroundWhite() {
    backgroundColor = color(255);
    textColor = color(30);
  }


  public int[] shuffleColorArray(int[] cs) {
    /* return shuffled color array */
    ArrayList<Integer> shuffleSolution = new ArrayList<Integer>();
    int[] shuffledColors = new int[cs.length];

    for (int i = 0; i<cs.length; i++) {
      shuffleSolution.add(cs[i]);
    }

    for (int i = 0; shuffleSolution.size() > 0; i++) {
      int pickedIndex = floor(random(0, shuffleSolution.size()));
      shuffledColors[i] = shuffleSolution.get(pickedIndex);
      shuffleSolution.remove(pickedIndex);
    }

    return shuffledColors;
  }
}
class GraphicDesigner {
  String graphicType;
  Grid myGrid;

  public StageInfo design(Poster poster) {
    addBackgroundColorToPoster(poster);
    myGrid = poster.grids.get( poster.partitionArrangement.get("graphics") );
    log.print("Init grid background...");
    //PGraphics generatedPGraphics = createGraphics(myGrid.w, myGrid.h);
    chooseGraphicType();
    String detailsFromGraphics = "";

    log.print("Creating graphics...");
    switch (graphicType) {
    case "offset":
      OffsetGraphics offsetGraphics = new OffsetGraphics(poster, myGrid);
      //generatedPGraphics = offsetGraphics.getGraphics();
      detailsFromGraphics = offsetGraphics.details;
      break;

    case "pattern":
      PatternGraphics patternGraphics = new PatternGraphics(poster, myGrid);
      //generatedPGraphics = patternGraphics.getGraphics();
      detailsFromGraphics = patternGraphics.details;
      break;

    default:
      //generatedPGraphics = empty();
      break;
    }
    //applyGraphicToPoster(generatedPGraphics, poster);


    String details = "Graphic Type:   " + graphicType + "\n" + "Graphic Partition Location:   " + myGrid.index + "\n" + detailsFromGraphics;
    StageInfo stageInfo = new StageInfo(details);
    return stageInfo;
  }

  private void chooseGraphicType() {
    log.print("Choosing graphics type...");
    String[] graphicTypes = new String[] {"offset", "pattern", "empty"};
    int[] graphicTypeProbabilities = new int[]{7, 2, 0};
    if (myGrid.fullHeight) {
      graphicTypeProbabilities = new int[]{1, 0, 0};
    }
    graphicType = pickByProbability(graphicTypes, graphicTypeProbabilities).toString();
    log.print("Graphics type is: ["  + graphicType+"]");
  }

  public void applyGraphicToPoster(PGraphics pg, Poster poster) {
    poster.content.beginDraw();

    if (myGrid.index == 0 || myGrid.fullHeight) {
      poster.content.image(pg, 0, 0);
    } else {
      poster.content.image(pg, 0, poster.grids.get(0).h);
    }

    poster.content.endDraw();
  }

  public void addBackgroundColorToPoster(Poster poster) {
    poster.content.beginDraw();
    poster.content.background(poster.colorScheme.backgroundColor);
    poster.content.endDraw();
  }


  private PGraphics empty() {
    PGraphics emptyGraphics = createGraphics(myGrid.w, myGrid.h);
    emptyGraphics.beginDraw();
    emptyGraphics.endDraw();
    return emptyGraphics;
  }
}
public abstract class Graphics {

  //PGraphics graphics;
  String details = "";
  int w, h;
  float padding;
  Grid myGrid;
  int yoffset;

  Graphics (Poster poster, Grid _grid) {
    myGrid = _grid;
    w = myGrid.w;
    h = myGrid.h;
    padding = poster.padding;
    calculateYoffset();
    makeDecisions();
    addBackgroundToPoster();
    design();
    inspector.addToMeta(details);
  }

  public abstract void makeDecisions();

  public void addBackgroundToPoster() {
    poster.content.beginDraw();
    poster.content.background(poster.colorScheme.backgroundColor);
    poster.content.endDraw();
  }

  public abstract void design();

  //public PGraphics getGraphics () {
  //  return graphics;
  //}

  public void addToDetails(String s) {
    details += s;
  }

  public void calculateYoffset() {
    if (myGrid.index == 0 || myGrid.fullHeight) {
      yoffset = 0;
    } else {
      yoffset = poster.grids.get(0).h;
    }
  }

  //void initPGraphics(){
  //  graphics = createGraphics(w,h);
  //}
}
class Grid {
  String contentType;
  int h, w;
  boolean fullHeight;
  int index; //0 means this grid is on top, 1 means bottom

  Grid (int _width, int _height, int i) {
    w = _width;
    h = _height;
    index = i;
  }
}
class Inspector {

  final boolean noise = false;
  final boolean drawAllParameters = true;
  final boolean drawID = true;

  private ArrayList<String> metadata  = new ArrayList<String>();


  public StageInfo inspect(Poster poster, int posterCount) {
    log.print("insepcting the poster...");
    poster.content.beginDraw();
    poster.content.fill(poster.colorScheme.textColor);
    poster.content.textSize(posterHeight*0.006688f);
    int y, textRectHeight;
    int yAlign;
    if (poster.grids.get(0).contentType=="letters") {
      yAlign = BOTTOM;
      y = posterHeight - poster.padding;
      textRectHeight = -1000;
    } else {
      yAlign = TOP;
      y = poster.padding;
      textRectHeight = 1000;
    }
    if (drawAllParameters) {
      for (int i = 0; i < metadata.size(); i++) {
        poster.content.textAlign(LEFT, yAlign);
        poster.content.text(metadata.get(i), poster.padding + i * (posterWidth/metadata.size()), y, posterWidth/metadata.size(), textRectHeight);
      }
    }

    //if (drawID) {
    //  if (poster.grids.get(0).contentType=="letters") {
    //    yAlign = TOP;
    //    y = 0;
    //  } else {
    //    yAlign = BOTTOM;
    //    y = posterHeight;
    //  }
    //  poster.content.textSize(posterHeight * 0.015);
    //  poster.content.textAlign(RIGHT, yAlign);
    //  poster.content.text("ID: #" + posterCount + "   " + hour() + ":" +minute() + ", " +month() + "/" + day(), posterWidth, y);
    //}

    poster.content.endDraw();


    if (noise) {
      addNoise(poster);
    }

    String details = "Inspected";
    StageInfo stageInfo = new StageInfo(details);
    log.print("inspection finished");
    return stageInfo;
  }

  public void addToMeta(String s) {
    metadata.add(s);
  }

  public void reset() {
    metadata.clear();
  }

  public void addNoise(Poster poster) {
    float noiseOpacity = 0.1f;
    PGraphics noise = createGraphics(posterWidth/10, posterHeight/10);
    noise.beginDraw();
    noise.beginShape(POINTS);

    for (int x = 0; x < noise.width; x++) {
      for (int y=0; y< noise.height; y++) {
        if (random(0, 1)>0.5f) {
          noise.stroke(255, 255*noiseOpacity);
        } else {
          noise.stroke(0, 255*noiseOpacity);
        }
        noise.point(x, y);
      }
    }

    noise.endShape();
    noise.endDraw();

    poster.content.beginDraw();
    //poster.content.blendMode(MULTIPLY);
    poster.content.image(noise, 0, 0, posterWidth, posterHeight);
    poster.content.endDraw();
  }
}
class OffsetGraphics extends Graphics {

  String shape;
  String strokeStyle;
  int numberOfShape;
  float offsetDist;
  float scaler;
  boolean oversize;
  boolean layerBlending;
  PVector offsetDirection;
  int blendmode;
  float rotateX;


  OffsetGraphics (Poster _poster, Grid _mygrid) {
    super(_poster, _mygrid);
  }

  public void makeDecisions() {
    //Pick shape
    log.print("Choosing Shape...");
    String[] shapes = new String[] {"rectangle", "triangle", "letter", "ellipse", "box", "sphere"};
    int[] shapeProbabilities = new int[] {15, 15, 25, 30, 3, 3};//default
    shape = pickByProbability(shapes, shapeProbabilities).toString();
    log.print("Shape type: [" + shape+"]");
    addToDetails("Shape: " + shape);

    // rotate x
    if (shape=="sphere" || shape=="box") {
      rotateX = random(0, TWO_PI);
    } else {
      rotateX = 0;
    }

    //pick style
    String[] strokeStyles = new String[] {"fill", "stroke"};
    int[] strokeStyleProbabilities = new int[] {90, 10};
    if (shape == "box" || shape == "sphere") {
      strokeStyleProbabilities = new int[] {0, 1};
    }
    strokeStyle = pickByProbability(strokeStyles, strokeStyleProbabilities).toString();
    log.print("stroke: [" + ((strokeStyle == "fill")?"No Stroke":"Only Stroke"+"]") );
    addToDetails("\nShape Style: [" + strokeStyle+"]");

    //Pick number of object
    Integer[] number = new Integer[] {1, 2, 3, 4};
    int[] numberProbability = new int[] {0, 50, 30, 10}; //default
    if (shape=="letter") {
      numberProbability = new int[] {5, 90, 10, 0};
    }
    if (shape=="sphere") {
      numberProbability = new int[] {1, 0, 0, 0};
    }
    numberOfShape = (int)pickByProbability(number, numberProbability);
    log.print("Shape number: ["+numberOfShape+"]");
    addToDetails("\nNumber of Shapes: " + numberOfShape);

    //Pick scaler
    Float[] scalers = new Float[] {1.0f, 1.382f, 1.618f};
    int[] scalerProbabilites = new int[] {80, 10, 10};//default
    //if (shape=="letter") {
    //scalerProbabilites = new int[] {100, 0, 0};
    //}
    scaler = (Float)pickByProbability(scalers, scalerProbabilites);
    log.print("The graphics scales by: [" + scaler+"]");
    addToDetails("\nShape scales by: " + scaler);

    //pick offsetDistance
    Float[] offsetDistances = new Float[] {0.0f, 0.382f, 0.5f, 0.618f, 1.0f};
    int[] offsetDistanceProbabilities = new int[] {12, 35, 35, 15, 3}; //default
    //int[] offsetDistanceProbabilities = new int[] {0, 0, 0, 0, 0, 5, 5}; //default
    switch(shape) {
    case "letter":
      offsetDistanceProbabilities = new int[] {3, 2, 0, 0, 0};
      break;
    }
    if (scaler != 1) {
      offsetDistanceProbabilities = new int[] {100, 0, 0, 0, 0};
    }

    offsetDist = (Float)pickByProbability(offsetDistances, offsetDistanceProbabilities);
    log.print("Shape offset 1by1 by: ["+offsetDist + "] % of shape's size" );
    addToDetails("\nOffset by " + offsetDist + " of the shape's size");

    //pick offsetDirection
    PVector[] offsetDirections = new PVector[] {new PVector(1, -1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, 0), new PVector(0, 0), new PVector(-1, -1)};
    for (PVector p : offsetDirections) {
      p.normalize();
    }
    int[] offsetDirectionProbabilities = new int[] {16, 16, 16, 16, 20, 16};
    if (offsetDist == 0.0f) {
      offsetDirectionProbabilities = new int[] {0, 0, 0, 0, 100, 0};
    }
    offsetDirection = (PVector)pickByProbability(offsetDirections, offsetDirectionProbabilities);
    addToDetails("\nOffsetting direction: " + degrees(offsetDirection.heading()) + " degree" );
    log.print("Shapes offset by: ["+degrees(offsetDirection.heading()) + "] degree");

    //layer blending or not
    Boolean[] ifLayerBlend = new Boolean[] {true, false};
    int[] layerBlendProbability = new int[] {50, 50};
    if (shape == "letter") {
      layerBlendProbability = new int[] {100, 0};
    }
    if (offsetDist == 0.0f) {
      layerBlendProbability = new int[] {100, 0};
    }
    layerBlending = (boolean)pickByProbability(ifLayerBlend, layerBlendProbability);
    log.print("Layer blending? [" + layerBlending+"]");

    //layer blend mode
    //Integer[] blendmodes = new Integer[]{MULTIPLY, ADD, SUBTRACT, DARKEST, LIGHTEST, EXCLUSION, REPLACE};
    //int[] blendmodeProbabilities = new int[]{2, 1, 1, 1, 1, 1, 1};
    //blendmode = (int)pickByProbability(blendmodes, blendmodeProbabilities);
    blendmode = MULTIPLY;
    log.print("Blend mode: ["+blendmode+"]");
    addToDetails("\nBlend Mode:   "+blendmode);
  }

  public void design() {
    int strokeWeight = floor(h * random(0.003f, 0.009f));
    int shapeSize = floor(min(w, h) * random(0.4f, 0.9f));

    switch (shape) {
    case "letter":
      shapeSize = floor(min(w, h) * 1);
      break;
    }
    log.print("Drawing shapes according to all parameters generated above...");
    /////////////////////Centering the graphics
    float hypotenuse = offsetDist * (numberOfShape - 1) * shapeSize;
    float theta = offsetDirection.heading();
    float offsetWidth = cos(theta) * hypotenuse;
    float offsetHeight = sin(theta) * hypotenuse;
    float xAdjustment = w/2 - offsetWidth/2;
    float yAdjustment = h/2 - offsetHeight/2;
    addToDetails("\nOffset Width:  "+ offsetWidth + "\nOffset Height:   " + offsetHeight);

    //////////////////// Resize the graphics
    hypotenuse = (numberOfShape * shapeSize) - (numberOfShape - 1) * (1-offsetDist) * shapeSize;
    float graphicsWidth = abs(cos(theta) * hypotenuse) + (shapeSize - abs(cos(theta)*shapeSize));
    float graphicsHeight = abs(sin(theta) * hypotenuse) + (shapeSize - abs(sin(theta)*shapeSize));

    addToDetails("\nGraphics width:   "+graphicsWidth +"\nGraphics Height:   "+graphicsHeight);

    if (scaler != 1 && offsetDist == 0.0f) {
      graphicsWidth = shapeSize * pow(scaler, numberOfShape);
      graphicsHeight = graphicsWidth;
    }

    float xScaleFactor = (w - padding * 2) / graphicsWidth;
    float yScaleFactor = (h - padding * 2) / graphicsHeight;
    float globalScaler = min(xScaleFactor, yScaleFactor);
    addToDetails("\nGraphics scaled by: " + globalScaler);

    ///////////////////////start drawing
    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(xAdjustment, yAdjustment + yoffset);
    poster.content.rotateX(rotateX);
    //poster.content.scale(globalScaler);

    //layer blending
    if (layerBlending) {
      poster.content.blendMode(blendmode);
    }

    for (int i=0; i<numberOfShape; i++) { // numberOfShape
      poster.content.pushMatrix();
      poster.content.translate(i * offsetDist * shapeSize * offsetDirection.x, i * offsetDist * shapeSize * offsetDirection.y); // offsetDist + offsetDirection
      // shape
      int scaledSize = floor(shapeSize * pow(scaler, i));
      int cc = poster.colorScheme.graphicsColor[((i)%poster.colorScheme.graphicsColor.length)];

      //strokeStyle
      switch(strokeStyle) {
      case "fill":
      default:
        poster.content.fill(cc); //color
        poster.content.noStroke();
        break;

      case "stroke":
        poster.content.noFill();
        poster.content.stroke(cc);
        poster.content.strokeWeight(strokeWeight);
        break;
      }

      switch(shape) {
      case "rectangle":
        poster.content.pushStyle();
        poster.content.rectMode(CENTER);
        poster.content.rect(0, 0, scaledSize, scaledSize);
        poster.content.popStyle();
        break;

      case "letter":
        poster.content.textFont(createFont("Helvetica-Bold", 500));
        String alphabet = "QWERTYUIOPLKJHGFDSAZXCVBNMmnbvcxzasdfghjklpoiuytrewq";
        char ourChar = alphabet.charAt(floor(random(alphabet.length())));
        poster.content.textAlign(CENTER, CENTER);
        poster.content.textSize(scaledSize);
        poster.content.text(ourChar, 0, 0);
        break;

      case "triangle":
        poster.content.triangle(0, -scaledSize/2, scaledSize/2, scaledSize/2, -scaledSize/2, scaledSize/2);
        break;

      case "ellipse":
        poster.content.ellipse(0, 0, scaledSize, scaledSize);
        break;

      case "box":
        poster.content.box(scaledSize * 0.8f);
        break;

      case "sphere":
        poster.content.sphereDetail(floor(random(3, 5)));
        poster.content.sphere(scaledSize * 0.6f);
        break;

      default:
        System.err.println("can't recognize shape");
        break;
      }
      poster.content.popMatrix();
    }
    poster.content.endDraw();
    log.print("Finished drawing graphics.");
  }
}
class ProgressManagerStage {
  int stageIndex;

  String name;
  PGraphics graphicsPreview;
  String details;
  boolean inProgress;
  boolean thumbnailAdded;
  boolean detailsAdded;

  /* hard coded variables */
  int textSize = 20;
  int textColor = color(0);
  int inProgressTextColor = color(0, 255, 0);
  int inProgressTextSize = textSize;
  float previewWidth = 170;
  float previewHeight;
  int previewYOffset = 100;
  int detailsYOffset = 20;
  int textOffset = textSize * 2;
  int detailsTextSize = 10;
  int detailsTextColor = color(255);

  //consturctor
  ProgressManagerStage (String _name, int _index) {
    stageIndex = _index;
    name = _name;
    /* init */
    inProgress = false;
    detailsAdded = false;
    graphicsPreview = createGraphics(posterWidth, posterHeight);
  }

  public void display(float x, float y) {
    pushMatrix();
    pushStyle();
    translate(x, y);
    textAlign(LEFT);


    /* highlight stage in progress */
    if (inProgress) {
      textSize(inProgressTextSize);
      fill(inProgressTextColor);
    } else {
      textSize(textSize);
      fill(textColor);
    }

    noStroke();
    box(20);
    text(name, 0, textOffset);

    textAlign(LEFT, TOP);
    if (thumbnailAdded) {
      previewHeight = (Float)(previewWidth/graphicsPreview.width)  * graphicsPreview.height;
      image(graphicsPreview, 0, previewYOffset, previewWidth, previewHeight);
    }
    if (detailsAdded) {
      textSize(detailsTextSize);
      fill(detailsTextColor);
      text(details, 0, previewHeight + previewYOffset + detailsYOffset, previewWidth, 10000);
    }


    popStyle();
    popMatrix();
  }

  public void addThumbnail(PGraphics pg) {
    graphicsPreview = pg;
    thumbnailAdded = true;
  }

  public void addDetails(String _details) {
    details = _details;
    detailsAdded = true;
  }

  public void reset() {
    thumbnailAdded = false;
    detailsAdded = false;
    inProgress = false;
    graphicsPreview = null;
    details = "";
  }
}

////////////////////////////////////////////////////

class StageInfo {

  PGraphics thumbnail;
  String details;

  StageInfo(String _de, PGraphics _thu) {
    details = _de;
    thumbnail = _thu;
  }

  StageInfo(String _de) {
    details = _de;
  }
}
class PatternGraphics extends Graphics {

  final int maxRowNumber = 200;
  final int maxColNumber = 200; 
  //final float maxSizeChange = 1.05;
  final float localRotationMaxDegree = 7;
  final float localRotateProbability = 0.3f;
  final float localGradientColorProbability = 0.2f;
  final float globalGradientColorProbability = 0.2f;

  boolean oneDirection;
  int rowNumber;
  int colNumber;
  int vectorNumber;
  float xSize, ySize; 
  //float sizeXChange;
  //float sizeYChange;
  float localRotationChange;
  float xgap, ygap;
  boolean localGradientColor, globalGradientColor;
  int gc1, gc2;


  PatternGraphics (Poster poster, Grid myGrid) {
    super(poster, myGrid);
  }

  public void makeDecisions() {

    //number of row  || col
    Integer[] numbers = new Integer[] {15, 40};
    int[] numberProbabilities = new int[] {1, 1};
    int number = (int)pickByProbability(numbers, numberProbabilities);
    log.print("Number of shapes: ["+number+"]");

    //number of row && col
    float oneDirectionProbability = 0.5f;
    if (random(0, 1)<oneDirectionProbability) {
      oneDirection = true;
      if (random(0, 1) < 0.5f) {
        rowNumber = 1;
        colNumber = number;
      } else {
        colNumber = 1;
        rowNumber = number;
      }
    } else {
      colNumber = rowNumber = number;
    }
    rowNumber = constrain(rowNumber, 1, maxRowNumber);
    colNumber = constrain(colNumber, 1, maxColNumber);
    log.print("Row/Column number: [" + rowNumber+"]["+colNumber +"]");
    addToDetails("Row Number:   " + rowNumber + "\nColumn Number:   "+colNumber + "\n");

    //vector number;
    Integer[] vectorNumbers = new Integer[]{3, 4, 5};
    int[] vectorNumberProbabilities = new int[]{5, 3, 3};
    vectorNumber = (int)pickByProbability(vectorNumbers, vectorNumberProbabilities);
    if (oneDirection) {
      vectorNumber = 4; //if One Direction, then it got to be rect.
    }
    log.print("Each shape will have: ["+vectorNumber+"] vectices");
    addToDetails("Shape Vectices Number:   " + vectorNumber + "\n");

    //size
    int availableWidth, availableHeight;
    availableHeight = myGrid.h - poster.padding * 2;
    availableWidth = posterWidth - poster.padding * 2;
    xSize = availableWidth / colNumber;
    ySize = availableHeight / rowNumber;
    log.print("Width of single shape: ["+xSize+"] height: ["+ySize+"]");
    addToDetails("Single Shape Width:  "+xSize+"\nSingle Shape Height:   " + ySize + "\n");


    //gap
    float rando = random(0.1f, 0.9f);
    xgap = rando * xSize;
    ygap = rando * ySize;

    if (colNumber==1)xgap=0;
    if (rowNumber==1)ygap=0;
    log.print("Horizontal gap: ["+xgap+"]" + "vertical gap: ["+ygap+"]");
    addToDetails("xgap:   " + xgap + "\nygap:   " + ygap + "\n");


    //    //size change
    //    sizeXChange = random(1, maxSizeChange);
    //    sizeYChange = sizeXChange;

    //    if (rowNumber == 1) {
    //      sizeYChange = 1;
    //      sizeXChange = random(1, maxSizeChange);
    //    }
    //    if (colNumber == 1) {
    //      sizeXChange = 1;
    //      sizeYChange = random(1, maxSizeChange);
    //    }

    //    addToDetails("Single Shape Size Change by:   " + sizeXChange+"," + sizeYChange + "\n");

    //rotation
    if (random(0, 1) < localRotateProbability && !oneDirection) {
      localRotationChange = random(radians(0), radians(localRotationMaxDegree));
    } else {
      localRotationChange = 0;
    }

    log.print("Shape rotates 1by1 by ["+degrees(localRotationChange)+"]");


    //color
    gc1 = poster.colorScheme.graphicsColor[0];
    if (random(0, 1) < globalGradientColorProbability) {
      globalGradientColor = true;
      gc2 = poster.colorScheme.graphicsColor[2];
    } else {
      gc2 = gc1;
    }
    if (random(0, 1) < localGradientColorProbability) {
      localGradientColor = true;
    }
    addToDetails("Shape Color 1   " + hex(gc1) + "\nColor 2:   " + hex(gc2) + "\n");
  }

  public void design() {
    poster.content.beginDraw();
    poster.content.pushMatrix();
    poster.content.translate(0, yoffset);

    int index = 0;
    float sum = colNumber * rowNumber;
    log.print("Drawing the pattern on our poster...");
    for (int xn = 0; xn < colNumber; xn++) {
      for (int yn = 0; yn < rowNumber; yn++) {

        int c = lerpColor(gc1, gc2, index / sum);
        float xpos = poster.padding + xSize/2 + xn * xSize;
        float ypos = poster.padding + ySize/2 + yn * ySize;
        PIShape(poster.content, index, vectorNumber, xpos, ypos, xSize - xgap, ySize - ygap, localRotationChange, c, localGradientColor);
        index++;
      }
    }
    poster.content.popMatrix();
    poster.content.endDraw();
  }
}

/////////////
/////////////
public void PIShape(PGraphics pg, int index, int verticesNumber, float x, float y, float xsize, float ysize, float rotationChange, int c, boolean ifGradient) {
  float rx = xsize/2;
  float ry = ysize/2;
  float angle = TWO_PI/verticesNumber;
  int c2;
  if (ifGradient) {
    c2 = color(red(c), green(c), blue(c), 0);
  } else {
    c2 = c;
  }
  //pg.beginDraw();
  ////////////
  pg.pushMatrix();
  pg.translate(x, y);
  pg.scale(rx, ry);
  pg.rotate(rotationChange * index);


  if (verticesNumber == 4) {
    pg.beginShape();
    pg.noStroke();
    pg.fill(c);
    pg.vertex(1, 1);
    pg.vertex(-1, 1);
    pg.fill(c2);
    pg.vertex(-1, -1);
    pg.vertex(1, -1);
    pg.endShape(CLOSE);
  } else {
    pg.beginShape();
    pg.noStroke();
    for (int i=0; i<verticesNumber; i++) {
      if (i<verticesNumber/2) {
        pg.fill(c);
      } else {
        pg.fill(c2);
      }
      float xx = cos(i * (angle) + PI/verticesNumber );
      float yy = sin(i * (angle) + PI/verticesNumber );
      pg.vertex(xx, yy);
    }
    pg.endShape(CLOSE);
  }
  pg.popMatrix();
  ///////////
  //pg.endDraw();
}
class Poster {
  //Attributes
  int w;
  int h;
  String partitionType;
  float partitionValue;
  float rotation;
  int padding;
  HashMap<String, Integer> partitionArrangement = new HashMap();

  ArrayList<Grid> grids = new ArrayList<Grid>();
  HashMap<String, Float> partitionSet = new HashMap();
  ColorScheme colorScheme;
  PGraphics content;
  String details = "";
  int id;
  String createdTime = "";

  final float graphicsGridFullHeightProbability = 0.15f;

  //Constructor
  Poster(int _posterW, int _posterH) {
    createdTime = hour() + ":" + minute() + "    " + month() + "/" + day();
    id = progressManager.posterCount;
    log.print("A new poster is being created...");
    w = _posterW;
    h = _posterH;
    log.print("....creating poster...");
    log.print("poster width: " + w + ",height: " + h); 
    getPartition();
    getPadding();
    arrangePartitions();
    getRotation();
    content = createGraphics(w, h, P3D);
    content.smooth(2);
    content.beginDraw();
    content.textMode(SHAPE);
    content.endDraw();
    details += id + "   " + createdTime + "\n";
    inspector.addToMeta(details);
    log.print("New poster created! ID: " + id);
  }

  public void getRotation() {
    Integer[] rotationValues = new Integer[] {45, -45, 0};
    int[] rotationProbabilities = new int[] {1, 1, 0};
    rotation = (int)pickByProbability(rotationValues, rotationProbabilities);
    details += "Global Rotation:   " + rotation + " Degree" + "\n";
  }

  // Get our partition of this poster!
  public void getPartition() {
    log.print("Deciding layout...");
    Float[] partitionValues = new Float[] {0.618f, 1-0.618f, 0.797f, 1-0.797f};
    int[] partitionProbabilities = new int[] {20, 20, 20, 20};
    partitionValue = (float)pickByProbability(partitionValues, partitionProbabilities);
    String partitionName;
    if (partitionValue==partitionValues[0] || partitionValue==partitionValues[1]) {
      partitionName = "Golden Ratio";
    } else {
      partitionName = "Silver Ratio";
    }
    log.print("Layout: " +  partitionName );


    int topGridHeight = floor(posterHeight * partitionValue);
    int typographyGridHeight = posterHeight-topGridHeight;

    grids.add(new Grid(posterWidth, topGridHeight, 0));
    grids.add(new Grid(posterWidth, typographyGridHeight, 1));

    details += "Poster divided from:   " + partitionValue + "\n";
    details += "Grid 1 Height:   " + grids.get(0).h + "\n";
    details += "Grid 2 Height:   " + grids.get(1).h + "\n";

    log.print("Grid 1 Height: "+grids.get(0).h);
    log.print("Grid 2 Height: "+grids.get(1).h);
  }

  public void getPadding() {
    padding = floor( 0.055f * posterWidth );
    details += "Padding:   " + padding + "\n";
    log.print("Poster padding: " + padding);
  }

  public void arrangePartitions() {

    int partitionIndexForGraphics = 999;

    log.print("Arranging graphics and typography to grids...");
    // always give graphics the bigger partition
    if (partitionValue < 0.5f && partitionValue > 0) {
      partitionIndexForGraphics = 1;
    } else if (partitionValue > 0.5f && partitionValue < 1) {
      partitionIndexForGraphics = 0;
    } else {
      System.err.println("Werid partition value.");
    }

    //add lable to grids
    if (partitionIndexForGraphics == 1) {
      grids.get(0).contentType = "letters";
      grids.get(1).contentType = "graphics";
      partitionArrangement.put("letters", 0);
      partitionArrangement.put("graphics", 1);
    } else if (partitionIndexForGraphics == 0) {
      grids.get(1).contentType = "letters";
      grids.get(0).contentType = "graphics";
      partitionArrangement.put("letters", 1);
      partitionArrangement.put("graphics", 0);
    } else {
      System.err.println("ERR: partitionIndexForGraphics is not assigned!!!");
    }

    if (random(0, 1) < graphicsGridFullHeightProbability) {
      grids.get( partitionArrangement.get("graphics") ).h = posterHeight;
      grids.get( partitionArrangement.get("graphics") ).fullHeight = true;
    }
    log.print("Grid on top has: "+ grids.get(0).contentType + " grid on bottom has: " + grids.get(1).contentType);
    details += "Grid #1 Type:   " + grids.get(0).contentType + "\nGrid #2 Type   :" + grids.get(1).contentType + "\n";
  }
}
class PrinterManager {
  boolean actuallyPrint = false;
  public StageInfo print(Poster poster, int poster_count) {
    String posterFileName = "poster_#" + poster_count+".png";
    log.print("Saving file, file name: ["+posterFileName+"]");
    poster.content.save("posters/"+posterFileName);

    String newPosterPath = sketchPath("")+"posters/"+posterFileName;

    if (actuallyPrint) {
      log.print("Sending designed poster to printer...");
      sendToPrinter(newPosterPath);
    }

    String details = "Sending to Printer HP T120.";
    PGraphics completedPoster = poster.content;
    StageInfo stageInfo = new StageInfo(details, completedPoster);
    return stageInfo;
  }

  public void sendToPrinter(String pathToFile) {
    try {
      println(pathToFile);
      Process p = Runtime.getRuntime().exec("lp "+pathToFile);
    }
    catch (Exception e) {
      println(e);
    }
  }
}
class ProgressManager {
  Stage STAGE;
  int posterCount = 0;
  int stageDelay = 1000;
  PFont spaceMono;
  int titleSize = 45;
  ArrayList<ProgressManagerStage> progressManagerStages;
  String displayDir;

  ProgressManager () {
    if (width>height) {
      displayDir = "horizontal";
    } else {
      displayDir = "vertical";
    }
    spaceMono = createFont("Courier", 100);
    //posterCount = 0;
    progressManagerStages = new ArrayList<ProgressManagerStage>();

    for (int i = 0; i < stageNumber; i++) {
      ProgressManagerStage pms = new ProgressManagerStage(STAGE.values()[i].toString(), i);
      progressManagerStages.add(pms);
    }
  }

  public void reset() {
    for (ProgressManagerStage pms : progressManagerStages) {
      pms.reset();
    }
  }

  /* for stage with no thumbnail */
  public void update(Stage _STAGE) {
    STAGE = _STAGE;
    if (STAGE == Stage.values()[0]) {
      posterCount++;
    }
  }

  /* for stage with thumbnail */
  public void update(Stage _STAGE, StageInfo stageInfo) {
    log.print("Updating progress interface infoation...");
    update(_STAGE);
    int currentStageIndex = STAGE.ordinal();
    if (stageInfo.thumbnail != null) {
      progressManagerStages.get(currentStageIndex).addThumbnail(stageInfo.thumbnail);
    }
    /* make sure data is not empty or null */
    if (stageInfo.details != "") {
      if (stageInfo.details != null) {
        progressManagerStages.get(currentStageIndex).addDetails(stageInfo.details);
      } else {
        println("stageInfo.details is null");
      }
    } else {
      println("stageInfo.details is empty ");
    }
  }

  public void addDetails(String _details) {
    int currentStageIndex = STAGE.ordinal();
    progressManagerStages.get(currentStageIndex).addDetails(_details);
  }


  public void display () {
    textFont(spaceMono);
    for (ProgressManagerStage pms : progressManagerStages) {
      if (STAGE.next().toString() == pms.name) {
        pms.inProgress = true;
      } else {
        pms.inProgress = false;
      }
      if (displayDir=="vertical") {
        pms.display(width/2, (height/stageNumber)/2 + pms.stageIndex * (height/stageNumber));
      } else {
        pms.display((width/stageNumber)/2 + pms.stageIndex * (width/stageNumber), 200);
      }
    }

    textAlign(LEFT);
    textSize(titleSize);
    fill(0);
    text("Making Poster #" + posterCount + "...", 100, 100);
    log.print("Display stage information");
  }
}
////////////////////////////////////////////////////
class Text {
  String contentType;
  PVector pos;
  int fontSize;
  String content;
  int xAlign, yAlign;
  int w;
  int h;
  int c;
  boolean boundSet, contentSet, alignSet, fontSet;
  boolean underline;
  int lineWidth, lineHeight;
  PFont font;

  Text (String type, int _fontSize) {
    contentType = type;
    fontSize = _fontSize;
  }

  public void setBound(int x, int y, int _w, int _h) {
    pos = new PVector(x, y);
    w = _w;
    h = _h;
    boundSet = true;
  }

  public void setAlign(int xAlignment, int yAlignment) {
    xAlign = xAlignment;
    yAlign = yAlignment;
    alignSet = true;
  }

  public void setContent(String _content) {
    content = _content;
    contentSet = true;
  }

  public void setColor(int _c) {
    c = _c;
  }

  public void setFont(PFont f) {
    font = f;
    fontSet = true;
  }

  public void addLine( int lineW, int lineH ) {
    lineWidth = lineW;
    lineHeight = lineH;
    underline = true;
  }

  public void drawOn(PGraphics pg) {
    if (boundSet && contentSet && alignSet && fontSet ) {
      pg.beginDraw();
      pg.pushMatrix();
      pg.translate(pos.x, pos.y);
      pg.textFont(font);
      pg.textAlign(xAlign, yAlign);
      pg.textSize(fontSize);
      if (contentType == "headline") {
        pg.strokeCap(SQUARE);
        pg.textLeading(fontSize*0.9f);
      }
      pg.fill(c);
      pg.text(content, 0, 0, w, h);
      pg.popMatrix();
      pg.endDraw();
    } else {
      System.err.println("Text hasn't been set fully");
    }
  }
}
class TypeDesigner {

  //const
  final String[] allFonts = new String[] {"Helvetica", "Futura", "Avenir-Medium",  "LexendDeca-Regular", "Montserrat-Medium"};
  final String[] allFontsBold = new String[] {"Helvetica-Bold", "Futura-Medium", "Avenir-Heavy", "LexendDeca-Regular", "Montserrat-Bold"};

  final ArrayList<PFont> fonts = new ArrayList<PFont>();
  final ArrayList<PFont> boldFonts = new ArrayList<PFont>();

  final int textAlignX = LEFT;
  final int columnTextMinNumber = 10;
  final int columnTextMaxNumber = 20;

  // poster by poster
  Grid myGrid;
  float noColumnProbability = 0.1f;



  TypeDesigner () {
    setupFonts();
  }

  public void setupFonts() {
    //fonts = new ArrayList<PFont>();
    //boldFonts = new ArrayList<PFont>();

    for (int i = 0; i < allFonts.length; i++) {
      fonts.add(createFont(allFonts[i], 500));
      boldFonts.add(createFont(allFontsBold[i], 500));
    }
  }

  ///////////////////////////
  public StageInfo design(Poster poster) {
    String details = "";
    myGrid = poster.grids.get(poster.partitionArrangement.get("letters"));

    // choose font
    int randomFontIndex = floor(random(fonts.size()));
    PFont font = fonts.get(randomFontIndex);
    PFont boldFont = boldFonts.get(randomFontIndex);
    String fontname = font.getName();
    details+="Font:   " + fontname + "\n";
    log.print("Picked font: ["+fontname+"]");


    //text vertical alignment
    details+="Global X Alignment:   "+textAlignX + "\n";
    log.print("Text vertical align: ["+textAlignX+"]");


    // headline width
    Float[] headlineWidths = new Float[] {1.0f};
    int[] headlineWidthProbabilities = new int[] {1};
    int headlineWidth = floor(((float)pickByProbability(headlineWidths, headlineWidthProbabilities)) * (posterWidth - poster.padding * 2));

    // paragraph font size
    float minColumnFontSize = 0.009f * posterHeight;
    float maxColumnFontSize = 0.011f * posterHeight;
    int columnFontSize = (int)random(minColumnFontSize, maxColumnFontSize);
    details += "Paragraph Font Size:   " + columnFontSize + "\n";
    log.print("Column font size: ["+columnFontSize+"]");

    // headline vs paragraph arrangement
    int[] headlinePosition = new int[]{poster.padding, 0};
    int headlineLocation;
    int headlineAlignX = textAlignX;
    int headlineAlignY;


    if (random(0, 1) > 0.5f) { //headline on top
      headlinePosition[1] = poster.padding;
      headlineAlignY = TOP;
      headlineLocation = 0;
    } else { //headline on bottom
      headlinePosition[1] = myGrid.h - poster.padding;
      headlineAlignY = BOTTOM;
      headlineLocation = 1;
    }

    // headline font size
    float minHeadlineSize = 0.04f * posterHeight;
    float maxHeadlineSize = 0.15f * posterHeight;
    int headlineFontSize;
    headlineFontSize= (int)random(minHeadlineSize, maxHeadlineSize);
    details+="headlineFontSize:   " + headlineFontSize + "\n";
    log.print("Headline font size: ["+headlineFontSize+"]");

    //column Count
    int columnCount;
    Integer[] columnCounts = new Integer[] {1, 2, 4};
    int[] columnCountsProbabilities = new int[] {1, 4, 5};
    columnCount = (int)pickByProbability(columnCounts, columnCountsProbabilities);
    details += "Paragraph Count:   " + columnCount + "\n";
    log.print("Column number: ["+columnCount+"]");


    //column width
    float columnWidth = ((posterWidth - poster.padding * 2) / columnCount) * 0.9f;
    log.print("Column width: ["+columnWidth+"]");

    //space between headline and columns
    int spaceingBetweenHeadlineAndColumns = floor( posterHeight * 0.024f );

    //column max height
    int columnMaxHeight;
    if (headlineLocation==1) {
      columnMaxHeight = floor( myGrid.h - poster.padding * 2 - headlineFontSize - spaceingBetweenHeadlineAndColumns );
    } else {
      columnMaxHeight = 10000;
    }
    //int columnMaxHeight = 10000;

    //column spacing
    float spacingBetweenColumns = ((posterWidth - poster.padding * 2) / columnCount) * 0.1f;

    //headline color
    int headlineColor = poster.colorScheme.textColor;

    //column color
    int columnColor = poster.colorScheme.textColor;

    details += "Text Color:   " + columnColor + "\n";


    float yoffset = myGrid.index * (posterHeight - myGrid.h);

    // create headline objects
    Text headline = new Text("headline", headlineFontSize);
    int headlineRectHeight = 10000;
    if (headlineLocation==1) headlineRectHeight *= -1;
    headline.setBound(headlinePosition[0], headlinePosition[1] + (int)yoffset, headlineWidth, headlineRectHeight);
    headline.setContent(getRandomTOEFLword());
    headline.setColor(headlineColor);
    headline.setFont(boldFont);
    headline.setAlign(headlineAlignX, headlineAlignY);

    // if(underline){
    //     headline.addLine(posterWidth - poster.padding * 2, 5);
    // }
    // create column objects

    ArrayList<Text> columns = new ArrayList<Text>();

    for (int i = 0; i < columnCount; i++) {
      Text col = new Text("column", columnFontSize);
      int colY = floor((headlineFontSize + spaceingBetweenHeadlineAndColumns) * (1 - headlineLocation)  +  poster.padding);
      col.setBound(floor(poster.padding + i * (columnWidth + spacingBetweenColumns)), colY+(int)yoffset, (int)columnWidth, columnMaxHeight);
      col.setContent(getContent(columnTextMinNumber, columnTextMaxNumber));
      col.setColor(columnColor);
      col.setFont(font);
      col.setAlign(textAlignX, TOP);
      columns.add(col);
    }

    //Draw them to the graphics
    poster.content.beginDraw();
    poster.content.blendMode(BLEND);
    poster.content.endDraw();

    headline.drawOn(poster.content);

    for (Text col : columns) {
      col.drawOn(poster.content);
    }

    //"print" the design on main PGraphics

    //applyGraphicToPoster(generatedPGraphics, poster);

    StageInfo stageInfo = new StageInfo(details);

    inspector.addToMeta(details);

    return stageInfo;
  }

  //  void applyGraphicToPoster(PGraphics pg, Poster poster) {
  //    poster.content.beginDraw();
  //    float y = myGrid.index * (posterHeight - myGrid.h);
  //    poster.content.image(pg, 0, (int)y);
  //    poster.content.endDraw();
  //  }
}
  public void settings() { 	size(1080,1920,P3D); 	smooth(4); 	pixelDensity(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LENNAV2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
