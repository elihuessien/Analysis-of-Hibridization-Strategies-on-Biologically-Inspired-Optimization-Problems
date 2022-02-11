/*
Program Design: To populate a textfile (map) with
a list of vectors (cities to visit)

Authur:   Elihu Essien-Thompson
Date:     28/01/2021
*/

static int CITYNUM = 50;  //number of cities per map
static int MAPNUM = 3;    //number of maps generated

void draw(){
  for (int i = 0; i < MAPNUM; i++)
  {
      //initialize map
      String[] maptxt = new String[CITYNUM];
      for(int j = 0; j < CITYNUM; j++)
      {
        //co-ordinates lay on a 500x500 map and are coma separated
        maptxt[j] = int(random(0,500)) + ", " + int(random(0,500));
      }
      
      //save strings persistently in a text file
      saveStrings("C:/Users/C14460702/Dissertation/Data/Maps (size-"+ CITYNUM + ")/map" + i + ".txt", maptxt);
  }
  
  exit(); //clost program after completion
}
