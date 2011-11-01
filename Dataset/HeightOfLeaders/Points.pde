boolean isIt(int x, int y, color colorID) {
  loadPixels();
  int loc = x + y * this.width;
  if (this.pixels[loc] == colorID) {
    return true;
  }
  return false;
}

void colorPixel(int x, int y, color colorID) {
  int loc = x + y * this.width;
  this.pixels[loc] = colorID;
}

boolean isNear(int firstPoint, int secondPoint, int tolerance) {
  /**
   *  Some magic to work out if a point is near to another
   * @param firstPoint The inital point
   * @param secondPoint The second point
   * @param tolerance The tolerance with which to calculate
   * @return True if near, false otherwise
   */
  if ((firstPoint - tolerance < secondPoint) && (firstPoint + tolerance > secondPoint)) {
    return true;
  }
  return false;
}  
