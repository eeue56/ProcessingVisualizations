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
Hashtable countries;
Hashtable keyBounds;
Hashtable countryLocations;
String[] countryNames;
int MAX_COLOR_VALUE = 230;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  255, 255, 255
};

void setup() {
  size(1000, 500);
  smooth();
  this.minHeight = 1000;
  this.maxHeight = 0;
  this.colorCodes = new Hashtable();
  this.countries = new Hashtable();
  this.countryLocations = new Hashtable();
  this.keyBounds = new Hashtable();
  this.START_X = width/2;
  this.START_Y = height/2;
  background(color(255,255,255));
  getDataFromFile("HEIGHTS OF LEADERS.csv");
  this.leaderCount = leaders.length;
  
  this.keyBounds = drawKey(this.colorCodes);
  drawIndividualLeaders();
}

void draw() {
}

void mouseClicked(){
  
  if (this.mouseX < 80){
    
     for (Enumeration e = this.keyBounds.keys(); e.hasMoreElements(); ) {
         int currentKey = (Integer)e.nextElement();
         if (near(this.mouseY, currentKey)){
           String currentCountry = (String) this.keyBounds.get(currentKey);
           if (currentCountry.equals("All")){
              background(255);
              drawKey(this.colorCodes);
              drawIndividualLeaders(); 
              break;
           }
           else{
             if (mouseButton==LEFT){
               background(255);
               drawKey(this.colorCodes);
               drawOnlySingleCountry(currentCountry, (Integer)this.countryLocations.get(currentCountry));
             }
             else{
               drawOnlySingleCountry(currentCountry, (Integer)this.countryLocations.get(currentCountry));
             }
             break;
           }
         }
     }
  }
}

void drawOnlySingleCountry(String country, int lineHeight){
  Leader currentRecord;
  for (int i = 0; i < this.leaderCount; i++) {
    currentRecord = this.leaders[i];
    if (currentRecord.country.equals(country)){
      fill((Integer)colorCodes.get(currentRecord.country));
      ellipseMode(CENTER);
      ellipse(map(currentRecord.heightInCM, this.minHeight-10, this.maxHeight+10, 80, this.width-70), lineHeight, 15, 15);
    }
  }
}

boolean near(int firstPoint, int secondPoint){
  if ((firstPoint - 10 < secondPoint) && (firstPoint + 20 > secondPoint)){
    return true;
  }
  return false;
}

void drawAxis(int startX, int endX, int startY, int endY) {
  line(startX, startY, startX, endX);
  line(startX, startY, startX, endY);
}

Hashtable drawKey(Hashtable colorCodes) {
  int startX = 10;
  int startY = 20;
  Hashtable keys = new Hashtable();
  for (Enumeration e = colorCodes.keys(); e.hasMoreElements(); ) {
    String currentKey = e.nextElement().toString();
    fill((Integer)colorCodes.get(currentKey));
    text(currentKey, startX, startY);
    keys.put(startY,currentKey);
    this.countryLocations.put(currentKey, startY);
    startY += 20;
  }
  fill(color(0,0,0));
  text("All", startX, startY);
  keys.put(startY, "All");
  return keys;
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
      if (leaders[recordCount].heightInCM < this.minHeight){
        this.minHeight = leaders[recordCount].heightInCM;
      }
      if (leaders[recordCount].heightInCM > this.maxHeight){
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
    ellipseMode(CENTER);
    ellipse(map(currentRecord.heightInCM, this.minHeight-10, this.maxHeight+10, 80, this.width - 70), (Integer)this.countryLocations.get(currentRecord.country), 15, 15);
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

