import java.util.ArrayList;

ArrayList<Word> words;
int startX;
int startY;

void loadData(String filename) {
  String[] lines;
  lines = loadStrings(filename);

  for (String currentLine : lines) {
    String[] pieces = split(currentLine, "|");

    if (pieces.length == 4) {
      words.add(new Word(pieces[0], float(pieces[1]), float(pieces[2]), float(pieces[3])));
    }
  }
}

color randomColor() {
  /**
   *  Returns a random color in the range of min and max color values
   */
   
  int[] randomValues = new int[3];
  
  for (int x = 0; x < 3; x++) {
    randomValues[x] = int(random(30, 220));
  }
  
  return color(randomValues[0], randomValues[1], randomValues[2]);
}

/**
*  Plots each word on the x axis by the absolute difference between words and
*  between the word usage on the y axis - further from the origin means that it's more frequent 
*  in one dataset than the other.
*/

void plot1(Word word){
  stroke(0);
  strokeWeight(1);
  //draw x
  line(startX, (startY + 20) / 2.0, width - 20, (startY + 20) / 2.0);
  //draw y
  line(startX, 20, startX, startY);
  
  stroke(randomColor());
  strokeWeight(5);
  float x = map(abs(word.before - word.after), 0.0, 1.4, startX,  width - 20);
  float y = map(word.usage, -0.005, 0.005, startY, 20);
  point(x, y);
}

void plot2(Word word){
  stroke(0);
  strokeWeight(1);
  //draw x
  line(startX, (startY + 20) / 2.0, width - 20, (startY + 20) / 2.0);
  //draw y
  line(startX, 20, startX, startY);
  
  fill(randomColor());
  float x = map(abs(word.before - word.after), 0.0, 1.4, startX,  width - 20);
  float y = map(word.usage, -0.005, 0.005, startY, 20);
  text(word.word, x, y);
}

void plot3(Word word){
  stroke(0);
  strokeWeight(1);
  //draw x
  line(startX, (startY + 20) / 2.0, width - 20, (startY + 20) / 2.0);
  //draw y
  line((startX + width - 20)/ 2.0, 20, (startX + width - 20)/ 2.0, startY);
  
  stroke(randomColor());
  strokeWeight(5);
  float x = map(word.before - word.after, -2.0, 2.0, startX,  width - 20);
  float y = map(word.usage, -0.005, 0.005, startY, 20);
  point(x, y);
}

void plot4(Word word){
  stroke(0);
  strokeWeight(1);
  //draw x
  line(startX, (startY + 20) / 2.0, width - 20, (startY + 20) / 2.0);
  //draw y
  line((startX + width - 20)/ 2.0, 20, (startX + width - 20)/ 2.0, startY);
  
  fill(randomColor());
  strokeWeight(5);
  float x = map(word.before - word.after, -1.6, 1.6, startX,  width - 20);
  float y = map(word.usage, -0.005, 0.005, startY, 20);
  text(word.word, x, y);
}

void setup(){
  size(900, 500);
  smooth();
  background(color(255, 255, 255));
  randomSeed(253);

  words = new ArrayList<Word>();
  loadData("output_alice_jekyll_mix.csv");
  
  
  
  startX = 10;
  startY = height - 10;
  
  strokeWeight(5);
  textSize(10);
  rectMode(CENTER);
  for (Word word : words){
     plot4(word); 
  }
  
}
  
