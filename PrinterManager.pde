import java.lang.Runtime;


class PrinterManager {
  boolean actuallyPrint = false;


  StageInfo print(Poster poster, int poster_count) {
    String posterFileName = "poster_#" + poster_count+".jpg";

    poster.content.save("posters/"+posterFileName);
    
    //poster.content.beginDraw();
    //poster.content.dispose();
    //poster.content.endDraw();
    
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