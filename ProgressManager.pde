class ProgressManager {
  Stage STAGE;
  int posterCount = 0;
  int stageDelay = 0;
  PFont displayFont;
  int titleSize = 45;
  ArrayList<ProgressManagerStage> progressManagerStages;
  String displayDir;

  ProgressManager () {
    if (width>height) {
      displayDir = "horizontal";
    } else {
      displayDir = "vertical";
    }
    displayFont = createFont("Inconsolata-Bold", 100);
    //posterCount = 0;
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

  void addDetails(String _details) {
    int currentStageIndex = STAGE.ordinal();
    progressManagerStages.get(currentStageIndex).addDetails(_details);
  }


  void display () {
    //set on screen font
    textFont(displayFont);
    //display all stages
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
