class ProgressManagerStage {
  int stageIndex;

  String name;
  PGraphics graphicsPreview;
  String details;
  boolean inProgress;
  boolean thumbnailAdded;
  boolean detailsAdded;

  /* hard coded variables */
  int textSize = 15;
  color textColor = color(255);
  color inProgressTextColor = color(0, 255, 0);
  int inProgressTextSize = 15;
  int previewWidth = 200;
  int previewHeight = (posterHeight * previewWidth) / posterWidth;
  int previewYOffset = 100;
  int detailsYOffset = 20;
  int textOffset = textSize * 2;
  int detailsTextSize = 11;
  color detailsTextColor = color(255);

  //consturctor
  ProgressManagerStage (String _name, int _index) {
    stageIndex = _index;
    name = _name;
    /* init */
    inProgress = false;
    detailsAdded = false;
    graphicsPreview = createGraphics(posterWidth, posterHeight);
  }

  void display(float x, float y) {
    pushMatrix();
    pushStyle();
    translate(x, y);
    textAlign(CENTER);

    /* highlight stage in progress */
    if (inProgress) {
      textSize(inProgressTextSize);
      fill(inProgressTextColor);
    } else {
      textSize(textSize);
      fill(textColor);
    }

    noStroke();
    ellipse(0, 0, 15, 15);
    text(name, 0, textOffset);


    textAlign(LEFT, TOP);
    if (thumbnailAdded) {
      rect(0 - previewWidth/2, previewYOffset, previewWidth, previewHeight); //background
      image(graphicsPreview, 0 - previewWidth/2, previewYOffset, previewWidth, previewHeight);

      //textSize(detailsTextSize);
      //fill(detailsTextColor);
      //text(details, -previewWidth/2, previewHeight + previewYOffset + detailsYOffset);
    } 
    if (detailsAdded) {
      textSize(detailsTextSize);
      fill(detailsTextColor);
      text(details, -previewWidth/2, previewHeight + previewYOffset + detailsYOffset, previewWidth, 10000);
    }


    popStyle();
    popMatrix();
  }

  void addThumbnail(PGraphics pg) {
    graphicsPreview = pg;
    thumbnailAdded = true;
  }

  void addDetails(String _details) {
    details = _details;
    detailsAdded = true;
  }

  void reset() {
    thumbnailAdded = false;
    detailsAdded = false;
    inProgress = false;
    graphicsPreview = null;
    details = "";
  }
}

////////////////////////////////////////////////////

class StageInfo {

  PGraphics thumbnail;
  String details;

  StageInfo(String _de, PGraphics _thu) {
    details = _de;
    thumbnail = _thu;
  }

  StageInfo(String _de) {
    details = _de;
  }
}