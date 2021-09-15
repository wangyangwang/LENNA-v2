class ColorDesigner {

  ArrayList<ColorScheme> allColorSchemes;
  PVector prewviewColorRectSize = new PVector(400, 400);

  ColorDesigner(String colorSchemeFileName) {
    allColorSchemes = new ArrayList<ColorScheme>();
    loadColorSchemes(colorSchemeFileName);
    print("Loading all color schemes into memoery...");
  }

  StageInfo design(Poster poster) {
    StageInfo thisStageInfo;
    PGraphics colorPalette;
    String colorInfo = "";
    colorPalette = createGraphics(200, 200);

    if (allColorSchemes.size() != 0) {
      poster.colorScheme = allColorSchemes.get(floor(random(0, allColorSchemes.size())));

      if (random(0, 1) < 0.1) {
        poster.colorScheme.shuffle();
      }

      if (random(0, 1) < 0) {
        poster.colorScheme.setBackgroundWhite();
      }

      print("Color Palette selected\033[1;34m" + poster.colorScheme.colors + "]\n");
      print("Background Color\033[1;34m"+ hex( poster.colorScheme.backgroundColor ) + "]\n");
      print("Text Color\033[1;34m"+ hex( poster.colorScheme.textColor ) + "]\n");

      poster.colorScheme.addDetailsToInspector();
      print("Draw color to a thumbnail for the interface...\n");
      colorPalette.beginDraw();
      colorPalette.background(inspectorBackground);
      float colorNodeSize = colorPalette.width/5;
      for (int i = 0; i < poster.colorScheme.colors.length; i++) {
        colorPalette.fill(poster.colorScheme.colors[i]);
        colorPalette.noStroke();
        colorPalette.ellipse(colorNodeSize/2, (colorPalette.height/4) * i + colorPalette.width/5/2, colorNodeSize, colorNodeSize);
        colorInfo += hex(poster.colorScheme.colors[i]).toString() + "\n";
      }
      colorPalette.endDraw();
    } else {
      print("Err: no color scheme saved in ColorDesigner");
    }
    thisStageInfo = new StageInfo(colorInfo, colorPalette);
    return thisStageInfo;
  }

  ///////////////Load colors from local text file
  void loadColorSchemes(String filename) {
    String[] lines = loadStrings(filename); //get all the lines in the file.
    for (String line : lines) { //iterate through all the lines
      String[] colors = split(line, ","); //in each line, get each color (4 in total )in String format
      color[] oneSet = new color[colors.length];
      for (int i=0; i<colors.length; i++) {  //convert each colro to color
        color realColor = unhex("FF"+colors[i].substring(1));
        if (realColor==0)print("Err: color is 0, color import failed");
        oneSet[i] = realColor;
      }
      ColorScheme colorScheme = new ColorScheme(oneSet);
      allColorSchemes.add(colorScheme);
    }
  }
}
