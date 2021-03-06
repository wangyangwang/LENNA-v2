class ProgressManagerStage {
  int stageIndex;

  String name;
  PGraphics graphicsPreview;
  String details;
  boolean inProgress;
  boolean thumbnailAdded;
  boolean detailsAdded;

  /* hard coded variables */
  int textSize = 20;
  color textColor = color(0);
  color inProgressTextColor = color(0, 255, 0);
  int inProgressTextSize = textSize;
  float previewWidth = 170;
  float previewHeight;
  int previewYOffset = 100;
  int detailsYOffset = 20;
  int textOffset = textSize * 2;
  int detailsTextSize = 10;
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
    textAlign(LEFT);


    /* highlight stage in progress */
    if (inProgress) {
      textSize(inProgressTextSize);
      fill(inProgressTextColor);
    } else {
      textSize(textSize);
      fill(textColor);
    }

    noStroke();
    box(20);
    text(name, 0, textOffset);

    textAlign(LEFT, TOP);
    if (thumbnailAdded) {
      previewHeight = (Float)(previewWidth/graphicsPreview.width)  * graphicsPreview.height;
      image(graphicsPreview, 0, previewYOffset, previewWidth, previewHeight);
    }
    if (detailsAdded) {
      textSize(detailsTextSize);
      fill(detailsTextColor);
      text(details, 0, previewHeight + previewYOffset + detailsYOffset, previewWidth, 10000);
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