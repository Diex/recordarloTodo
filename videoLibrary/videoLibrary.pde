import processing.video.*; //<>//

import controlP5.*;

ControlP5 cp5;

ScrollableList videosList;
ScrollableList tagsListForVideo;
ScrollableList tagsList;
Toggle removeTag;

Textfield tagInput;

boolean deleteTags = false;

int controllerWidth = 250;

JSONObject settings;

/*
TODO:
 DONE resetear la lista de videos al contenido de la carpeta
 limpiar DB
 eliminar videos que falta
 eliminar links a ese video
 eliminar tags no usados
 DONE listar todos los tags
 DONE agregar un tag de la lista al video
 
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

  cp5.addButton("resetFolder")
    .setLabel("reset to folder")
    .setId(02)
    .setPosition(20, 60)
    .setSize(controllerWidth, 30)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  videosList = cp5.addScrollableList("videosList")
    .setPosition(20, 100)
    .setSize(controllerWidth, 370)
    .setBarHeight(20)
    .setItemHeight(20)
    .setColorCaptionLabel(color(255,0,0));

  // create a toggle and change the default look to a (on/off) switch look
  removeTag = cp5.addToggle("toggle")
    .setLabel("remove tag")
    .setPosition(20, 470)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    .setColorActive(color(0, 116, 217))
    ;


  tagsListForVideo = cp5.addScrollableList("tagsListForVideo")
    .setPosition(20, 520)
    .setSize(controllerWidth, 230)
    .setBarHeight(20)
    .setItemHeight(20)
    .setOpen(true)
    .setColorCaptionLabel(color(255,0,0));

  tagsList = cp5.addScrollableList("tagsList")
    .setPosition(300, 560)
    .setSize(controllerWidth, 220)
    .setBarHeight(20)
    .setItemHeight(20)
    .setOpen(true)
    .setColorCaptionLabel(color(255,0,0));


  tagInput = cp5.addTextfield("tagInput")
    .setSize(controllerWidth, 20)
    .setPosition(300, 520)
    .setFocus(true)
    .setColor(color(255, 255, 255))
    ;

  try {
    settings = loadJSONObject("./data/settings.json");
 
    folderSelected(new File (settings.getString("defaultPath")));
    replaceTagsList(null);
  }
  catch(Exception e) {
    settings = new JSONObject();
    selectFolder("Select a folder to process:", "folderSelected");
  }
  
  

  
}


Movie current;

void draw() {

  background(0);
  if (current != null) {
    image(current, controllerWidth + 40, 20, current.width, current.height);
  }

  parseInputField();
  if (!tagsList.isOpen()) tagsList.open(); 
  if (!tagsListForVideo.isOpen()) tagsListForVideo.open();
}

void movieEvent(Movie m) {
  m.read();
}




String currentVideoName;
String lastTextInput = "";


public void controlEvent(ControlEvent theEvent) {

  if (theEvent.getController().getName().equals("openFolder")) {
    selectFolder("Select a folder to process:", "folderSelected");    
    return;
  }
}

public void resetFolder(ControlEvent theEvent) {

  videosList.clear();    
  videosList.addItems(vf.files);
  videosList.open();
}


public void videosList(ControlEvent theEvent) {
  currentVideoName = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();
  String moviePath = vf.folder+File.separator+currentVideoName;    
  replaceVideo(moviePath);  
  replaceTagsForVideo(dbGetTagsIdForVideo(currentVideoName));
  tagsListForVideo.open();
}

public void tagsList(ControlEvent theEvent) {
  String selectedTag = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();
  tagInput(selectedTag);
}

public void tagsListForVideo(ControlEvent theEvent) {
  String selectedTag = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();

  if (deleteTags) {
    dbDeleteLink(currentVideoName, selectedTag);
    replaceTagsForVideo(dbGetTagsIdForVideo(currentVideoName));
  } else {
    ArrayList<String> videosForTag = dbGetVideosForTag(selectedTag);
    videosList.clear();    
    videosList.addItems(videosForTag);
    videosList.open();
  }
}

public void tagInput(String theText) {
  String tag = theText.toLowerCase();
  dbAddTagToVideo(currentVideoName, tag);
  replaceTagsForVideo(dbGetTagsIdForVideo(currentVideoName));
}


public void toggle(boolean theFlag) {
  if (removeTag == null) return;
  deleteTags = theFlag;

  if (deleteTags) {
    removeTag.setColorActive(color(255, 0, 0));
  } else {
    removeTag.setColorActive(color(0, 116, 217));
  }
}

void replaceTagsList(String match) {
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
}

void parseInputField() {
  if (!lastTextInput.equals(tagInput.getText())) {
    lastTextInput = tagInput.getText();
    replaceTagsList(lastTextInput);
  }
}


// se llama cuando el usuario elije la carpeta
void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    settings.setString("defaultPath",selection.getAbsolutePath());
    vf = new VideoFolder(selection);
    videosList.clear();    
    videosList.addItems(vf.files);
    videosList.open();
    dbConnect(vf);
    dbAddFiles(vf);
    replaceTagsList(null);
  }
}




public void exit() {
  try {
    if (connection != null) connection.close();
  }
  catch (SQLException e) {
    e.printStackTrace();
  }

  saveJSONObject(settings, "data/settings.json");
  println("videLibrary says bye bye...");
  super.exit();
}
