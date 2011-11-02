color randomColor() {
  /**
   *  Returns a random color in the range of min and max color values
   */
   
  int[] randomValues = new int[3];
  for (int x = 0; x < 3; x++) {
    randomValues[x] = int(random(this.MIN_COLOR_VALUE, this.MAX_COLOR_VALUE));
  }
  return color(randomValues[0], randomValues[1], randomValues[2]);
}
