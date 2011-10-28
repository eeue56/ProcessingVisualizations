import java.util.Hashtable;
import java.util.Enumeration;
import java.util.Arrays;
import java.util.ArrayList;

Leader[] leaders;
ArrayList<Country> countries;
int leaderCount;
int START_X;
int START_Y;
int minLeaderHeight;
int maxLeaderHeight;
int minWidth;
int maxWidth;
Hashtable colorCodes;
Hashtable keyBounds;
Hashtable countryLocations;
String[] countryNames;
int MAX_COLOR_VALUE = 230;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  255, 255, 255
};

class Country {
  String name;                                                                                                                                                                                             
  color colorID;
  int lineHeight;
  ArrayList<Leader> members;
  
  public Country (String name, int lineHeight, color colorID){
    this.name = name;
    this.lineHeight = lineHeight;
    this.colorID = colorID;
    this.members = new ArrayList();
  }
  
  void addLeader(Leader leader){
    members.add(leader);
  } 
  
  void draw(int minHeight, int maxHeight, int minWidth, int maxWidth){
  	for (int x = 0; x < this.members.size(); x++){
  		members.get(x).draw(this.lineHeight, minHeight, maxHeight, minWidth, maxWidth);
  	}
  }
  
  void drawKey(){
  	fill(this.colorID);
  	text(this.name, 20, this.lineHeight);
	}
  
}

class Leader {
  String name;
  int heightInCM;
  String heightInFeet;
  Country country;
  int size;

  public Leader(String[] pieces, Country country) {
    this.name = pieces[0];
    this.heightInCM = int(pieces[1]);
    this.heightInFeet = pieces[2];
    this.country = country;
    this.size = 15;
  }
  
  void draw(int lineHeight, int minHeight, int maxHeight, int minWidth, int maxWidth){
    fill(this.country.colorID);
    float location = map(this.heightInCM, minHeight, maxHeight, minWidth, maxWidth);
    ellipse(location, lineHeight, this.size, this.size);  
  }
  
}


void setup() {
  size(1000, 500);
  smooth();
  this.minLeaderHeight = 1000;
  this.maxLeaderHeight = 0;
  this.minWidth = 90;
  this.countries = new ArrayList();
  this.maxWidth = this.width - 20;
  this.colorCodes = new Hashtable();
  this.countryLocations = new Hashtable();
  this.keyBounds = new Hashtable();
  this.START_X = this.width/2;
  this.START_Y = this.height/2;
  background(color(255, 255, 255));
  this.getDataFromFile("HEIGHTS OF LEADERS.csv");
  this.leaderCount = this.leaders.length;
  this.drawCountries();
}

void draw() {
  //drawAxis(this.minWidth - 10, this.maxWidth, 10, this.height -10);
}



void mouseClicked() {
  /**
   *  Cycles through each country to find which name was clicked on, then draw accordingly
   *
   *
   */
  if (this.mouseX < 80) {
    for (int i = 0; i < this.countries.size(); i++ ) {
      int countryPoint = this.countries.get(i).lineHeight;
      if (isNear(this.mouseY, countryPoint, 10)) {
        /*if (currentCountry.equals("All")) {
          this.cleanScreen();
          this.drawCountries(); 
          break;
        }*/
        if (false){
          
        }
        else {
          if (this.mouseButton == LEFT) {
            this.cleanScreen();
            this.countries.get(i).draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
          }
          else {
            this.countries.get(i).draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
          }
          break;
        }
      }
    }
  }
}

boolean isIt(int x, int y, color colorID){
  loadPixels();
  int loc = x + y * this.width;
  if (this.pixels[loc] == colorID){
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
   *  Draws a key from given colorCodes
   */
   
  for (int i = 0; i < this.countries.size(); i++){
  	this.countries.get(i).drawKey();
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

  for (int x = 1; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    if (pieces.length == 4) {

      String country = pieces[3];
      Country currentCountry = new Country(country, lineHeight, randomColor());
      this.countries.add(currentCountry);
      
      this.leaders[recordCount] = new Leader(pieces, currentCountry);

      if (this.leaders[recordCount].heightInCM < this.minLeaderHeight) {
        this.minLeaderHeight = this.leaders[recordCount].heightInCM;
      }
      if (this.leaders[recordCount].heightInCM > this.maxLeaderHeight) {
        this.maxLeaderHeight = this.leaders[recordCount].heightInCM;
      }
      
      recordCount++;
      lineHeight += 20;
    
    }
  }
  
  verifiyLeadersLength(recordCount);
}

void verifiyLeadersLength(int recordCount) {
  if (recordCount != this.leaders.length) {
    this.leaders = (Leader[]) subset(this.leaders, 0, recordCount);
  }
}

void drawCountries() {
  for (int i = 0; i < this.countries.size(); i++) {
    this.countries.get(i).draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
  }
}

void drawSingleCountry(String country) {
  Country currentCountry;
  for (int i = 0; i < this.countries.size(); i++) {
    currentCountry = this.countries.get(i);
    if (currentCountry.name.equals(country)) {
    	currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
    }
  }
}
