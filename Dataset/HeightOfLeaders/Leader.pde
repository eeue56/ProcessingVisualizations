class Leader {
  String name;
  int heightInCM;
  String heightInFeet;
  Country country;
  double location;

  public Leader(String[] pieces, Country country) {
    this.name = pieces[0];
    this.heightInCM = int(pieces[1]);
    this.heightInFeet = pieces[2];
    this.country = country;
    location = 0.0;
  }

  void draw(int minHeight, int maxHeight, int minWidth, int maxWidth) {
    fill(this.country.colorID);
    this.location = map(this.heightInCM, minHeight, maxHeight, minWidth, maxWidth);
    ellipse((float)location, this.country.lineHeight, this.country.size, this.country.size);
  }

  boolean isNear(int x, int y) {
    int maxX = (int)this.location + this.country.size/2;
    int minX = (int)this.location - this.country.size/2;
    int maxY = this.country.lineHeight + this.country.size/2;
    int minY = this.country.lineHeight - this.country.size/2;
    if ((x <= maxX) && (x >= minX) && (y <= maxY) && (y >= minY)) {
      return true;
    } 
    return false;
  }

  void drawInfo(int startingWidth, int startingHeight) {
    clearLeaderInfo();
    String outputMessage = this.name;
    outputMessage += "\n" + Integer.toString(this.heightInCM) + "cm";
    fill(color(0, 0, 0));
    text(outputMessage, startingWidth, startingHeight);
  }

  void clicked() {
    this.drawInfo(20, height - 70);
  }
}

