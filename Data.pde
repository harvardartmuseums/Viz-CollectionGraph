
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
  
  //Initialize a 1D array to hold the list of days
  days = new String[numberOfDays];

  int graphLineCounter = 0;
  int dayCounter = 0;

  //Start at one to skip the header row
  for (int i=1; i<lines.length; i++) {
    bits = split(lines[i], ",");

    pagePoints[int(bits[3])-1][dayCounter] = int(bits[4]);

    graphLineCounter++;
    if (graphLineCounter == numberOfGraphLines) {
      days[dayCounter] = bits[0];
      
      graphLineCounter = 0;
      dayCounter++;
    }
  }  
  println("Loaded " + lines.length + " bits of data");
}



