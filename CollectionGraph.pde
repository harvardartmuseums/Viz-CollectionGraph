import peasy.*;

int graphScale = 15; 
int graphSpacing = 100; //the distance between the graph lines
int numberOfDays = 0;
int numberOfGraphLines = 0;
int[][] pagePoints;
String[] labels;

Boolean recording = false;
Boolean paused = false;
Boolean startupAnimation = true;
Boolean cameraTracking = false;
int startupFrameCounter = 0;

PeasyCam cam;

PFont font;

void setup() {
  size(screenWidth, screenHeight, P3D);
  loadData();

  font = createFont("Arial", 32);
  textFont(font, 32);
  
  if (cameraTracking) {
    cam = new PeasyCam(this, 0, 0, 0, 750);
  } else {
    cam = new PeasyCam(this, (numberOfDays*graphScale)/2, 0, 0, 750);
  }

}

void draw() {
  background(128);

  if (cameraTracking) {
    cam.lookAt(startupFrameCounter*graphScale, 0, 750);
  }

  noFill();
  stroke(255);

  for (int c=0; c<numberOfGraphLines-1; c++) {   
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
      text(labels[c], (startupFrameCounter*graphScale) + 25, 0, 0);
    }

    popMatrix();
  }
  
  if (recording) {
    saveFrame("output/frames####.png");
  }
  
  if (startupAnimation && !paused) {
    startupFrameCounter++;
    if (startupFrameCounter == numberOfDays) {
      startupAnimation = false;
    }
  }
}

void loadData() {
  String bits[];
  //Load some labels for the graph
  String lines[] = loadStrings("data-labels.csv");
  
  //Initialize an array to hold the labels (they are stored in alphabetical order)
  labels = new String[lines.length-1];
  numberOfGraphLines = labels.length;

  //Start at one to skip the header row
  for (int i=1; i<lines.length; i++) {
    bits = split(lines[i], ",");
    labels[i-1] = bits[0];
  }  
  println("Loaded " + lines.length + " bits of data");

  //Load the data we are going to graph
  lines = loadStrings("data.csv");
  
  //We can calculate the number of days to graph because of the structure of the data file
  numberOfDays = (lines.length-1)/numberOfGraphLines;

  //Initialize a 2D array to hold the graph data
  pagePoints = new int[numberOfGraphLines][numberOfDays];

  int graphLineCounter = 0;
  int dayCounter = 0;

  //Start at one to skip the header row
  for (int i=1; i<lines.length; i++) {
    bits = split(lines[i], ",");

    pagePoints[int(bits[3])-1][dayCounter] = int(bits[4]);

    graphLineCounter++;
    if (graphLineCounter == numberOfGraphLines) {
      graphLineCounter = 0;
      dayCounter++;
    }
  }  
  println("Loaded " + lines.length + " bits of data");
}

void keyPressed() {
  if (keyCode == KeyEvent.VK_SPACE) {
    paused = !paused;
    
  } else if (keyCode == KeyEvent.VK_R) {
    startupFrameCounter = 0;
    startupAnimation = true;
    
  } else if (keyCode == KeyEvent.VK_C) {
    cameraTracking = !cameraTracking;
    
  } else if (keyCode == KeyEvent.VK_ENTER) {
    saveFrame("snapshots/snapshot-####.png");
  }
}


