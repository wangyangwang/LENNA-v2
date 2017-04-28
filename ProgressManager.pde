class ProgressManager {
  Stage STAGE;
  int posterCount;
  int stageDelay;

  ProgressManager () {
    posterCount = 0;
    stageDelay = 50;
  }


  void updateTo(Stage _STAGE) {
    STAGE = _STAGE;
    if(STAGE == Stage.values()[0]) {
      posterCount++;
    }
 
  }


  void display () {
    int enumCount = STAGE.values().length;
    for (int i=0; i < enumCount; i++) {

      pushMatrix();
      translate((width/enumCount)/2 + i * (width/enumCount), height/2);
      textSize(15);
      fill(255);
      text(Stage.values()[i].toString(), 0, 0);

      if (STAGE == Stage.values()[i]) {
        fill(0, 255, 0);
      } else {
        fill(0);
      }
      ellipse(0, -20, 10, 10);
      popMatrix();
    }
    
    text("making poster #" + posterCount + "...", width/2, 100);
  }
  
  
}