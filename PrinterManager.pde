class PrinterManager extends Observable{
  
  void sendToPrinter(Poster poster){
    //send poster content to physical printer and print it out
    setChanged();
    notifyObservers();
  }
  
  void saveToDisk(Poster poster) {
     save(poster.getContent());
  }
}