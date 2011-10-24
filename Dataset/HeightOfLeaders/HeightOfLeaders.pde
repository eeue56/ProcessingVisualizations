import java.util.Hashtable;
import java.util.Enumeration;

Leader[] leaders;
int leaderCount;
int START_X;
int START_Y;
Hashtable colorCodes;
Hashtable countries;
String[] countryNames;
int MAX_COLOR_VALUE = 255;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  255, 255, 255
};

void setup() {
  size(1000, 500);
  smooth();
  this.colorCodes = new Hashtable();
  this.countries = new Hashtable();
  this.START_X = width/2;
  this.START_Y = height/2;
  background(color(255,255,255));
  getDataFromFile("HEIGHTS OF LEADERS.csv");
  this.leaderCount = leaders.length;
  drawKey(this.colorCodes);
}

void draw() {
  drawIndividualLeaders();
}

void drawAxis(int startX, int endX, int startY, int endY) {
  line(startX, startY, startX, endX);
  line(startX, startY, startX, endY);
}

void drawKey(Hashtable colorCodes) {
  int startX = 10;
  int startY = 20;
  for (Enumeration e = colorCodes.keys(); e.hasMoreElements(); ) {
    String currentKey = e.nextElement().toString();
    fill((Integer)colorCodes.get(currentKey));
    text(currentKey, startX, startY);
    startY += 12;
  }
}

color randomColor() {
  int[] randomValues = new int[3];
  for (int x = 0; x < 3; x++) {
    randomValues[x] = int(random(MIN_COLOR_VALUE, MAX_COLOR_VALUE));
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
      setColorCode(country);
      setCountry(country, recordCount);

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

void setCountry(String country, int recordCount) {
  if (!this.countries.contains(country)) {
    //this.countryNames.add(country);
    this.countries.put(country, new Country());
  }
  Country currentCountry = (Country)this.countries.get(country);
  currentCountry.addMember(this.leaders[recordCount].heightInCM);
  this.countries.put(country, currentCountry);
}

void drawIndividualLeaders() {
  Leader currentRecord;
  for (int i = 0; i < this.leaderCount; i++) {
    currentRecord = this.leaders[i];
    fill((Integer)colorCodes.get(currentRecord.country));
    ellipse(map(currentRecord.heightInCM, 100, 200, 0, width), height/2, 20, 20);
  }
}

class Country {
  int members;
  Hashtable memberHeights;

  public Country() {
    this.members = 0;
    this.memberHeights = new Hashtable();
  } 

  void addMember(int memberHeight) {
    this.members++;
    if (!this.memberHeights.contains(memberHeight)) {
      this.memberHeights.put(memberHeight, 1);
    }
    else {
      int currentCount = (Integer)memberHeights.get(memberHeight);
      this.memberHeights.put(memberHeight, currentCount++);
    }
  }
}

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

