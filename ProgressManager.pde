class ProgressManager{
  
  Stage STAGES;
  int totalStages;
  ProgressWatcher progressWatcher;
  



  ProgressManager () {
    totalStages = STAGES.values().length;
  }


  void updateProgressInterface() {
    
  }
 
  
}

//////////////////////////////////////////////////////////////////

public enum Stage {
  DATA_PREPARING, 
    TYPE_DESIGN, 
    GRAPHIC_DESIGN, 
    INSPECTING, 
    PRINTING
}

/////////////////////////////////////////////////////////////////

class ProgressWatcher implements Observer {
  void update(Observable o, Object arg){
    
  }
}