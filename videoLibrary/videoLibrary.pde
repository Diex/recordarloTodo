import processing.video.*; //<>//

import controlP5.*;

ControlP5 cp5;

ScrollableList videosList;
ScrollableList tagsListForVideo;
ScrollableList tagsList;

Textfield tagInput;


int controllerWidth = 250;

/*
TODO:
  resetear la lista de videos al contenido de la carpeta
  limpiar DB
    eliminar videos que falta
    eliminar links a ese video
    eliminar tags no usados
  listar todos los tags
  agregar un tag de la lista al video

*/


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
    .setSize(controllerWidth, 430)
    .setBarHeight(20)
    .setItemHeight(20);

  tagsListForVideo = cp5.addScrollableList("tagsListForVideo")
    .setPosition(20, 520)
    .setSize(controllerWidth, 230)
    .setBarHeight(20)
    .setItemHeight(20);
    
  tagsList = cp5.addScrollableList("tagsList")
    .setPosition(300, 560)
    .setSize(controllerWidth, 220)
    .setBarHeight(20)
    .setItemHeight(20);

  tagInput = cp5.addTextfield("tagInput")
    .setSize(controllerWidth,20)
    .setPosition(300, 520)
    .setFocus(true)
    .setColor(color(255, 255, 255))
    ;
    
   


  folderSelected(new File ("/Users/diex/Documents/Processing/personas/ivanaNebuloni/recordarloTodo/dual_screen_arduino/data/footage/"));
  
  replaceTagsList(null);
}


Movie current;

void draw() {
  
  background(0);
  if (current != null) {
    image(current, controllerWidth + 40, 20, current.width, current.height);
  }
  
  parseInputField();
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
    replaceTagsForVideo(dbGetTagsIdForVideo(currentVideoName));
  }
}

public void tagInput(String theText) {
  String tag = theText.toLowerCase();
  dbAddTagToVideo(currentVideoName, tag);
  replaceTagsForVideo(dbGetTagsIdForVideo(currentVideoName));
}


void replaceTagsList(String match){
  tagsList.clear();
  tagsList.addItems(dbGetTags(match));
  tagsList.open();
  
}

void replaceVideo(String moviePath) {
  if (current != null) {
    current.stop();
    current = null;
  }

  current = new Movie(this, moviePath);    
  current.loop();
}

void replaceTagsForVideo(ArrayList<String> tagsId) {
  tagsListForVideo.clear();

  for (String tagId : tagsId) {
    String tag = dbGetTag(tagId);
    tagsListForVideo.addItem(tag, tagId);
  }

  tagsListForVideo.open();
}

String lastTextInput = "";

void parseInputField(){
  if(!lastTextInput.equals(tagInput.getText())){
    lastTextInput = tagInput.getText();
    replaceTagsList(lastTextInput);
  }
}




void stop() {
  try {

    if (connection != null) connection.close();
  }
  catch (SQLException e) {
    e.printStackTrace();
  }

  super.stop();
}
