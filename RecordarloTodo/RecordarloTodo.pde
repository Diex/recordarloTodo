import processing.video.*;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;


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


RecordarState currentState, idle, intro, rec;

PrintWriter errors;
boolean withErrors = false;

public boolean isSomeone = false;

void setup() {

  boolean resourcesOk = true;
  Date d = new Date();

  errors = createWriter("errors_"+d.getTime()+".txt");


  try {    
    settings = loadJSONObject("settings.json");
    println("settings.loaded");
  }
  catch(Exception e) {
    println("settings.notExists");
    errors.println("settings.notExists");
    exit();
  }

  try {
    String mediaFolderPath = settings.getString("defaultPath");
    if (mediaFolderPath == null) {
      errors.println("settings.defaultPath.null");
      throw new NullPointerException("settings.defaultPath.null");
    }

    mediaFolder = new File(mediaFolderPath);    
    if (!mediaFolder.exists() || !mediaFolder.isDirectory()) {
      errors.println("defaultPath.notExists");
      throw new FileNotFoundException("defaultPath.notExists");
    }

    screens = new File(mediaFolder.getAbsolutePath()+"/screens");
    if (!screens.exists() || !screens.isDirectory()) {
      errors.println("defaultPath/screens.notExists");
      throw new FileNotFoundException("defaultPath/screens.notExists");
    }

    footage = new File(mediaFolder.getAbsolutePath()+"/footage");
    if (!footage.exists() || !footage.isDirectory()) {
      errors.println("defaultPath/footage.notExists");
      throw new FileNotFoundException("defaultPath/footage.notExists");
    }
  }  
  catch (Exception e) {
    e.printStackTrace();
    resourcesOk = false;
    exit();
  }

  if (resourcesOk) continueSetup();
  fullScreen(1);
}


public void continueSetup() {
  String[] args = {"Show"};
  controller = new Controller(this);
  frameRate(30);
  idle = new IdleState(this, screens.getAbsolutePath()+"/idle.mp4");
  intro = new IntroState(this, screens.getAbsolutePath()+"/intro.mp4");
  rec = new RecState(this, screens.getAbsolutePath()+"/record.mp4");
  switchState(idle);
  idle.onEnter();
  currentState = idle;
}



void draw() {
  background(0);
  
  
  
  if (currentState != null) {
    currentState.update();
    currentState.render();    
  }
}


public void keyPressed() {
  println("keyPressed", key);
  if(key == ' ') seatChanged();
  
  
   
  
  if(key == 'a') currentState.onEnter();
}

public void seatChanged(){
  isSomeone = !isSomeone;
  currentState.callToAction();
}


public void myMethod(String t) {
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

public void switchState(RecordarState newState) {
  if (currentState != null) currentState.onExit(newState);
  //currentState = newState;
  //currentState.onEnter();
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

  errors.println("recordarlo todo says bye bye...");
  errors.flush(); // Writes the remaining data to the file
  errors.close(); // Finishes the file

  //saveJSONObject(settings, "data/settings.json");
  println("recordarlo_10 says bye bye...");

  super.exit();
}
