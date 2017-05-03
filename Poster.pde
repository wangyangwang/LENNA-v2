class Poster {

  int w;
  int h;

  ArrayList<Grid> globalGrids;
  ArrayList<ProbabilityObject> partitions;
  ArrayList<ProbabilityObject> rotations;

  float rotation;
  ColorScheme colorScheme;
  PGraphics content;
  // all choices about this poster
  String posterDetails;

  Poster(int _posterW, int _posterH) {
    w = _posterW;
    h = _posterH;
    partitions = new ArrayList<ProbabilityObject>();
    rotations = new ArrayList<ProbabilityObject>();

    initPartitions();
    initRotations();

    getPartition();
    getRotation();

    content = createGraphics(w, h);

    posterDetails = "[Placeholder] Partition: plan A \n Rotation: angle(30degree) \n";
  }


  void initPartitions() {
    // decide the global partition of this poster
    partitions.add(new ProbabilityObject(0.618, 35/2)); //golden ratio 01
    partitions.add(new ProbabilityObject(1 - 0.618, 35/2)); //golden ratio 01
    partitions.add(new ProbabilityObject(0.797, 30/2)); //silver ratio
    partitions.add(new ProbabilityObject(1 - 0.797, 30/2)); //silver ratio 02
    partitions.add(new ProbabilityObject(0.5, 25)); //5/5
    partitions.add(new ProbabilityObject(1, 10)); //no divide

    //float count = 0;
    //for (ProbabilityObject PO : partitions) {
    //  count += PO.probability;
    //}
    //if (count!=100) {
    //  System.err.println("Partition collection probability sum isn't 100%");
    //}
  }

  void initRotations() {
    //all rotation values are in DEGREE instead of RADIANS
    rotations.add(new ProbabilityObject(45, 15));
    rotations.add(new ProbabilityObject(-45, 15));
    rotations.add(new ProbabilityObject(0, 70));

    //float count = 0;
    //for (ProbabilityObject PO : rotations) {
    //  count += PO.probability;
    //}
    //if (count!=100) {
    //  System.err.println("Rotation collection probability sum isn't 100%");
    //}
  }

  // Get our partition of this poster!
  void getPartition() {
    float odds = random(0, 1);
  }

  void getRotation() {
    float odds = random(0, 1);
    for (ProbabilityObject PO : partitions) {
    }
  }

  ProbabilityObject getRandomByProbabilityObject(ArrayList<ProbabilityObject> list) {
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
}


//////////////////////////////////////////////////

class Grid {
  boolean occupied; //if it has stuff on it
  float h, w;
  color backgroundColor; 
  boolean theBigger; //is this the bigger section or smaller section.
  boolean fullHeight; 

  Grid (float _width, float _height, color _bgColor, boolean _theBigger) {
    w = _width;
    h = _height;
    if (h == posterHeight)fullHeight = true;
    backgroundColor = _bgColor;
    theBigger = _theBigger;
  }
}