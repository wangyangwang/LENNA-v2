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
  String details;

  //Constructor
  Poster(int _posterW, int _posterH) {
    w = _posterW;
    h = _posterH;
    getPartition();
    getPadding();
    arrangePartitions();
    getRotation();
    content = createGraphics(w, h);
    inspector.addToMeta(details);
  }

  void getRotation() {
    Integer[] rotationValues = new Integer[] {45, -45, 0};
    int[] rotationProbabilities = new int[] {1, 1, 0};
    rotation = (int)pickByProbability(rotationValues, rotationProbabilities);
    details += "Global Rotation:   " + rotation + " Degree" + "\n";
  }

  // Get our partition of this poster!
  void getPartition() {
    Float[] partitionValues = new Float[] {0.618, 1-0.618, 0.797, 1-0.797};
    int[] partitionProbabilities = new int[] {20, 20, 20, 20};
    partitionValue = (float)pickByProbability(partitionValues, partitionProbabilities);

    for (HashMap.Entry<String, Float> e : partitionSet.entrySet()) {
      Object key = e.getKey();
      Object value = e.getValue();
      if ((float)value == partitionValue) {
        partitionType = key.toString();
      }
    }

    int topGridHeight = floor(posterHeight * partitionValue);
    int typographyGridHeight = posterHeight-topGridHeight;

    grids.add(new Grid(posterWidth, topGridHeight, 0));
    grids.add(new Grid(posterWidth, typographyGridHeight, 1));

    details += "Poster divided from:   " + partitionValue + "\n";
    details += "Grid 1 Height:   " + grids.get(0).h + "\n";
    details += "Grid 2 Height:   " + grids.get(1).h + "\n";
  }

  void getPadding() {
    padding = floor( 0.055 * posterWidth );
    details += "Padding:   " + padding + "\n";
  }

  void arrangePartitions() {

    int partitionIndexForGraphics = 999;
    float graphicsGridFullHeightProbability = 0.3;

    // always give graphics the bigger partition
    if (partitionValue < 0.5 && partitionValue > 0) {
      partitionIndexForGraphics = 1;
    } else if (partitionValue > 0.5 && partitionValue < 1) {
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

    details += "Grid #1 Type:   " + grids.get(0).contentType + "\nGrid #2 Type   :" + grids.get(1).contentType + "\n";
  }
}