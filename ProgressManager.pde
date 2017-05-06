class ProgressManager {
  Stage STAGE;
  int posterCount;
  int stageDelay = 100;
  PFont spaceMono;
  int titleSize = 29;

  ArrayList<ProgressManagerStage> progressManagerStages;

  ProgressManager () {
    spaceMono = createFont("Helvetica", 100);
    posterCount = 0;
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
  void update(Stage _STAGE, StageInfo stageInfo) {
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

  void addDetails(String _details) {
    int currentStageIndex = STAGE.ordinal();
    progressManagerStages.get(currentStageIndex).addDetails(_details);
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
    textFont(spaceMono);
    textAlign(LEFT);
    textSize(titleSize);
    text("Making Poster #" + posterCount + "...", 100, 100);
  }
}
////////////////////////////////////////////////////