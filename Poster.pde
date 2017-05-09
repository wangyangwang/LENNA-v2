class Poster {
  //Attributes
  int w;
  int h;
  String partitionType;
  float partitionValue;
  float rotation;
  HashMap<String, Integer> partitionArrangement = new HashMap();

  ArrayList<Grid> grids = new ArrayList<Grid>();
  ArrayList<ProbabilityObject> partitionProbabilitySet;
  HashMap<String, Float> partitionSet = new HashMap();
  ArrayList<ProbabilityObject> rotationProbabilitySet;

  ColorScheme colorScheme;
  PGraphics content;
  String posterDetails;

  //Constructor
  Poster(int _posterW, int _posterH) {
    w = _posterW;
    h = _posterH;
    partitionProbabilitySet = new ArrayList<ProbabilityObject>();
    rotationProbabilitySet = new ArrayList<ProbabilityObject>();
    getPartition();
    arrangePartitions();
    getRotation();
    //content = createGraphics(w, h, PDF, "test.pdf");
    content = createGraphics(w, h);
    posterDetails = " - Partition Value:\n" + partitionValue + "\n\n - Rotation is\n" + rotation + " degree";
  }

  void getRotation() {
    Integer[] rotationValues = new Integer[] {45, -45, 0};
    int[] rotationProbabilities = new int[]{5, 5, 90};
    rotation = (int)pickByProbability(rotationValues, rotationProbabilities);
  }

  // Get our partition of this poster!
  void getPartition() {
    Float[] partitionValues = new Float[]{0.618, 1-0.618, 0.797, 1-0.797, 0.5, 1.0};
    int[] partitionProbabilities = new int[]{20, 20, 10, 10, 25, 15};
    partitionValue = (float)pickByProbability(partitionValues, partitionProbabilities);

    for (HashMap.Entry<String, Float> e : partitionSet.entrySet()) {
      Object key = e.getKey();
      Object value = e.getValue();
      if ((float)value == partitionValue) {
        partitionType = key.toString();
      }
    }
    if (partitionValue == 1.0) {
      grids.add(new Grid(posterWidth, posterHeight, 0));
      grids.add(new Grid(posterWidth, posterHeight, 1));
    } else {
      grids.add(new Grid(posterWidth, floor(posterHeight * partitionValue), 0));
      grids.add(new Grid(posterWidth, posterHeight-(floor(posterHeight * partitionValue)), 1));
    }
  }

  void arrangePartitions() {

    int partitionIndexForGraphics = 999;

    if (partitionValue < 0.5 && partitionValue > 0) {
      partitionIndexForGraphics = 1;
    } else if (partitionValue > 0.5 && partitionValue < 1) {
      partitionIndexForGraphics = 0;
    } else if (partitionValue == 0.5) {
      if (random(0, 1) > 0.7) { // 40% chance of draw graphics on the top partition
        partitionIndexForGraphics = 0;
      } else {
        partitionIndexForGraphics = 1;
      }
    } else if (partitionValue == 1) {
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
  }
}

//////////////////////////////////////////////////

class Grid {
  String contentType;
  int h, w;
  private color backgroundColor;
  boolean backgroundColorSet = false;
  final boolean fullHeight;
  final int index; //0 means this grid is on top, 1 means bottom

  Grid (int _width, int _height, int i) {
    w = _width;
    h = _height;
    index = i;
    if (h == posterHeight) {
      fullHeight = true;
    } else {
      fullHeight = false;
    };
  }
  void setBackgroundColor(color c) {
    backgroundColor = c;
    backgroundColorSet = true;
  }
}