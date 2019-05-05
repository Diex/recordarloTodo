import processing.video.*; //<>//

import controlP5.*;

ControlP5 cp5;

ScrollableList videosList;
ScrollableList tagsForVideo;
Textfield tagInput;

int controllerWidth = 250;


void setup() {
  size(1200, 800, P3D);
  
  cp5 = new ControlP5(this);

  cp5.addButton("openFolder")
    .setLabel("Open data folder")
    .setId(02)
    .setPosition(20, 20)
    .setSize(controllerWidth, 30)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  videosList = cp5.addScrollableList("videosList")
    .setPosition(20, 60)
    .setSize(controllerWidth, 300)
    .setBarHeight(20)
    .setItemHeight(20);
  
  tagsForVideo = cp5.addScrollableList("videoTags")
    .setPosition(20, 520)
    .setSize(controllerWidth, 300)
    .setBarHeight(20)
    .setItemHeight(20);
    
  tagInput = cp5.addTextfield("tagInput")
     .setPosition(300,520)
     .setFocus(true)
     .setColor(color(255,255,255))
     ;
  
  
  
  folderSelected(new File ("/Users/diex/Documents/Processing/personas/ivanaNebuloni/recordarloTodo/dual_screen_arduino/data/footage/"));
}


Movie current;

void draw() {
  //noLoop();  
  background(0);
  if (current != null) {
    image(current, controllerWidth + 40, 20, current.width, current.height);
  }
}

void movieEvent(Movie m) {
  m.read();
}




String currentVideoName;

public void controlEvent(ControlEvent theEvent) {

  if (theEvent.getController().getName().equals("openFolder")) {
    selectFolder("Select a folder to process:", "folderSelected");    
    return;
  }

  if (theEvent.getController().getName().equals("videosList")) {
    currentVideoName = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();
    String moviePath = vf.folder+File.separator+currentVideoName;    
    replaceVideo(moviePath);    
    return;
  }


  //println(theEvent);
}

public void tagInput(String theText) {
  // automatically receives results from controller input
  //println("a textfield event for controller 'input' : "+theText);
  addTagToVideo(currentVideoName, theText);
  
}


void replaceVideo(String moviePath) {
  if (current != null) {
    current.stop();
    current = null;
  }

  current = new Movie(this, moviePath);    
  current.loop();
}


void stop(){
  try{
    
  if(connection != null) connection.close();
  }catch (SQLException e){
    e.printStackTrace();
  }
  
  super.stop();
}
