class Country {
  String name;                                                                                                                                                                                             
  color colorID;
  int lineHeight;
  int size;
  boolean visible;
  boolean selected;
  ArrayList<Leader> leaders;

  public Country (String name, int lineHeight, color colorID) {
    this.name = name;
    this.lineHeight = lineHeight;
    this.size = 12;
    this.colorID = colorID;
    this.leaders = new ArrayList();
    this.selected = false;
    this.visible = true;
  }

  void addLeader(Leader leader) {
    this.leaders.add(leader);
  } 

  void draw(int minHeight, int maxHeight, int minWidth, int maxWidth) {
    /**
     *  Draws all leaders in the country
     */

    if (!this.visible) {
      return;
    }

    if (this.selected) {
      stroke(0, 0, 0);
    }
    else {
      noStroke();
    }

    for (Leader leader : this.leaders) {
      leader.draw(minHeight, maxHeight, minWidth, maxWidth);
    }
  }

  void drawInfo(int startingWidth, int startingHeight) {
    /**
     *  Draws the info about the country
     *  @param startingWidth The width at which the info box starts at
     *  @param startingHeight The height at which the info box starts at
     */

    fill(color(0, 0, 0));

    String outputMessage = "The tallest member is " + this.tallestLeader().name +  ", who is " + Integer.toString(this.tallestLeader().heightInCM) + "cm";
    outputMessage += "\nThe shortest member is " + this.shortestLeader().name + ", who is " + Integer.toString(this.shortestLeader().heightInCM) + "cm";
    outputMessage += "\nThe average height is " + Math.round(this.averageHeight()) + "cm";

    if (this.isSpecial(2)) {
      outputMessage += "\nThere is something special about this country, as it was included though only with a small number of entires";
    }
    else {
      if (this.standardDeviation() < 10) {
        outputMessage += "\nThis country likes having leaders of around the same height, suggesting the citizens vote based on height";
      }
      else if (!this.name.equals("All")) {
        outputMessage += "\nThe heights of these leaders is spread out, suggesting the citizens do not vote based on height";
      }
    }
    text(outputMessage, startingWidth, startingHeight);
  }

  boolean isSpecial(int tolerance) {
    /**
     *  Works out if there's some special about this country
     *  @param tolerance The number for which if the amount of leaders in the country is less than then it is special
     *  @return True if special (below tolerance), false otherwise
     */

    if (this.leaders.size() < tolerance) {
      return true;
    }
    return false;
  }

  void drawKey() {
    /**
     *  Draws the key entry for this country
     */

    fill(this.colorID);
    text(this.name, 20, this.lineHeight);
  }

  double averageHeight() {
    /**
     *  Works out the mean height for this country
     *  @return The mean height of leaders for this country
     */

    int totalHeight = 0;

    for (Leader leader : this.leaders) {
      totalHeight += leader.heightInCM;
    }

    return (double) totalHeight / this.leaders.size();
  }

  double standardDeviation() {
    /**
     *  Works out the standard devation for this country
     *  @return The standard devation of leader heights for this country
     */

    double mean = this.averageHeight();
    double sum = 0;

    for (Leader leader : this.leaders) {
      sum += Math.pow(leader.heightInCM - mean, 2);
    } 

    return Math.sqrt(sum);
  }

  Leader tallestLeader() {
    /**
     *  Works out the tallest leader
     *  @return A leader instance which is the tallest in this country's leaders
     */

    Leader tallest = this.leaders.get(0);
    int maxHeight = tallest.heightInCM;

    for (Leader leader : this.leaders) {
      if (leader.heightInCM > maxHeight) {
        maxHeight = leader.heightInCM;
        tallest = leader;
      }
    }

    return tallest;
  }

  Leader shortestLeader() {
    /**
     *  Works out the shortest leader
     *  @return A leader instance which is the shortest in this country's leaders
     */

    Leader shortest = this.leaders.get(0);
    int shortestHeight = shortest.heightInCM;

    for (Leader leader : this.leaders) {
      if (leader.heightInCM < shortestHeight) {
        shortestHeight = leader.heightInCM;
        shortest = leader;
      }
    }

    return shortest;
  }
}

