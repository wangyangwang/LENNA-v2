import java.util.Arrays;
import java.util.List;

class PhdWriter {

  ArrayList<String> sentences = new ArrayList<String>();

  public PhdWriter () {
    String[] phdText = loadStrings("phd.txt");

    for (String line : phdText) {
      line = line.replace("\n", "");

      String[] sens = line.split("\\.");

      for (String l : sens) {
        String fina = l.trim();
        fina = fina.replace("\n", "").replace("\r", "");
        sentences.add(fina);
      }
    }
  }

  String getOneSentence() {
    int i = (int)random(0, sentences.size());

    String o = sentences.get(i);
    println(o);
    return o;
  }
}
