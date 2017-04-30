class PrinterManager extends Observable{
  
  void sendToPrinter(Poster poster){
    //send poster content to physical printer and print it out
    //setChanged();
    //notifyObservers();
  }
  
  void print(Poster poster, int poster_count) {
    poster.content.save("posters/poster #" + poster_count+".jpg");
  }
}