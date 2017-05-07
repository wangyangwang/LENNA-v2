
////////////////////////////////////////////////////
class Headline {
  SText textBlock;
}
////////////////////////////////////////////////////
class Paragraph {

  color textColor;
  ArrayList<SText> columns;

  Paragraph(int colNumber) {
    for (int i = 0; i < colNumber; i++) {
      //columns.add(new SText());
    }
  }
}