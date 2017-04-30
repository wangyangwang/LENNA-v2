class ColorDesigner {


  ArrayList<ColorScheme> allColorSchemes;
  PVector prewviewColorRectSize = new PVector(400, 400);

  ColorDesigner(String colorSchemeFileName) {
    allColorSchemes = new ArrayList<ColorScheme>();
    loadColorSchemes(colorSchemeFileName);
  }

  PGraphics design(Poster poster) {
    PGraphics colorPalette;
    colorPalette = createGraphics(posterWidth, posterHeight);

    if (allColorSchemes.size()!=0) {
      poster.colorScheme = allColorSchemes.get(floor(random(0, allColorSchemes.size())));

      for (int i = 0; i < poster.colorScheme.colors.length; i++) {
        colorPalette.beginDraw();
        colorPalette.fill(poster.colorScheme.colors[i]);
        colorPalette.rect(0, (posterHeight/4) * i, posterWidth/2, posterHeight/4);
        colorPalette.fill(0);
        colorPalette.textSize(150);
        colorPalette.text(hex(poster.colorScheme.colors[i]), posterWidth/2, (posterHeight/4) * (i+1));
        colorPalette.endDraw();
      }

      println("Color Designer picked color scheme: " + poster.colorScheme.colors);
    } else {
      println("Err: no color scheme saved in ColorDesigner");
    }

    return colorPalette;
  }

  ///////////////
  void loadColorSchemes(String filename) {
    String[] lines = loadStrings(filename); //get all the lines in the file.

    for (String line : lines) { //iterate through all the lines
      String[] colors = split(line, ","); //in each line, get each color (4 in total )in String format

      color[] oneSet = new color[colors.length];

      for (int i=0; i<colors.length; i++) {  //convert each colro to color

        //color realColor = Integer.parseInt(colors[i].substring(1), 16);
        color realColor = unhex("FF"+colors[i].substring(1));
        if (realColor==0)println("Err: color is 0, color import failed");
        oneSet[i] = realColor;
      }
      ColorScheme colorScheme = new ColorScheme(oneSet);
      allColorSchemes.add(colorScheme);
    }
  }
}

//////////////////////////////////////////////////////////////////////

class ColorScheme {
  public color[] colors;

  ColorScheme(color[] colorArray) {
    this.colors = colorArray;
  }

  void shuffle() {
    this.colors = shuffleColorArray(colors);
  }

  color[] shuffleColorArray(color[] cs) {
    /* return shuffled color array */
    ArrayList<Integer> shuffleSolution = new ArrayList<Integer>();
    color[] shuffledColors = new color[cs.length];

    for (int i = 0; i<cs.length; i++) {
      shuffleSolution.add(cs[i]);
    }

    for (int i = 0; shuffleSolution.size() > 0; i++) {
      int pickedIndex = floor(random(0, shuffleSolution.size()));
      shuffledColors[i] = shuffleSolution.get(pickedIndex);
      shuffleSolution.remove(pickedIndex);
    }

    return shuffledColors;
  }
}