void getDataFromFile(String filename) {
  String[] lines;
  int recordCount = 0;
  lines = loadStrings(filename);
  this.leaders = new Leader[lines.length];
  int lineHeight = 20;
  Country currentCountry;

  for (int x = 1; x < lines.length; x++) {
    String[] pieces = split(lines[x], ",");
    currentCountry = new Country("placeholder", -12, randomColor());
    if (pieces.length == 4) {
      String country = pieces[3];

      currentCountry = setCountry(country);

      this.leaders[recordCount] = new Leader(pieces, currentCountry);
      currentCountry.addLeader(this.leaders[recordCount]);


      if (this.leaders[recordCount].heightInCM < this.minLeaderHeight) {
        this.minLeaderHeight = this.leaders[recordCount].heightInCM;
      }
      if (this.leaders[recordCount].heightInCM > this.maxLeaderHeight) {
        this.maxLeaderHeight = this.leaders[recordCount].heightInCM;
      }

      recordCount++;
    }
  }
  setGroupedCountries();
  verifiyLeadersLength(recordCount);
}

void setGroupedCountries() {
  Country allCountries = setCountry("All");
  for (Leader leader : this.leaders) {
    allCountries.addLeader(leader);
  }
}

Country setCountry(String countryName) {

  Country currentCountry;
  if (!this.countries.containsKey(countryName)) {
    currentCountry = new Country(countryName, lineHeight, randomColor());
    this.countries.put(countryName, currentCountry);
    this.lineHeight += 15;
  }
  else {
    currentCountry = this.countries.get(countryName);
  }  

  return currentCountry;
}

void verifiyLeadersLength(int recordCount) {
  if (recordCount != this.leaders.length) {
    this.leaders = (Leader[]) subset(this.leaders, 0, recordCount);
  }
}
