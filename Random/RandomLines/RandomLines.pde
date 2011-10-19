int MAX_COLOR_VALUE = 255;
int MIN_COLOR_VALUE = 0;
int[] WHITE_PIXEL = {
  0, 0, 0
};

void setup() {
  size(600, 600);
  smooth();
  background(255);
}

void draw() {
}

void mouseMoved() {
  background(255);
  drawVerticalLine(mouseX, height, randomColor());
  drawHorizontalLine(mouseY, width, randomColor());
}


void randomVerticalColoredLines(int lineWidth) {

  int[] colorValues = new int[3];
  int counter = lineWidth;

  for (int x = 0; x < width; x++) {
    if (counter==lineWidth) {
      colorValues = randomColor();
      counter = 0;
    }
    else {
      counter++;
    }
    drawVerticalLine(x, height, colorValues);
  }
}

void randomHorizontalColoredLines(int lineWidth) {

  int[] colorValues = new int[3];
  int counter = lineWidth;

  for (int y = 0; y < height; y++) {
    if (counter==lineWidth) {
      colorValues = randomColor();
      counter = 0;
    }
    else {
      counter++;
    }
    drawHorizontalLine(y, width, colorValues);
  }
}

void drawVerticalLine(int x, int maxY, int[] colorValues) {
  loadPixels();
  for (int y = 0; y < maxY; y++) {
    colorPixel(x, y, colorValues);
  }
  updatePixels();
}

void drawHorizontalLine(int y, int maxX, int[] colorValues) {
  loadPixels();
  for (int x = 0; x < maxX; x++) {
    colorPixel(x, y, colorValues);
  }
  updatePixels();
}


int[] randomColor() {
  int[] randomValues = new int[3];
  for (int x = 0; x<3; x++) {
    randomValues[x] = int(random(MIN_COLOR_VALUE, MAX_COLOR_VALUE));
  }
  return randomValues;
}

void colorPixel(int x, int y, int[] colorValues) {
  int loc = x + y * width;
  pixels[loc] = color(colorValues[0], colorValues[1], colorValues[2]);
}

