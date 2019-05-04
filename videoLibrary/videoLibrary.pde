import processing.video.*; //<>//

import controlP5.*;

ControlP5 cp5;

ScrollableList videosList;

int controllerWidth = 250;


void setup() {
  size(1200, 800, P3D);
  cp5 = new ControlP5(this);
  // create a new button with name 'buttonA'
  cp5.addButton("openFolder")
    .setLabel("Open data folder")
    .setId(02)
    .setPosition(20, 20)
    .setSize(controllerWidth, 30)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  /* add a ScrollableList, by default it behaves like a DropdownList */
  videosList = cp5.addScrollableList("videosList")
    .setPosition(20, 60)
    .setSize(controllerWidth, 300)
    .setBarHeight(20)
    .setItemHeight(20);
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





public void controlEvent(ControlEvent theEvent) {

  if (theEvent.getController().getName().equals("openFolder")) {
    selectFolder("Select a folder to process:", "folderSelected");
    return;
  }

  if (theEvent.getController().getName().equals("videosList")) {
    String movieName = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();
    String moviePath = vf.folder+File.separator+movieName;
    replaceVideo(moviePath);
    return;
  }


  println(theEvent);
}


void replaceVideo(String moviePath) {
  if (current != null) {
    current.stop();
    current = null;
  }

  current = new Movie(this, moviePath);    
  current.loop();
}
