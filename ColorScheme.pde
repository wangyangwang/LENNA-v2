
class ColorScheme {
  public color[] colors;

  color backgroundColor;
  color[] graphicsColor = new color[3];
  color textColor;
  String details;

  ColorScheme(color[] colorArray) {
    this.colors = colorArray;
    backgroundColor = colors[0];
    graphicsColor[0] = colors[1];
    graphicsColor[1] = colors[2];
    graphicsColor[2] = colors[3];

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

    details = "Background Color:   " + hex(backgroundColor) + "\n";
    for (int i = 0; i < graphicsColor.length; i++) {
      details += "Graphics Color " + i + ":   " + hex(graphicsColor[i]) + "\n";
    }
    details+="Text Color:   " + hex(textColor) + "\n";
  }


  void addDetailsToInspector() {
    inspector.addToMeta(details);
  }

  void shuffle() {
    this.colors = shuffleColorArray(colors);
    log.println("Shuffing colors...");
  }

  void setBackgroundWhite() {
    backgroundColor = color(255);
    textColor = color(30);
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