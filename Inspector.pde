class Inspector {

  StageInfo inspect(Poster poster, int posterCount) {
    poster.content.beginDraw();
    poster.content.textSize(100);
    poster.content.text("Inspected #" + posterCount, 30, 30);
    poster.content.beginDraw();
    String details = "inspected.";
    StageInfo stageInfo = new StageInfo(details);
    return stageInfo;
  }
}