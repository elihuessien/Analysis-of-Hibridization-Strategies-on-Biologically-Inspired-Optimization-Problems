/*
Program Design: To populate a textfile (map) with
a list of vectors (cities to visit)

Authur:   Elihu Essien-Thompson
Date:     28/01/2021
*/

static int MAPSIZE = 50;  //number of cities per map
static int MAPNUM = 100;    //number of maps generated

void draw(){
  for (int i = 0; i < MAPNUM; i++)
  {
      //initialize map
      String[] maptxt = new String[MAPSIZE];
      for(int j = 0; j < MAPSIZE; j++)
      {
        //co-ordinates lay on a 500x500 map and are coma separated
        maptxt[j] = int(random(0,500)) + ", " + int(random(0,500));
      }
      
      //save strings persistently in a text file
      saveStrings("C:/Users/C14460702/Dissertation/Data/Maps/Size - "+ MAPSIZE + "/map" + i + ".txt", maptxt);
  }
  
  exit(); //clost program after completion
}
