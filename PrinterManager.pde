
//pass poster to printer
class PrinterManager {
  boolean actuallyPrint = false;
  
  StageInfo print(Poster poster) {
    
    String posterFileName = year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_"+millis()+".png";
    
    log.print("Saving file, file name\033[1;34m"+posterFileName+"\033[0m");
    poster.content.save("server/posters/"+posterFileName);

    String newPosterPath = sketchPath()  + "/server/posters/"+posterFileName;
    String htmlIMGPath = "/posters/"+posterFileName;

    log.print("<img src='"+htmlIMGPath+"'/>");
    // log.print()

    if (actuallyPrint) {
      log.print("Sending designed poster to printer...");
      sendToPrinter(newPosterPath);
    }

    String details = "Sending to Printer";
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
