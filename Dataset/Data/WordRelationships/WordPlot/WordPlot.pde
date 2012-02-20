import java.util.ArrayList;

ArrayList<Word> words;
int maxAft;
int maxBef;
int maxOccur;
int startX;
int startY;

void loadData(String filename) {
  String[] lines;
  lines = loadStrings(filename);

  for (String currentLine : lines) {
    String[] pieces = split(currentLine, ",");

    if (pieces.length == 3) {
      words.add(new Word(pieces[0], int(pieces[1]), int(pieces[2])));
    }
  }
}

int maxAfter() {
  int currentMax = -1;
  for (Word word : words) {
    if (word.afters  > currentMax) {
      currentMax = word.afters;
    }
  }
  
  return currentMax;
}

int maxBefore() {
  int currentMax = -1;
  for (Word word : words) {
    if (word.befores  > currentMax) {
      currentMax = word.befores;
    }
  }
  
  return currentMax;
}

int occur(Word word){
  return max(word.afters, word.befores);
}

int maxOcc(){
  int maxOcc = -1;
  
  for (Word word : words){
     if (occur(word) > maxOcc){
      maxOcc = occur(word);
     } 
  }
  
  return maxOcc;
}

color randomColor() {
  /**
   *  Returns a random color in the range of min and max color values
   */
   
  int[] randomValues = new int[3];
  
  for (int x = 0; x < 3; x++) {
    randomValues[x] = int(random(0, 255));
  }
  
  return color(randomValues[0], randomValues[1], randomValues[2]);
}

void plotByValues(Word word){
  stroke(randomColor());
  float x = map(word.afters, 0, maxAft, startX,  width - 20);
  float y = map(word.befores, 0, maxBef, startY, 20);
  point(x, y);
}

void plotByRatio(Word word){
   stroke(randomColor());
   float x = map(occur(word), 0, maxOccur, startX, width - 20);
   float y = map((word.afters + 1)/(word.befores + 1), 0.0, 5.0, startY, 20);
   point(x, y);
}

void plotByRatios(Word word){
  stroke(randomColor());
  float iOccur = word.befores + word.afters;
  
  float newX = word.befores / iOccur;
  float newY = word.afters / iOccur;
  
  float x = map(newX, 0.0, 1.0, startX, width - 20);
  float y = map(newY, 0.0, 1.0, startY, 20);
  
  point(x, y); 
}

void plotWordByRatios(Word word){
  fill(randomColor());
  float iOccur = word.befores + word.afters;
  
  float newX = word.befores / iOccur;
  float newY = word.afters / iOccur;
  
  float x = map(newX, 0.0, 1.0, startX, width - 20);
  float y = map(newY, 0.0, 1.0, startY, 20);
  
  text(word.word, x, y); 
}

void plotWordByValues(Word word){
  fill(randomColor());
  float x = map(word.afters, 0, maxAft, startX,  width - 20);
  float y = map(word.befores, 0, maxBef, startY, 20);
  text(word.word, x, y);
}

void setup() {
  size(500, 500);
  smooth();
  background(color(255, 255, 255));
  randomSeed(250);

  words = new ArrayList<Word>();
  loadData("all.csv");

  startX = 10;
  startY = height - 10;
  
  maxAft = maxAfter();
  
  maxBef = maxBefore();
  
  maxOccur = maxOcc();

  //draw x
  line(startX, startY, width - 20, startY);
  //draw y
  line(startX, 20, startX, startY);

  strokeWeight(5);
  textSize(8);
  rectMode(CENTER);
  
  for (Word word : words) { 
    
     plotByValues(word);
  }
}

