void drawAxis(int startX, int endX, int startY, int endY) {
  /**
   *  Draws axis starting at a given point and ending at two given points
   *
   */
  line(startX, startY, startX, endX);
  line(startX, startY, startX, endY);
}

void drawKey() {
  /**
   *  Draws a key
   */
  for (Country currentCountry : this.countries.values()) {
    currentCountry.drawKey();
  }
}

void drawHorizontalLine(int y, int maxX, color colorID) {
  loadPixels();
  for (int x = 0; x < maxX; x++) {
    colorPixel(x, y, colorID);
  }
  updatePixels();
}

void drawCountries() {
  for (Country currentCountry : this.countries.values()) {
    if (!currentCountry.name.equals("All")) {
      currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
    }
  }
}

void drawSingleCountry(String country) {
  if (country.equals("All")) {
    drawCountries();
  }
  else {
    for (Country currentCountry : countries.values()) {
      if (currentCountry.name.equals(country)) {
        currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
        String outputMessage = "The tallest member is " + currentCountry.tallestLeader().name + "who is" + Integer.toString(currentCountry.tallestLeader().heightInCM) + "cm";
        outputMessage += "\nThe shortest member is " + currentCountry.shortestLeader().name + "who is" + Integer.toString(currentCountry.shortestLeader().heightInCM) + "cm";
        text(outputMessage, this.height - 50, this.width/2);
        break;
      }
    }
  }
}
