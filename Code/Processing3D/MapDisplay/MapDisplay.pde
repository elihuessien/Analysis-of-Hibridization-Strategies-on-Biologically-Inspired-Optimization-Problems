/*
Program Design: This program was designed solely for
visual verification purposes. It does not affect the
outcomes of the TSP experiments in any way, however, it
provides a tool to visualise any given suggested route
(or solution) on a given map. 

Authur:   Elihu Essien-Thompson
Date:     17/02/2021
*/


ArrayList<Vector> map = new ArrayList<Vector>(); // list of vectors/cities
static int MAPSIZE = 50;  // number of cities to expect
static int MAPNUM = 1;   // maps id

int buffer = 50;         // for visual design purposes

// example route to visualize. This variable will be 
// collected from the result of the algorithms 
// when requested for checking
int[] route = {};

void setup(){
  size(600,600);          // 500x500 map + buffer of 100 on all sides
  LoadMap();              // populate the map arraylist
}

void draw(){
  background(240,240,240);
  
  
  // draw black frame
  stroke(0);
  strokeWeight(5);
  line(buffer, buffer, width-buffer, buffer);                // top
  line(buffer, height-buffer, width-buffer, height-buffer);  // bottom
  line(buffer, buffer, buffer, height-buffer);               // left
  line(width-buffer, buffer, width-buffer, height-buffer);   // right
  
  
  //draw route
  stroke(240, 0, 0);
  strokeWeight(2);
  for(int i = 0; i < (route.length); i++)
  {
    int prevCity = route[i];
    // the mod(%) opperator allows a loop back to the start
    int nextCity = route[(i+1) % route.length];
    int prevX = map.get(prevCity).x;
    int prevY = map.get(prevCity).y;
    int nextX = map.get(nextCity).x;
    int nextY = map.get(nextCity).y;
    line(prevX, prevY, nextX, nextY);
  }
  
  
  // draw all cities
  fill(255, 120, 0);
  stroke(255, 255, 0);
  strokeWeight(1);
  for (Vector v : map) {
    v.render();
  }
}


void LoadMap(){
  // read from file
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Maps/Size - "+ MAPSIZE + "/map" + MAPNUM + ".txt");
  
  for (String line:lines)
  {
    // clean the string
    line = line.replace("\n","");
    line = line.replace(" ","");
    
    // extract the vectors
    String[] coOrds = line.split(",");
    int x = int(coOrds[0]) + buffer;
    int y = int(coOrds[1]) + buffer;
    
    // create new vector object to add to the arraylist
    Vector v = new Vector(x, y, 15);
    map.add(v);
  }
}
