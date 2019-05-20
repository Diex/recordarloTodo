import processing.video.*;


JSONObject settings;

Controller controller;
Show show;

void setup(){
  
  
  show = new Show();
  String[] args = {"Show"};
  PApplet.runSketch(args, show);
  
  try {
    println("trying load json");
    settings = loadJSONObject("./data/settings.json");
    
  }
  catch(Exception e) {
    e.printStackTrace();
    settings = new JSONObject();
    settings.setString("defaultPath","data/movies/");
    saveJSONObject(settings, "./data/settings.json");
   }
   
   controller = new Controller(this);
   
}

public void settings(){
  size(1024, 768, P3D);
  

}

void draw(){


}

void folderSelected(File file){
  controller.folderSelected(file);
}

public void exit() {
 
  //try {
  //  if (connection != null) connection.close();
  //}
  //catch (SQLException e) {
  //  e.printStackTrace();
  //}

  saveJSONObject(settings, "data/settings.json");
  println("recordarlo_10 says bye bye...");
  super.exit();
}
