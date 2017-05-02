class Text {
}
////////////////////////////////////////////////////
class Headline extends Text {

  TextBlock textBlock;
}
////////////////////////////////////////////////////
class Paragraph extends Text {

  color textColor;
  ArrayList<TextBlock> columns;
}