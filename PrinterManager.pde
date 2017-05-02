class PrinterManager {

  void sendToPrinter(Poster poster) {
    //send poster content to physical printer and print it out
    //setChanged();
    //notifyObservers();
  }

  StageInfo print(Poster poster, int poster_count) {
    poster.content.save("posters/poster #" + poster_count+".jpg");
    String details = "Sending to Printer HP T120.";
    PGraphics completedPoster = poster.content;
    StageInfo stageInfo = new StageInfo(details, completedPoster);
    return stageInfo;
  }
}