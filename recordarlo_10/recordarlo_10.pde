import processing.video.*;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;

JSONObject settings;

// controller
public final int IDLE = 0;
public final int INTRO = 1;
public final int REC = 2;
public final int TRASH = 3;
public final int TRANSITION = 4;

int state = IDLE;


Controller controller;

File mediaFolder;
File screens;
File footage;


//Movie currentMovie;

RecordarState currentState;

RecordarState idle;

void setup() {

  boolean resourcesOk = true;
  
  try {    
    settings = loadJSONObject("./data/settings.json");
    println("settings.loaded");
  }
  catch(Exception e) {
    println("settings.notExists");    
    settings = new JSONObject();
    saveJSONObject(settings, "./data/settings.json");
    println("settings.created");
  }

  
  try {
    String mediaFolderPath = settings.getString("defaultPath");
    if(mediaFolderPath == null) {
      throw new NullPointerException("settings.defaultPath.null");
    }
    mediaFolder = new File(mediaFolderPath);    
    if (!mediaFolder.exists() || !mediaFolder.isDirectory()) {
      throw new FileNotFoundException("defaultPath.notExists");
    }
    println("defaultPath.OK");
    
    screens = new File(mediaFolder.getAbsolutePath()+"/screens");
    if (!screens.exists() || !screens.isDirectory()) {
      throw new FileNotFoundException("defaultPath/screens.notExists");
    }
    println("defaultPath.screens.OK");
    
    footage = new File(mediaFolder.getAbsolutePath()+"/footage");
    if (!footage.exists() || !footage.isDirectory()) {
      throw new FileNotFoundException("defaultPath/footage.notExists");
    }    
    println("defaultPath.footage.OK");  
  }  
  catch (Exception e) {
    e.printStackTrace();
    resourcesOk = false;
    selectFolder("Select a folder to process:", "onMediaFolderSelected");
  }

  if(resourcesOk) continueSetup();
  fullScreen(1);
}

public void continueSetup(){
  
  String[] args = {"Show"};
  println("controller.createGui");
  controller = new Controller(this);
  println("controller.gui.created");
  frameRate(30);
  
  idle = new RecordarState(this, screens.getAbsolutePath()+"/idle.mp4");
  switchState(idle);
}



void draw() {
  background(0);
  
  if (currentState != null) {
    currentState.update();
    int x = (this.width-currentState.width)/2;
    int y = (this.height-currentState.height)/2;
    if ( currentState.width > 0) image(currentState, x, y, currentState.width, currentState.height);
  }
}


public void keyPressed() {
  println("keyPressed", key);

}

public void myMethod(String t){
  println(t);
}

File onMediaFolderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    println("mediaFolder." + selection.getAbsolutePath());
    settings.setString("defaultPath", selection.getAbsolutePath());
    saveJSONObject(settings, "./data/settings.json");    
    this.mediaFolder = selection;
    continueSetup();
  }

  return selection;
}

void movieEvent(Movie m) {
  m.read();
}

public void switchState(RecordarState newState){
  if(currentState != null) currentState.onExit();
  currentState = newState;
  currentState.onEnter();
}

public void movieEnded() {
  println("movie.end");
  //if (currentMovie == null) return;
  //if (currentMovie == screenVideos.getVideo(ScreenVideos.INTRO)) {
  //  enterState(REC);
  //}
  //if (currentMovie == screenVideos.getVideo(ScreenVideos.REC)) {
  //  controller.getWords();
  //  enterState(IDLE);
  //}
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
