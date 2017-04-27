class Inspector extends Observable {

  void inspect(Poster poster, int posterCount) {
    poster.content.beginDraw();
    poster.content.textSize(100);
    poster.content.text("Inspected #" + posterCount, 30, 30);
    poster.content.beginDraw();
  }
}