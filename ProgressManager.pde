class ProgressManager {
  Stage STAGE;
  int posterCount;
  int stageDelay;

  ArrayList<ProgressManagerStage> progressManagerStages;


  ProgressManager () {
    posterCount = 0;
    stageDelay = 0;
    progressManagerStages = new ArrayList<ProgressManagerStage>();


    for (int i = 0; i < stageNumber; i++) {
      ProgressManagerStage pms = new ProgressManagerStage(STAGE.values()[i].toString(), i);
      progressManagerStages.add(pms);
    }
  }

  void reset() {
    for (ProgressManagerStage pms : progressManagerStages) {
      pms.reset();
    }
  }

  /* for stage with no thumbnail */
  void update(Stage _STAGE) {
    STAGE = _STAGE;
    if (STAGE == Stage.values()[0]) {
      posterCount++;
    }
  }
  /* for stage with thumbnail */
  void update(Stage _STAGE, PGraphics thumbnail) {
    update(_STAGE);
    int currentStageIndex = STAGE.ordinal();
    println(currentStageIndex, STAGE, progressManagerStages.size());

    progressManagerStages.get(currentStageIndex).addThumbnail(thumbnail);
  }




  void display () {
    for (ProgressManagerStage pms : progressManagerStages) {
      if (STAGE.next().toString() == pms.name) {
        pms.inProgress = true;
      } else {
        pms.inProgress = false;
      }
      pms.display((width/stageNumber)/2 + pms.stageIndex * (width/stageNumber), 200);
    }
    text("making poster #" + posterCount + "...", width/2, 100);
  }
}
////////////////////////////////////////////////////
class ProgressManagerStage {

  String name;
  PGraphics graphicsPreview;
  String subtitle;
  boolean inProgress;
  int stageIndex;
  boolean thumbnailAdded;

  /* hard coded variables */
  int textSize;
  color textColor;
  color inProgressTextColor;
  int inProgressTextSize;
  int previewWidth, previewHeight;
  int previewYOffset;
  int textOffset;

  //consturctor
  ProgressManagerStage (String _name, int _index) {
    stageIndex = _index;
    inProgress = false;

    name = _name;
    graphicsPreview = createGraphics(posterWidth, posterHeight);


    previewWidth = 200;
    previewHeight = (posterHeight * previewWidth) / posterWidth;
    textSize = 15;
    textColor = color(0, 0, 0);
    inProgressTextSize = 15;
    inProgressTextColor = color(0, 255, 0);
    previewYOffset = 100;
    textOffset = textSize*2;
  }

  void display(float x, float y) {
    pushMatrix();
    pushStyle();
    translate(x, y);
    textAlign(CENTER);

    if (inProgress) {
      textSize(inProgressTextSize);
      fill(inProgressTextColor);
    } else {
      textSize(textSize);
      fill(textColor);
    }

    ellipse(0, 0, 15, 15);
    text(name, 0, textOffset);


    if (thumbnailAdded) {
      image(graphicsPreview, 0 - previewWidth/2, previewYOffset, previewWidth, previewHeight);
    }

    popStyle();
    popMatrix();
  }

  void addThumbnail(PGraphics pg) {
    graphicsPreview = pg;
    thumbnailAdded = true;
  }

  void reset() {
    thumbnailAdded = false;
    inProgress = false;
  }
}