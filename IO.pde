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
  
  //scroll forward through the set of suns
  if (keyCode == 38) {
    if (highlightIndex < numberOfGraphLines - 1) {
      highlightIndex++;
    } else {
      highlightIndex = 0;
    }    
  } 
  
  //scroll backward through the set of suns
  if (keyCode == 40) {
    if (highlightIndex == 0) {
      highlightIndex = numberOfGraphLines - 1;
    } else {
      highlightIndex--;
    }
  }
    
}

