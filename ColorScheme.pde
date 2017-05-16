
class ColorScheme {
  public color[] colors;
  float shuffleProbability = 0.1;

  color backgroundColor;
  color[] graphicsColor = new color[3];
  color textColor;

  color brightest;
  color darkest;


  ColorScheme(color[] colorArray) {
    this.colors = colorArray;

    if (random(0, 1)>0.9) {
      shuffle();
    }

    backgroundColor = colors[0];
    graphicsColor[0] = colors[1];
    graphicsColor[1] = colors[2];
    graphicsColor[1] = colors[3];

    if (brightness(backgroundColor) > (255 * 0.85) && saturation(backgroundColor) < 255 * 0.1) {
      //black-ish on light background
      textColor = color(30);
      for (color c : colors) {
        if (brightness(c)<255*0.1) {
          textColor = c;
        }
      }
    } else {
      //white-ish on dark background
      textColor = color(250);
    }
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