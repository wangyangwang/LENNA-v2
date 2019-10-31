
//pass poster to printer
class PrinterManager {
  boolean actuallyPrint = false;
  
  StageInfo print(Poster poster) {
    
    String posterFileName = year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_"+millis()+".png";
    
    log.print("Saving file, file name: ["+posterFileName+"]");
    poster.content.save("posters/"+posterFileName);

    String newPosterPath = sketchPath("")+"posters/"+posterFileName;

    if (actuallyPrint) {
      log.print("Sending designed poster to printer...");
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
