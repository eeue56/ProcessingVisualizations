void drawAxis(int startX, int endX, int startY, int endY) {
  /**
   *  Draws axis starting at a given point and ending at two given points
   *
   */
  stroke(0,0,0);
  fill(0,0,0);
  line(startX, startY, endX, startY);
  line(startX, startY, startX, endY);
  
  int currentHeight = this.minLeaderHeight;
  
  while (currentHeight <= this.maxLeaderHeight){
    if (currentHeight%10 == 0){
      text(currentHeight, map(currentHeight, this.minLeaderHeight, this.maxLeaderHeight, startX, endX), startY+15);
    }
    currentHeight += 1;
  }
}

void drawKey() {
  /**
   *  Draws a key
   */
  for (Country currentCountry : this.countries.values()) {
    currentCountry.drawKey();
  }
  this.drawAxis(this.minWidth, this.maxWidth,this.lineHeight, this.lineHeight);
}

void drawHorizontalLine(int y, int maxX, color colorID) {
  loadPixels();
  for (int x = 0; x < maxX; x++) {
    colorPixel(x, y, colorID);
  }
  updatePixels();
}

void drawCountries() {
  /**
   *  Draws all the countries
   */
  for (Country currentCountry : this.countries.values()) {
    if (!currentCountry.name.equals("All")) {
      currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
    }
  }
}

void drawSingleCountry(String country) {
  /**
   *  Draws a single country
   *  @param country The name of the country to draw
   */
  if (country.equals("All")) {
    drawCountries();
  }
  else {

    for (Country currentCountry : countries.values()) {

      if (currentCountry.name.equals(country)) {
        currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
        break;
      }
    }
  }
}

