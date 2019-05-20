import processing.video.*;


JSONObject settings;
Movie movie;
Controller c;
Show show;
void setup(){
  
  
  show = new Show();
  String[] args = {"Show", "--fullscreen"};
  PApplet.runSketch(args, show);
  
  //try {
  //  println("trying load json");
  //  settings = loadJSONObject("./data/settings.json");
    
  //}
  //catch(Exception e) {
  //  e.printStackTrace();
  //  settings = new JSONObject();
  //  settings.setString("defaultPath","data/movies/");
  //  saveJSONObject(settings, "./data/settings.json");
  // }
   
   //c = new Controller(this);
}

public void settings(){
  size(1024, 768, P3D);
  

}

void draw(){


}
