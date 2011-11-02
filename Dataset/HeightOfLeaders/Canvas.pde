void clearLeaderInfo() {
  /*
  *  Cleans the leader info section of the screen
  */
  
  fill(255, 255, 255);
  noStroke();
  rect(20, this.height - 90, 200, 80);
  stroke(0, 0, 0);
}    

void cleanScreen() {
  /**
   *  Cleans the screen of everything, then draws the key
   */
  
  background(255);
  this.drawKey();
}
