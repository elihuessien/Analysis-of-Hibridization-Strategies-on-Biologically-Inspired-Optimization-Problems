/*
Program Design: The resulting data generated from the
Algorithms generated in the wrong format and I am concerned
whether that format would affect the analysis phase. So,
I made this program to clean and appropriately format
the data so that it would face no issues durring in the 
anaylsis phase

Authur:   Elihu Essien-Thompson
Date:     02/03/2021
*/

final int MAPSIZE = 10;
final String expName = "Experiment1B";
final String fileName = "";
String data;

void draw(){
  
  for(int i=0; i<90; i+=10)
  {
    loadData(i);
    formatAndSave(i);
  }
  
  /*
  loadData();
  formatAndSave();*/
  exit();
}


void loadData()
{
  data = "";
  // read from file
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/Size - "+ MAPSIZE + "/"+fileName+".txt");
  
  for (String line: lines){
    data += line;
  }
}

void loadData(int x)
{
  data = "";
  // read from file
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/Size - "+ MAPSIZE + "/"+x+"%.txt");
  
  for (String line: lines){
    data += line;
  }
}

void formatAndSave(){
  String data2 = data.replace("[","");
  
  if(!data.equals(data2)){
    //cleaning
    data = data2;
    data = data.replace("\n","");
    
    //format
    String[] lines = data.split("]");
    println(lines.length);
    //replace
    saveStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/Size - "+ MAPSIZE + "/"+fileName+".txt", lines);
  }else{println("Already Cleaned!");}
}

void formatAndSave(int x){
  String data2 = data.replace("[","");
  
  if(!data.equals(data2)){
    //cleaning
    data = data2;
    data = data.replace("\n","");
    
    //format
    String[] lines = data.split("]");
    println(lines.length);
    //replace
    saveStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/Size - "+ MAPSIZE + "/"+x+"%.txt", lines);
  }else{println("Already Cleaned!");}
}
