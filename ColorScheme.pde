
class ColorScheme {
  public color[] colors;
  float shuffleProbability = 0.1;

  color backgroundColor;
  color[] graphicsColor = new color[2];
  color textColor;

  color brightest;
  color darkest;


  ColorScheme(color[] colorArray) {
    this.colors = colorArray;
    backgroundColor = colors[0];
    graphicsColor[0] = colors[1];
    graphicsColor[1] = colors[2];
    textColor = colors[3];

    //float[] brightnesses = new float[colors.length];
    int maxBrightnessColorIndex = 0;
    int minBrightnessColorIndex = 0;

    for (int i = 0; i < colors.length-1; i++ ) {
      if (brightness(colors[i]) < brightness(colors[i+1])) {
        maxBrightnessColorIndex = i+1;
      }

      if (brightness(colors[i]) > brightness(colors[i+1])) {
        minBrightnessColorIndex = i+1;
      }
    }

    brightest = colors[maxBrightnessColorIndex];
    darkest = colors[minBrightnessColorIndex];
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
