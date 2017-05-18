

class PrinterManager {
  boolean actuallyPrint = false;

  StageInfo print(Poster poster, int poster_count) {
    String posterFileName = "poster_#" + poster_count+".png";
    poster.content.save("posters/"+posterFileName);
    String newPosterPath = sketchPath("")+"posters/"+posterFileName;

    if (actuallyPrint) {
      sendToPrinter(newPosterPath);
    }

    String details = "Sending to Printer HP T120.";
    PGraphics completedPoster = poster.content;
    StageInfo stageInfo = new StageInfo(details, completedPoster);
    return stageInfo;
  }

  void sendToPrinter(String pathToFile) {
    try {
      println(pathToFile);
      Process p = Runtime.getRuntime().exec("lp "+pathToFile);
    }
    catch (Exception e) {
      println(e);
    }
  }
}