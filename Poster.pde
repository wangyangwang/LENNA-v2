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

  final float graphicsGridFullHeightProbability = 0.15;

  //Constructor
  Poster(int _posterW, int _posterH) {
    createdTime = hour() + ":" + minute() + "    " + month() + "/" + day();
    id = progressManager.posterCount;
    log.print("<br>A new poster is being created");
    w = _posterW;
    h = _posterH;
    log.print("<br>....creating poster...");
    log.print("<br>poster width: " + w + ", height: " + h + "<br>");
    getPartition();
    getPadding();
    arrangePartitions();
    getRotation();
    content = createGraphics(w, h, P3D);
    content.smooth(2);
    content.beginDraw();
    content.textMode(SHAPE);
    content.endDraw();
    details += id + "   " + createdTime + "<br>";
    inspector.addToMeta(details);
    log.print("New poster created! ID: " + id);
  }

  void getRotation() {
    Integer[] rotationValues = new Integer[] {45, -45, 0};
    int[] rotationProbabilities = new int[] {1, 1, 0};
    rotation = (int)pickByProbability(rotationValues, rotationProbabilities);
    details += "Global Rotation:   " + rotation + " Degree" + "&nbsp";
  }

  // Get our partition of this poster!
  void getPartition() {
    log.print("Deciding layout...&nbsp&nbsp");
    Float[] partitionValues = new Float[] {0.618, 1-0.618, 0.797, 1-0.797};
    int[] partitionProbabilities = new int[] {20, 20, 20, 20};
    partitionValue = (float)pickByProbability(partitionValues, partitionProbabilities);
    String partitionName;
    if (partitionValue==partitionValues[0] || partitionValue==partitionValues[1]) {
      partitionName = "&nbsp Golden Ratio<br>";
    } else {
      partitionName = "&nbsp Silver Ratio<br>";
    }
    log.print("&nbsp Layout: " +  partitionName );


    int topGridHeight = floor(posterHeight * partitionValue);
    int typographyGridHeight = posterHeight-topGridHeight;

    grids.add(new Grid(posterWidth, topGridHeight, 0));
    grids.add(new Grid(posterWidth, typographyGridHeight, 1));

    details += "Poster divided from:   " + partitionValue + "<br>";
    details += "Grid 1 Height:   " + grids.get(0).h + "<br>";
    details += "Grid 2 Height:   " + grids.get(1).h + "<br>";

    log.print("Grid 1 Height: "+grids.get(0).h + "<br>");
    log.print("Grid 2 Height: "+grids.get(1).h + "<br>");
  }

  void getPadding() {
    padding = floor( 0.055 * posterWidth );
    details += "Padding:   " + padding + "<br>";
    log.print("Poster padding: " + padding + "<br>");
  }

  void arrangePartitions() {

    int partitionIndexForGraphics = 999;

    log.print("Arranging graphics and typography to grids...");
    // always give graphics the bigger partition
    if (partitionValue < 0.5 && partitionValue > 0) {
      partitionIndexForGraphics = 1;
    } else if (partitionValue > 0.5 && partitionValue < 1) {
      partitionIndexForGraphics = 0;
    } else {
      System.err.println("Werid partition value.");
    }

    //label our grids
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
    log.print("<br>Grid on top has: "+ grids.get(0).contentType + " grid on bottom has: " + grids.get(1).contentType);
    details += "Grid #1 Type:   " + grids.get(0).contentType + "<br>Grid #2 Type   :" + grids.get(1).contentType + "<br>";
  }
}
