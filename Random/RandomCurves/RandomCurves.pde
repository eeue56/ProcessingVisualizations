int MAX_COLOR_VALUE = 255;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  0, 0, 0
};

int counter = 0;

void setup() {
  size(500, 500);
  smooth();
  background(255);
}

void draw() {
  stroke(randomColor());
  if (counter % 2 == 0) {
    randomVerticalCurve(0, 0, width, height);
  }
  else {
    randomHorizontalCurve(0, 0, width, height);
  }
  counter++;
}


color randomColor() {
  int[] randomValues = new int[3];
  for (int x = 0; x<3; x++) {
    randomValues[x] = int(random(MIN_COLOR_VALUE, MAX_COLOR_VALUE));
  }
  return color(randomValues[0], randomValues[1], randomValues[2]);
}

void randomHorizontalCurve(int startX, int startY, int maxX, int maxY) {
  beginShape();
  noFill();
  curveVertex(startX, startY);
  curveVertex(startX, startY);
  for (int x = startX; x < maxX; x++) {
    for (int y = startY; y < maxY; y++) {
      int hurp = int(random(2, maxX/1.2));
      int durp = int(random(2, maxY/4));

      if ((x%hurp ==0) && (y%durp == 0)) {
        curveVertex(x, y);
      }
    }
  }
  curveVertex(maxX, maxY);
  curveVertex(maxX, maxY);
  endShape();
}

void randomVerticalCurve(int startX, int startY, int maxX, int maxY) {
  beginShape();
  noFill();
  curveVertex(startX, startY);
  curveVertex(startX, startY);
  for (int y = startY; y < maxY; y++) {
    for (int x = startX; x < maxX; x++) {
      int hurp = int(random(2, maxX/1.2));
      int durp = int(random(2, maxY/4));

      if ((x%hurp ==0) && (y%durp == 0)) {
        curveVertex(x, y);
      }
    }
  }
  curveVertex(maxX, maxY);
  curveVertex(maxX, maxY);
  endShape();
}

