import java.util.Hashtable;

Record[] records;
int recordCount;
int START_X;
int START_Y;
Hashtable colorCodes;
int MAX_COLOR_VALUE = 255;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  0, 0, 0
};

void setup() {
  size(1000, 500);
  smooth();
  this.colorCodes = new Hashtable();
  this.START_X = width/2;
  this.START_Y = height/2;
  this.records = getDataFromFile("HEIGHTS OF LEADERS.csv", colorCodes);
  this.recordCount = records.length;
  //println(records[0]);
  //println(colorCodes.get("UK"));
}

Record[] getDataFromFile(String filename, Hashtable colorCodes) {
  Record[] records;
  String[] lines;
  int recordCount = 0;
  lines = loadStrings(filename);
  records = new Record[lines.length];
  
  for (int x = 1; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    if (pieces.length==4) {
      records[recordCount] = new Record(pieces);
      if (!colorCodes.contains(pieces[3])){
        colorCodes.put(pieces[3], randomColor());  
      }
      recordCount++;
    }
  }
  
  if (recordCount != records.length) {
    records = (Record[]) subset(records, 0, recordCount);
  }
  
  return records;
}

void drawAxis(int startX, int endX, int startY, int endY) {
  line(startX, startY, startX, endX);
  line(startX, startY, startX, endY);
}

color randomColor(){
  int[] randomValues = new int[3];
  for (int x = 0; x<3; x++) {
    randomValues[x] = int(random(MIN_COLOR_VALUE, MAX_COLOR_VALUE));
  }
  return color(randomValues[0], randomValues[1], randomValues[2]);
}

void draw() {
  Record currentRecord;
  for (int i = 0; i < this.recordCount; i++) {
    currentRecord = this.records[i];
    fill((Integer)colorCodes.get(currentRecord.country));
    ellipse(map(currentRecord.heightInCM, 100, 200, 0, width), height/(i+1), 15, 15);
  }
}



class Record {
  String name;
  int heightInCM;
  String heightInFeet;
  String country;

  public Record(String[] pieces) {
    name = pieces[0];
    heightInCM = int(pieces[1]);
    heightInFeet = pieces[2];
    country = pieces[3];
  }
}

