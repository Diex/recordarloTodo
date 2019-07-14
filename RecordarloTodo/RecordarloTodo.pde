import processing.video.*;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;


JSONObject settings;

Controller controller;

File mediaFolder, screens, footage;

RecordarState currentState, idle, intro, rec, process;
MemoryState memory;

PrintWriter errors;
boolean withErrors = false;

public boolean isSomeone = false;

SearchCriteria search;

void setup() {
  
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

    exit();
  }

  continueSetup();
  fullScreen(1);
}


public void continueSetup() {
  String[] args = {"Show"};
  controller = new Controller(this);
  frameRate(30);
  Ani.init(this);
  
  try{
  idle = new IdleState(this, screens.getAbsolutePath()+"/idle.mp4");
  intro = new IntroState(this, screens.getAbsolutePath()+"/intro.mp4");
  rec = new RecState(this, screens.getAbsolutePath()+"/record.mp4");
  process = new ProcessState(this, screens.getAbsolutePath()+"/transicion.mp4");
  
  }catch (Exception e){
    e.printStackTrace();
    errors.println(e.toString());
    exit();
  }
  
  folderSelected(new File (settings.getString("defaultPath")+"/footage"));
  
  currentState = rec;
  rec.onEnter();
  
  search = new SearchCriteria(); 
  
}


  // se llama cuando el usuario elije la carpeta
void folderSelected(File selection) {
    vf = new VideoFolder(selection);
    dbConnect(vf);
}
 
void draw() {  
  background(0);
  if (currentState != null) {
    currentState.update();
    currentState.render();
  }
}


public void keyPressed() {
  println("keyPressed", keyCode);
  if (key == 'p') seatChanged();
  if (key == 'a') currentState.onEnter();
  if (key == 'r') randomTags();
}

void randomTags() {
  
  String[] tags = dbGetRandomTags(4);  
  String tagString = "";
  for(String tag : tags) tagString += tag+' ';    
  controller.userInput.setText(tagString);
}

// TODO interfaz con el sensor
public void seatChanged() {
  isSomeone = !isSomeone;
  currentState.callToAction();
}


void movieEvent(Movie m) {
  m.read();
}

public void switchState(RecordarState newState) {
  if (currentState != null) {
    currentState.onExit(newState);
    controller.state_label.setText(newState.getClass().getName());
  }
}

public void exit() {
  controller.openDictation();
  errors.println("recordarlo todo says bye bye...");
  errors.flush(); // Writes the remaining data to the file
  errors.close(); // Finishes the file
  println("recordarlo_10 says bye bye...");
  
  super.exit();
}
