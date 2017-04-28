class ColorDesigner {


  ArrayList<ColorScheme> allColorSchemes;


  ColorDesigner(String colorSchemeFileName) {
    allColorSchemes = new ArrayList<ColorScheme>();
    loadColorSchemes(colorSchemeFileName);
  }

  void design(Poster poster) {
    if (allColorSchemes.size()!=0) {
      poster.colorScheme = allColorSchemes.get(floor(random(0, allColorSchemes.size())));
      println("Color Designer picked color scheme: " + poster.colorScheme.colors);
    } else {
      println("Err: no color scheme saved in ColorDesigner");
    }
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