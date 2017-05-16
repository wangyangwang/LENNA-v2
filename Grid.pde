class Grid {
String contentType;
int h, w;
final boolean fullHeight;
int index;      //0 means this grid is on top, 1 means bottom

Grid (int _width, int _height, int i) {
        w = _width;
        h = _height;
        index = i;
        if (h == posterHeight) {
                fullHeight = true;
        }
        else {
                fullHeight = false;
        };
}
}
