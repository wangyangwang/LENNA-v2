
//pass poster to printer
class PrinterManager {
  boolean actuallyPrint = false;
  String mediaType = "RP17x22in";

  StageInfo print2paper(Poster poster) {

    String posterFileName = year()+"_"+month()+"_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"_"+millis()+".png";

    print("Saving file, file name\033[1;34m"+posterFileName+"\033[0m");
    //poster.content.save("server/posters/"+posterFileName);

    String newPosterPath = sketchPath()  + "/server/posters/"+posterFileName;
    String htmlIMGPath = "/posters/"+posterFileName;

    print("<img src='"+htmlIMGPath+"'/>");
    // print()

    if (actuallyPrint) {
      print("Sending designed poster to printer...");
      sendToPrinter(newPosterPath);
    }

    String details = "Sending to Printer";
    PGraphics completedPoster = poster.content;
    StageInfo stageInfo = new StageInfo(details, completedPoster);
    return stageInfo;
  }

  void sendToPrinter(String pathToFile) {
    try {
      print(pathToFile);
      Process p = Runtime.getRuntime().exec("lp -o portrait -o media=" + mediaType +" -o page-left=72 -o page-right=72 "+pathToFile);
    }
    catch (Exception e) {
      print(e);
    }
  }
}
