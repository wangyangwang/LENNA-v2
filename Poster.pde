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

    initPartitions();
    initRotations();

    getPartition();
    arrangePartitions();
    getRotation();

    //content = createGraphics(w, h, PDF, "test.pdf");
    content = createGraphics(w,h);
    posterDetails = " - Partition Type:\n" + partitionType.toUpperCase() + "\n\n - Rotation is\n" + rotation + " degree";
  }


  void initPartitions() {
    // decide the global partition of this poster
    partitionSet.put("golden ratio 01", 0.618);
    partitionSet.put("golden ratio 02", 1-0.618);
    partitionSet.put("silver ratio 01", 0.797);
    partitionSet.put("silver ratio 02", 1-0.797);
    partitionSet.put("half half", 0.5);
    partitionSet.put("full height", 1.0);
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("golden ratio 01"), 35/2)); //golden ratio 01
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("golden ratio 02"), 35/2)); //golden ratio 01
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("silver ratio 01"), 30/2)); //silver ratio
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("silver ratio 02"), 30/2)); //silver ratio 02
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("half half"), 25)); //5/5
    partitionProbabilitySet.add(new ProbabilityObject(partitionSet.get("full height"), 10)); //no divide
  }

  void initRotations() {
    //all rotation values are in DEGREE instead of RADIANS
    rotationProbabilitySet.add(new ProbabilityObject(45, 5));
    rotationProbabilitySet.add(new ProbabilityObject(-45, 5));
    rotationProbabilitySet.add(new ProbabilityObject(0, 90));
  }

  // Get our partition of this poster!
  void getPartition() {
    partitionValue = (float)getObjectByProbability(partitionProbabilitySet).value;

    for (HashMap.Entry<String, Float> e : partitionSet.entrySet()) {
      Object key = e.getKey();
      Object value = e.getValue();
      if ((float)value == partitionValue) {
        partitionType = key.toString();
      }
    }

    if (partitionType == "full height") {
      grids.add(new Grid(posterWidth, posterHeight, 0));
      grids.add(new Grid(posterWidth, posterHeight, 1));
    } else {
      grids.add(new Grid(posterWidth, floor(posterHeight * partitionValue), 0));
      grids.add(new Grid(posterWidth, posterHeight-(floor(posterHeight * partitionValue)), 1));
    }
  }

  void arrangePartitions() {

    int partitionIndexForGraphics = 999;

    if (partitionValue < 0.5) {
      partitionIndexForGraphics = 1;
    } else if (partitionValue > 0.5) {
      partitionIndexForGraphics = 0;
    } else if (partitionValue == 0.5) {
      if (random(0, 1) > 0.7) { // 40% chance of draw graphics on the top partition
        partitionIndexForGraphics = 0;
      } else {
        partitionIndexForGraphics = 1;
      }
    } else if (partitionValue == 1) {
      partitionIndexForGraphics = 0;
    }

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
      println("ERR: partitionIndexForGraphics is not assigned!!!");
    }
  }

  void getRotation() {
    rotation = (int)getObjectByProbability(rotationProbabilitySet).value;
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