import java.util.ArrayList;

ArrayList<Word> words;

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

void setup() {
  size(500, 500);
  smooth();
  background(color(255, 255, 255));

  words = new ArrayList<Word>();
  loadData("data.csv");

  int startX = 10;
  int startY = height - 10;
  
  int maxAft = maxAfter();
  println(maxAft);
  
  int maxBef = maxBefore();
  println(maxBef);

  //draw x
  line(startX, startY, width - 10, startY);
  //draw y
  line(startX, 10, startX, startY);

  strokeWeight(5);
  
  for (Word word : words) { 
    stroke(randomColor());
    float x = map(word.afters, 0, maxAft, startX,  width - 10);
    float y = map(word.befores, 0, maxBef, startY, 10);
    point(x, y);
     
  }
}

