class Inspector {
  boolean noise = false;
  StageInfo inspect(Poster poster, int posterCount) {
     //////this is a hack!
    poster.content.beginDraw();
    poster.content.textSize(20);
    poster.content.text(progressManager.progressManagerStages.get(2).details, poster.padding, poster.padding);
    poster.content.text(typeDesigner.details, poster.padding + posterWidth/3, poster.padding);
    poster.content.beginDraw();


    if (noise) {
      addNoise(poster);
    }
    String details = "Inspected";
    StageInfo stageInfo = new StageInfo(details);
    return stageInfo;
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
