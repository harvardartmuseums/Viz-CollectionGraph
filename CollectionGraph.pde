import peasy.*;
import java.awt.event.KeyEvent;

int highlightIndex = 0;
int graphScale = 15; 
int graphSpacing = 100; //the distance between the graph lines
int numberOfDays = 0;
int numberOfGraphLines = 0;
int stopIndex = 0;
int[][] pagePoints;
String[] labels;
String[] days;
color highlight = #FFFFFF;

Boolean recording = false;
Boolean paused = false;
Boolean startupAnimation = true;
Boolean hideUnselected = false;
Boolean cameraTracking = true;
int startupFrameCounter = 0;

PeasyCam cam;

PFont font;

void setup() {
  fullScreen(P3D, SPAN);
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

  for (int c=0; c<numberOfGraphLines-1; c++) {   
    pushMatrix();
    translate(0, height/2, c*-graphSpacing);
    
    if (c==highlightIndex) {
      highlight = #FF0000;
    } else {
      highlight = #FFFFFF;
    }
    
    
    
    if (startupAnimation) {
      stopIndex = startupFrameCounter;
    } else {
      stopIndex = numberOfDays;
    }
    
    
    if (!hideUnselected || (hideUnselected && (c==highlightIndex))) {
      
      //draw the graph line
      noFill();
      stroke(highlight);
      for (int i=0; i<stopIndex-1; i++) {
        beginShape(LINES);
        vertex(i*graphScale, -pagePoints[c][i], 0);
        vertex((i+1)*graphScale, -pagePoints[c][i+1], 0); 
        endShape();
      }
      
      //draw the label on the graph line
      fill(highlight);
      text(labels[c], (stopIndex*graphScale) + 25, 0, 0);
    }
    
    popMatrix();

  }
  
  //Show the last day
  fill(#FFFFFF);
  pushMatrix();
  translate(0, height/2, 0);
  text(days[startupFrameCounter], (startupFrameCounter*graphScale) + 500, 0, 0);
  popMatrix();
  
  if (recording) {
    saveFrame("output/frames####.png");
  }
  
  if (startupAnimation && !paused) {
    startupFrameCounter++;
    if (startupFrameCounter == numberOfDays) {
      startupFrameCounter = numberOfDays-1;
      startupAnimation = false;
    }
  }
}