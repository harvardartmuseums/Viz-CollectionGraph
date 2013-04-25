import peasy.*;

int graphScale = 15;
int graphSpacing = 100;
int numberOfDays = 366+365+365+365+365;
int numberOfClassifications = 56;
int[][] pagePoints;
String[] labels;

Boolean startupAnimation = true;
int startupFrameCounter = 0;

PeasyCam cam;

PFont font;

void setup() {
  size(screenWidth, screenHeight, P3D);
  loadData();

  font = createFont("Arial", 32);
  textFont(font, 32);
  
  cam = new PeasyCam(this, (numberOfDays*graphScale)/2, 0, 0, 750);
}

void draw() {
  background(128);

  noFill();
  stroke(255);

  for (int c=0; c<numberOfClassifications-1; c++) {   
    pushMatrix();
    translate(0, height/2, c*-graphSpacing);

    if (startupAnimation) {     
      for (int i=0; i<startupFrameCounter-1; i++) {
        beginShape(LINES);
        vertex(i*graphScale, -pagePoints[c][i], 0);
        vertex((i+1)*graphScale, -pagePoints[c][i+1], 0); 
        endShape();
      }
      text(labels[c], (startupFrameCounter*graphScale) + 25, 0, 0);
    } 
    else {     
      for (int i=0; i<numberOfDays-1; i++) {
        beginShape(LINES);
        vertex(i*graphScale, -pagePoints[c][i], 0);
        vertex((i+1)*graphScale, -pagePoints[c][i+1], 0); 
        endShape();        
      }
    }

    popMatrix();
  }

  if (startupAnimation) {
    startupFrameCounter++;
    if (startupFrameCounter == numberOfDays) {
      startupAnimation = false;
    }
  }
}

void loadData() {
  String bits[];
  String lines[] = loadStrings("data.csv");
  println("Loaded " + lines.length + " bits of data");

  pagePoints = new int[numberOfClassifications][numberOfDays];

  int classificationCounter = 0;
  int dayCounter = 0;

  //Start at one to skip the header row
  for (int i=1; i<lines.length; i++) {
    bits = split(lines[i], ",");

    pagePoints[int(bits[3])-1][dayCounter] = int(bits[4]);

    classificationCounter++;
    if (classificationCounter == numberOfClassifications) {
      classificationCounter = 0;
      dayCounter++;
    }
  }  

  
  lines = loadStrings("data-labels.csv");
  println("Loaded " + lines.length + " bits of data");
  
  labels = new String[lines.length];
  
  //Start at one to skip the header row
  for (int i=1; i<lines.length; i++) {
    bits = split(lines[i], ",");
    labels[i-1] = bits[0];
  }
}



