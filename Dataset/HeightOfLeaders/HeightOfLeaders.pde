Record[] records;
String[] lines;
int recordCount;

int START_X;
int START_Y;

void setup() {
  size(1000, 500);
  smooth();
  START_X = width/2;
  START_Y = height/2;
  lines = loadStrings("HEIGHTS OF LEADERS.csv");
  records = new Record[lines.length];
  for (int x = 0; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    if (pieces.length==4) {
      records[recordCount] = new Record(pieces);
      recordCount++;
    }
  }
  if (recordCount != records.length) {
    records = (Record[]) subset(records, 0, recordCount);
  }
}

void draw() {
  for (int i = 0; i < recordCount; i++) {
    ellipse(map(records[i].heightInCM, 0, 200, 0, width), height/2, 5, 5);
  }
  
}

void drawAxis(int startX, int endX, int startY, int endY){
   line(startX, startY, startX, endX);
   line(startX, startY, startX, endY); 
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

