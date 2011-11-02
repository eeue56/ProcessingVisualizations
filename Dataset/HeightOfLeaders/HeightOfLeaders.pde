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
  this.getDataFromFile("Data/HEIGHTS OF LEADERS.csv");
  this.leaderCount = this.leaders.length;
  this.drawCountries();
  this.drawKey();
  
}

void draw() {
  
}

void mouseMoved() {
  boolean leaderFound = false;
  for (Leader leader : this.leaders) {
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
            currentCountry.size = 15;
            this.cleanScreen();
            this.drawCountries();  
            currentCountry.drawInfo(this.width/4, this.height - 70);
            currentCountry.selected = false;
            currentCountry.size = 12;
          }
          else {
            this.cleanScreen();
            currentCountry.draw(this.minLeaderHeight, this.maxLeaderHeight, this.minWidth, this.maxWidth);
          }
          break;
        }
      }
    }
  }
}
