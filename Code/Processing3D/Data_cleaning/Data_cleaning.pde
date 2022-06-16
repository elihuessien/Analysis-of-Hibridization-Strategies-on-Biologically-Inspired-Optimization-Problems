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

final String expName = "Experiment 4";
final String section = "";
final String part = "Size - 50";
final String fileName = "PSO_GA_Hybrid2";
String data;

void draw(){
  /*
  for(int i=50; i<101; i+=10)
  {
    loadData("("+i+")");
    formatAndSave("("+i+")");
  }
  */
  
  loadData();
  formatAndSave();
  
  exit();
}


void loadData()
{
  data = "";
  // read from file
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/"+section + part + "/"+fileName+".txt");
  
  for (String line: lines){
    data += line;
  }
}

void loadData(String x)
{
  data = "";
  // read from file
  String[] lines = loadStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/"+section + part + "/"+ fileName + x + ".txt");
  
  for (String line: lines){
    data += line;
  }
}

void formatAndSave(){
  String data2 = data.replace("[","");
  
  //if not already cleaned
  if(!data.equals(data2)){
    //cleaning
    data = data2;
    data = data.replace("\n","");
    
    //format
    String[] lines = data.split("]");
    println(lines.length);
    //replace
    saveStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/"+section + part + "/"+ fileName + ".txt", lines);
  }else{println("Already Cleaned!");}
}

void formatAndSave(String x){
  String data2 = data.replace("[","");
  
  //if not already cleaned
  if(!data.equals(data2)){
    //cleaning
    data = data2;
    data = data.replace("\n","");
    
    //format
    String[] lines = data.split("]");
    println(lines.length);
    //replace
    saveStrings("C:/Users/C14460702/Dissertation/Data/Results/"+ expName+"/"+section + part + "/"+ fileName + x + ".txt", lines);
  }else{println("Already Cleaned!");}
}
