class Inspector {

  boolean noise = false;
  private ArrayList<String> metadata  = new ArrayList<String>();


  StageInfo inspect(Poster poster, int posterCount) {

    //////this is a hack!
    poster.content.beginDraw();
    poster.content.fill(poster.colorScheme.textColor);
    poster.content.textSize(12);

    int y, textRectHeight;

    if (poster.grids.get(0).contentType=="letters") { 
      poster.content.textAlign(LEFT, BOTTOM);
      y = posterHeight - poster.padding;
      textRectHeight = -1000;
    } else {
      poster.content.textAlign(LEFT, TOP);
      y = poster.padding;
      textRectHeight = 1000;
    }

    for (int i = 0; i < metadata.size(); i++) {
      poster.content.text(metadata.get(i), poster.padding + i * (posterWidth/metadata.size()), y, posterWidth/metadata.size(), textRectHeight);
    }

    poster.content.endDraw();

    if (noise) {
      addNoise(poster);
    }
    String details = "Inspected";
    StageInfo stageInfo = new StageInfo(details);
    return stageInfo;
  }

  public void addToMeta(String s) {
    metadata.add(s);
  }

  void reset() {
    metadata.clear();
  }

  void addNoise(Poster poster) {
    float noiseOpacity = 0.1;
    PGraphics noise = createGraphics(posterWidth/10, posterHeight/10);
    noise.beginDraw();
    noise.beginShape(POINTS);

    for (int x = 0; x < noise.width; x++) {
      for (int y=0; y< noise.height; y++) {
        if (random(0, 1)>0.5) {
          noise.stroke(255, 255*noiseOpacity);
        } else {
          noise.stroke(0, 255*noiseOpacity);
        }
        noise.point(x, y);
      }
    }

    noise.endShape();
    noise.endDraw();

    poster.content.beginDraw();
    //poster.content.blendMode(MULTIPLY);
    poster.content.image(noise, 0, 0, posterWidth, posterHeight);
    poster.content.endDraw();
  }
}