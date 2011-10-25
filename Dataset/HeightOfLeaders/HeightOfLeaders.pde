import java.util.Hashtable;
import java.util.Enumeration;
import java.util.Arrays;

Leader[] leaders;
int leaderCount;
int START_X;
int START_Y;
int minHeight;
int maxHeight;
Hashtable colorCodes;
Hashtable keyBounds;
Hashtable countryLocations;
String[] countryNames;
int MAX_COLOR_VALUE = 230;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  255, 255, 255
};

class Leader {
  String name;
  int heightInCM;
  String heightInFeet;
  String country;

  public Leader(String[] pieces) {
    this.name = pieces[0];
    this.heightInCM = int(pieces[1]);
    this.heightInFeet = pieces[2];
    this.country = pieces[3];
  }
}


void setup() {
  size(1000, 500);
  smooth();
  this.minHeight = 1000;
  this.maxHeight = 0;
  this.colorCodes = new Hashtable();
  this.countryLocations = new Hashtable();
  this.keyBounds = new Hashtable();
  this.START_X = this.width/2;
  this.START_Y = this.height/2;
  background(color(255, 255, 255));
  this.getDataFromFile("HEIGHTS OF LEADERS.csv");
  this.leaderCount = this.leaders.length;
  this.keyBounds = this.drawKey(this.colorCodes);
  this.drawCountries();
}

void draw() {
}

void mouseClicked() {
  /**
  *  Cycles through each country to find which name was clicked on, then draw accordingly
  *
  *
  */
  if (this.mouseX < 80) {
    for (Enumeration e = this.keyBounds.keys(); e.hasMoreElements(); ) {
      int currentKey = (Integer) e.nextElement();
      if (near(this.mouseY, currentKey, 10)) {
        String currentCountry = this.keyBounds.get(currentKey).toString();
        if (currentCountry.equals("All")) {
          this.cleanScreen();
          this.drawCountries(); 
          break;
        }
        else {
          if (this.mouseButton == LEFT) {
            this.cleanScreen();
            drawSingleCountry(currentCountry, (Integer)this.countryLocations.get(currentCountry));
          }
          else {
            this.drawSingleCountry(currentCountry, (Integer)this.countryLocations.get(currentCountry));
          }
          break;
        }
      }
    }
  }
}


void cleanScreen() {
  /**
  *  Cleans the screen of everything, then draws the key
  */
  background(255);
  this.drawKey(this.colorCodes);
}

boolean near(int firstPoint, int secondPoint, int tolerance) {
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

Hashtable drawKey(Hashtable colorCodes) {
  /**
  *  Draws a key from given colorCodes
  */
  int startX = 10;
  int startY = 20;
  Hashtable keys = new Hashtable();
  for (Enumeration e = colorCodes.keys(); e.hasMoreElements(); ) {
    String currentKey = e.nextElement().toString();
    fill( (Integer) colorCodes.get(currentKey));
    text(currentKey, startX, startY);
    keys.put(startY, currentKey);
    this.countryLocations.put(currentKey, startY);
    startY += 20;
  }
  fill(color(0, 0, 0));
  text("All", startX, startY);
  keys.put(startY, "All");
  return keys;
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

  for (int x = 1; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    if (pieces.length == 4) {

      String country = pieces[3];
      leaders[recordCount] = new Leader(pieces);
      this.setColorCode(country);
      
      if (leaders[recordCount].heightInCM < this.minHeight) {
        this.minHeight = leaders[recordCount].heightInCM;
      }
      if (leaders[recordCount].heightInCM > this.maxHeight) {
        this.maxHeight = leaders[recordCount].heightInCM;
      }
      recordCount++;
    }
  }

  verifiyLeadersLength(recordCount);
}

void verifiyLeadersLength(int recordCount) {
  if (recordCount != this.leaders.length) {
    this.leaders = (Leader[]) subset(this.leaders, 0, recordCount);
  }
}

void setColorCode(String country) {
  if (!this.colorCodes.contains(country)) {
    this.colorCodes.put(country, randomColor());
  }
}

void drawCountries() {
  Leader currentRecord;
  for (int i = 0; i < this.leaderCount; i++) {
    currentRecord = this.leaders[i];
    this.drawLeader(currentRecord, (Integer)this.countryLocations.get(currentRecord.country));
  }
}

void drawSingleCountry(String country, int lineHeight) {
  Leader currentRecord;
  for (int i = 0; i < this.leaderCount; i++) {
    currentRecord = this.leaders[i];
    if (currentRecord.country.equals(country)) {
        this.drawLeader(currentRecord, (Integer)this.countryLocations.get(currentRecord.country));
    }
  }
}

void drawLeader(Leader currentRecord, int lineHeight){
  fill((Integer) colorCodes.get(currentRecord.country));
  ellipseMode(CENTER);
  ellipse(map(currentRecord.heightInCM, this.minHeight, this.maxHeight, 80, this.width-70), lineHeight, 15, 15);
}

