ArrayList<Vector> map = new ArrayList<Vector>();
static int MAPSIZE = 10;  // number of cities to expect
static int MAPNUM = 2;    // maps id

int buffer = 100;

int[] route = {5, 7, 0, 9, 1, 8, 4, 2, 3, 6};

void setup(){
  size(700,700);
  LoadMap();
}

void draw(){
  background(100,100,100);
  stroke(0);
  strokeWeight(5);
  // making the box
  line(buffer, buffer, width-buffer, buffer);                // top
  line(buffer, height-buffer, width-buffer, height-buffer);  // bottom
  line(buffer, buffer, buffer, height-buffer);               // left
  line(width-buffer, buffer, width-buffer, height-buffer);   // right
  
  
  //draw route
  stroke(0, 0, 150);
  strokeWeight(2);
  for(int i = 0; i < (route.length); i++)
  {
    int prevCity = route[i];
    int nextCity = route[(i+1) % route.length];
    int prevX = map.get(prevCity).x;
    int prevY = map.get(prevCity).y;
    int nextX = map.get(nextCity).x;
    int nextY = map.get(nextCity).y;
    line(prevX, prevY, nextX, nextY);
  }
  
  
  // draw all cities
  fill(100, 260, 255);
  stroke(0, 0, 255);
  strokeWeight(1);
  for (Vector v : map) {
    v.render();
  }
}


void LoadMap(){
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Maps/Size (size-"+ MAPSIZE + ")/map" + MAPNUM + ".txt");
  
  for (String line:lines)
  {
    line = line.replace("\n","");
    line = line.replace(" ","");
    String[] coOrds = line.split(",");
    int x = int(coOrds[0]) + buffer;
    int y = int(coOrds[1]) + buffer;
    Vector v = new Vector(x, y, 15);
    map.add(v);
  }
}
