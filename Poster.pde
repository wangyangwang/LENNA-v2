class Poster {
  //Attributes
  int w;
  int h;
  String partitionType;
  float partitionValue;
  float rotation;

  ArrayList<Grid> grids = new ArrayList<Grid>();
  ArrayList<ProbabilityObject> partitionProbabilityDataSet;
  HashMap<String, Float> partitionDataSet = new HashMap();
  ArrayList<ProbabilityObject> rotationProbabilityDataSet;

  ColorScheme colorScheme;
  PGraphics content;


  String posterDetails;



  Poster(int _posterW, int _posterH) {
    w = _posterW;
    h = _posterH;
    partitionProbabilityDataSet = new ArrayList<ProbabilityObject>();
    rotationProbabilityDataSet = new ArrayList<ProbabilityObject>();

    initPartitions();
    initRotations();

    getPartition();
    getRotation();

    content = createGraphics(w, h);
    posterDetails = " - Partition Type:\n" + partitionType.toUpperCase() + "\n\n - Rotation is\n" + rotation + " degree";
  }


  void initPartitions() {
    // decide the global partition of this poster
    partitionDataSet.put("golden ratio 01", 0.618);
    partitionDataSet.put("golden ratio 02", 1-0.618);
    partitionDataSet.put("silver ratio 01", 0.797);
    partitionDataSet.put("silver ratio 02", 1-0.797);
    partitionDataSet.put("half half", 0.5);
    partitionDataSet.put("full height", 1.0);
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("golden ratio 01"), 35/2)); //golden ratio 01
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("golden ratio 02"), 35/2)); //golden ratio 01
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("silver ratio 01"), 30/2)); //silver ratio
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("silver ratio 02"), 30/2)); //silver ratio 02
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("half half"), 25)); //5/5
    partitionProbabilityDataSet.add(new ProbabilityObject(partitionDataSet.get("full height"), 10)); //no divide
  }

  void initRotations() {
    //all rotation values are in DEGREE instead of RADIANS
    rotationProbabilityDataSet.add(new ProbabilityObject(45, 5));
    rotationProbabilityDataSet.add(new ProbabilityObject(-45, 5));
    rotationProbabilityDataSet.add(new ProbabilityObject(0, 90));
  }

  // Get our partition of this poster!
  void getPartition() {
    partitionValue = (float)getRandomByProbabilityObject(partitionProbabilityDataSet).value;

    for (HashMap.Entry<String, Float> e : partitionDataSet.entrySet()) {
      Object key = e.getKey();
      Object value = e.getValue();
      if ((float)value == partitionValue) {
        partitionType = key.toString();
      }
    }

    grids.add(new Grid(posterWidth, posterHeight * partitionValue, 0));
    grids.add(new Grid(posterWidth, posterHeight * (1-partitionValue), 1));
  }

  void getRotation() {
    rotation = (int)getRandomByProbabilityObject(rotationProbabilityDataSet).value;
  }
}

//////////////////////////////////////////////////

class Grid {
  boolean occupied; //if it has stuff on it
  float h, w;
  private color backgroundColor; 
  boolean backgroundColorSet = false;
  boolean fullHeight; 
  int index; //0 means this grid is on top, 1 means bottom

  Grid (float _width, float _height, int i) {
    w = _width;
    h = _height;
    index = i;
    if (h == posterHeight)fullHeight = true;
  }
  void setBackgroundColor(color c) {
    backgroundColor = c;
    backgroundColorSet = true;
  }
}