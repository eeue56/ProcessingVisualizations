import java.util.Hashtable;
import java.util.HashMap;
import java.util.Enumeration;
import java.util.Arrays;
import java.util.ArrayList;
import java.lang.Math;

Leader[] leaders;
HashMap<String, Country> countries;
int lineHeight;
int leaderCount;
int START_X;
int START_Y;
int minLeaderHeight;
int maxLeaderHeight;
int minWidth;
int maxWidth;
int MAX_COLOR_VALUE = 220;
int MIN_COLOR_VALUE = 20;

class Country {
  String name;                                                                                                                                                                                             
  color colorID;
  int lineHeight;
  boolean selected;
  ArrayList<Leader> leaders;

  public Country (String name, int lineHeight, color colorID) {
    this.name = name;
    this.lineHeight = lineHeight;
    this.colorID = colorID;
    this.leaders = new ArrayList();
    this.selected = false;
  }

  void addLeader(Leader leader) {
    leaders.add(leader);
  } 

  void draw(int minHeight, int maxHeight, int minWidth, int maxWidth) {
    
    if (selected){
      stroke(0,0,0);  
    }
    else{
      noStroke();
    }
    
    for (Leader leader : this.leaders) {
      leader.draw(minHeight, maxHeight, minWidth, maxWidth);
    }
  }

  void drawInfo(int startingWidth, int startingHeight) {
    fill(color(0, 0, 0));
    String outputMessage = "The tallest member is " + this.tallestLeader().name +  ", who is " + Integer.toString(this.tallestLeader().heightInCM) + "cm";
    outputMessage += "\nThe shortest member is " + this.shortestLeader().name + ", who is " + Integer.toString(this.shortestLeader().heightInCM) + "cm";
    outputMessage += "\nThe average height is " + Math.round(this.averageHeight()) + "cm";

    if (this.isSpecial(2)) {
      outputMessage += "\nThere is something special about this country, as it was included though only with a small number of entires";
    }
    else {
      if (this.standardDeviation() < 10) {
        outputMessage += "\nThis country likes having leaders of around the same height, suggesting the citizens vote based on height";
      }
      else if (!this.name.equals("All")) {
        outputMessage += "\nThe heights of these leaders is spread out, suggesting the citizens do not vote based on height";
      }
    }
    text(outputMessage, startingWidth, startingHeight);
  }

  boolean isSpecial(int tolerance) {
    if (this.leaders.size() < tolerance) {
      return true;
    }
    return false;
  }

  void drawKey() {
    fill(this.colorID);
    text(this.name, 20, this.lineHeight);
  }

  double averageHeight() {
    int totalHeight = 0;
    for (int i = 0; i < this.leaders.size(); i++) {
      totalHeight += this.leaders.get(i).heightInCM;
    }
    return (double) totalHeight / this.leaders.size();
  }

  double standardDeviation() {
    double mean = this.averageHeight();
    double sum = 0;

    for (Leader leader : leaders) {
      sum += Math.pow(leader.heightInCM - mean, 2);
    } 
    return Math.sqrt(sum);
  }

  Leader tallestLeader() {
    Leader tallest = this.leaders.get(0);
    int maxHeight = tallest.heightInCM;
    for (Leader leader : this.leaders) {
      if (leader.heightInCM > maxHeight) {
        maxHeight = leader.heightInCM;
        tallest = leader;
      }
    }
    return tallest;
  }

  Leader shortestLeader() {
    Leader shortest = this.leaders.get(0);
    int shortestHeight = shortest.heightInCM;
    for (Leader leader : this.leaders) {
      if (leader.heightInCM < shortestHeight) {
        shortestHeight = leader.heightInCM;
        shortest = leader;
      }
    }
    return shortest;
  }
}

class Leader {
  String name;
  int heightInCM;
  String heightInFeet;
  Country country;
  int size;
  double location;

  public Leader(String[] pieces, Country country) {
    this.name = pieces[0];
    this.heightInCM = int(pieces[1]);
    this.heightInFeet = pieces[2];
    this.country = country;
    this.size = 12;
    location = 0.0;
  }

  void draw(int minHeight, int maxHeight, int minWidth, int maxWidth) {
    fill(this.country.colorID);
    this.location = map(this.heightInCM, minHeight, maxHeight, minWidth, maxWidth);
    ellipse((float)location, this.country.lineHeight, this.size, this.size);
  }

  boolean isNear(int x, int y) {
    int maxX = (int)this.location + this.size/2;
    int minX = (int)this.location - this.size/2;
    int maxY = this.country.lineHeight + this.size/2;
    int minY = this.country.lineHeight - this.size/2;
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


void setup() {
  size(1000, 500);
  smooth();
  strokeWeight(2);
  ellipseMode(CENTER);
  randomSeed(203);
  this.lineHeight = 20;
  this.minLeaderHeight = 1000;
  this.maxLeaderHeight = 0;
  this.minWidth = 90;
  this.countries = new HashMap();
  this.maxWidth = this.width - 20;
  this.START_X = this.width/2;
  this.START_Y = this.height/2;
  background(color(255, 255, 255));
  this.getDataFromFile("HEIGHTS OF LEADERS.csv");
  this.leaderCount = this.leaders.length;
  this.drawCountries();
  this.drawKey();
}

void draw() {
  //drawAxis(this.minWidth - 10, this.maxWidth, 10, this.height -10);
}

void mouseMoved() {
  boolean leaderFound = false;
  for (Leader leader : leaders) {
    if (leader.isNear(this.mouseX, this.mouseY)) {
      leader.clicked();
      leaderFound = true;
      break;
    }
  }
  if (!leaderFound) {
    this.clearLeaderInfo();
  }
}

void mouseClicked() {
  /**
   *  Cycles through each country to find which name was clicked on, then draw accordingly
   *
   *
   */

  if (this.mouseX < 80) {
    for (Country currentCountry : this.countries.values()) {
      int countryPoint = currentCountry.lineHeight;
      if (isNear(this.mouseY, countryPoint, 10)) {
        if (currentCountry.name.equals("All")) {
          this.cleanScreen();
          this.drawCountries(); 
          currentCountry.drawInfo(this.width/4, this.height - 70);
          break;
        }
        else {
          if (this.mouseButton == LEFT) {
            currentCountry.selected = true;
            this.cleanScreen();
            this.drawCountries();  
            currentCountry.drawInfo(this.width/4, this.height - 70);
            currentCountry.selected = false;
          }
          else {
            this.cleanScreen();
            currentCountry.selected = true;
            currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
          }
          break;
        }
      }
    }
  }
}

void clearLeaderInfo() {
  fill(255, 255, 255);
  noStroke();
  rect(20, this.height - 90, 200, 80);
  stroke(0, 0, 0);
}    

boolean isIt(int x, int y, color colorID) {
  loadPixels();
  int loc = x + y * this.width;
  if (this.pixels[loc] == colorID) {
    return true;
  }
  return false;
}

void cleanScreen() {
  /**
   *  Cleans the screen of everything, then draws the key
   */
  background(255);
  this.drawKey();
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

void colorPixel(int x, int y, color colorID) {
  int loc = x + y * this.width;
  this.pixels[loc] = colorID;
}

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

void getDataFromFile(String filename) {
  String[] lines;
  int recordCount = 0;
  lines = loadStrings(filename);
  this.leaders = new Leader[lines.length];
  int lineHeight = 20;
  Country currentCountry;

  for (int x = 1; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    currentCountry = new Country("placeholder", -12, randomColor());
    if (pieces.length == 4) {
      String country = pieces[3];

      currentCountry = setCountry(country);

      this.leaders[recordCount] = new Leader(pieces, currentCountry);
      currentCountry.addLeader(this.leaders[recordCount]);


      if (this.leaders[recordCount].heightInCM < this.minLeaderHeight) {
        this.minLeaderHeight = this.leaders[recordCount].heightInCM;
      }
      if (this.leaders[recordCount].heightInCM > this.maxLeaderHeight) {
        this.maxLeaderHeight = this.leaders[recordCount].heightInCM;
      }

      recordCount++;
    }
  }
  setGroupedCountries();
  verifiyLeadersLength(recordCount);
}

void setGroupedCountries() {
  Country allCountries = setCountry("All");
  for (int i = 0; i < this.leaders.length - 1; i++) {
    allCountries.addLeader(this.leaders[i]);
  }
}

Country setCountry(String countryName) {

  Country currentCountry;
  if (!this.countries.containsKey(countryName)) {
    currentCountry = new Country(countryName, lineHeight, randomColor());
    this.countries.put(countryName, currentCountry);
    this.lineHeight += 15;
  }
  else {
    currentCountry = this.countries.get(countryName);
  }  


  return currentCountry;
}


void verifiyLeadersLength(int recordCount) {
  if (recordCount != this.leaders.length) {
    this.leaders = (Leader[]) subset(this.leaders, 0, recordCount);
  }
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

