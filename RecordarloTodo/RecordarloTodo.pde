import processing.video.*;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import processing.serial.*;



Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port


JSONObject settings;
public static JSONObject synonyms;
Controller controller;
File mediaFolder, screens, footage;
RecordarState currentState, idle, intro, rec, process, memory;
SearchCriteria search;
Date date;

Trigger trigger;

boolean withErrors = false;

public boolean isSomeone = false;

public boolean isFullScreen = false;

public static boolean debug = false;
public static int sessionTime = 40;
public static int sessionCache = 40;

void setup() {  

  PrintStream origOut = System.out;
  PrintStream interceptor = new Interceptor(origOut);
  System.setOut(interceptor);// just add the interceptor

  try {
    // no existe settings.json
    String mediaFolderPath = settings.getString("defaultPath");
    if(debug) println("mediaFolder: " + mediaFolderPath);    
    if (mediaFolderPath == null || mediaFolderPath == "" ) {
      System.out.println("settings.defaultPath.null");
      throw new NullPointerException("settings.defaultPath.null");
    }

    // no existe la carpeta
    mediaFolder = new File(mediaFolderPath);    
    if (!mediaFolder.exists() || !mediaFolder.isDirectory()) {
      if(debug) System.out.println("defaultPath.notExists");
      throw new FileNotFoundException("defaultPath.notExists");
    }

    // no existe screens en la carpeta
    screens = new File(mediaFolder.getAbsolutePath()+"/screens");
    if (!screens.exists() || !screens.isDirectory()) {
      if(debug) System.out.println("defaultPath/screens.notExists");
      throw new FileNotFoundException("defaultPath/screens.notExists");
    }

    // no existe footage en la carpeta
    footage = new File(mediaFolder.getAbsolutePath()+"/footage");
    if (!footage.exists() || !footage.isDirectory()) {
      if(debug) System.out.println("defaultPath/footage.notExists");
      throw new FileNotFoundException("defaultPath/footage.notExists");
    }
  }  
  catch (Exception e) {
    e.printStackTrace();
    exit();
  }

  continueSetup();
}

public void settings() {
  date = new Date();
  

  try {    
    settings = loadJSONObject("settings.json");
    synonyms = loadJSONObject("synonyms.json");
    
    if(debug) println("settings.loaded");
  }
  catch(Exception e) {
    println("settings.notExists");
    if(debug) System.out.println("settings.notExists");
    exit();
  }

  if (settings.getString("fullScreen").equals("YES")) {    
    int screen = settings.getInt("screen"); 
    isFullScreen = true;
    fullScreen(screen);
  } else {
    size(640, 480);
  }
  
  debug = settings.getBoolean("debug");
  if(debug) println(" - new session: " + date.toString());
  
  sessionTime = settings.getInt("sessionTime");
 
 for(String portName : Serial.list()){
   if(portName.indexOf("usbmodem") != -1){
      myPort = new Serial(this, portName, 115200);
      if(debug) System.out.println("arduino at: "+portName);
      myPort.bufferUntil('\n');
      break;
   }   
 }
}

public void continueSetup() {
  String[] args = {"Show"};
  controller = new Controller(this);
  frameRate(30);
  Ani.init(this);

  try {
    idle = new IdleState(this, screens.getAbsolutePath()+"/idle.mp4");
    intro = new IntroState(this, screens.getAbsolutePath()+"/intro.mp4");
    rec = new RecState(this, screens.getAbsolutePath()+"/record.mp4");
    process = new ProcessState(this, screens.getAbsolutePath()+"/transicion.mp4");
    memory = new MemoryState(this, screens.getAbsolutePath()+"/trash.mp4");
  }
  catch (Exception e) {
    e.printStackTrace();
    if(debug) System.out.println(e.toString());
    exit();
  }

  String dbConnector = "jdbc:sqlite:"+footage+File.separator+"videos.db";
  search = new SearchCriteria(dbConnector);

  //currentState = idle;
  //idle.onEnter();

  currentState = rec;
  rec.onEnter();
  
  trigger = new Trigger();
}
boolean flag = true;

void draw() {
  if (flag && !isFullScreen) {
    int screenX = settings.getInt("screenX");
    int screenY = settings.getInt("screenY");    
    surface.setLocation(screenX, screenY);
    flag = false;
  }

  background(0);
  trigger.update(sensor);
  if (currentState != null) {
    currentState.render();
  }
}


public void keyPressed() {
  if(debug) println("keyPressed", key);
  if (key == 'p') idle.onExit();
  if (key == 'r') randomTags();
}


void randomTags() {  
  String[] tags = search.dbGetRandomTags(4);  
  String tagString = "";
  for (String tag : tags) tagString += tag+' ';    
  controller.userInput.setText(tagString);
}

void movieEvent(Movie m) {
  m.read();
}

public void exit() {

  if(debug) System.out.println("recordarlo todo says bye bye...");
  
  ((Interceptor) System.out).close();
  controller.openDictation();
  super.exit();
}

int sensor = 0;

public void serialEvent(Serial s){    
  String val = s.readString(); 
  if(val == null) return;  
  try{
    sensor = Integer.parseInt(val.trim());
  }catch (Exception e){
    //e.printStackTrace();
  }
  if(debug) System.out.println("sensor: " + sensor);
}  


private class Trigger {
  
  int buffer[] = new int[25 * 4]; // 4 secs... aprox
  int pos = 0;
  boolean active = false;
  int MIN_LIM = 50;
  int MAX_LIM = 90;
  
  public Trigger(){
  
  }

  public void update(int sensor){
    buffer[pos] = sensor;
    pos = (pos + 1) % buffer.length;
    
    int avg = avg();
    active = ( avg > MIN_LIM && avg < MAX_LIM)  ? true : false;
    if(!debug) System.out.println(MIN_LIM + " > " + avg + " < " + MAX_LIM + (active ? " * " : ""));
  }
  
  int avg(){
    int sum = 0;
    for(int val : buffer){
      sum += val;
    }    
    return sum/buffer.length;
  }
  
}


private class Interceptor extends PrintStream
{
  PrintWriter errors;

  public Interceptor(OutputStream out)
  {
    super(out, true);
    errors = createWriter("errors_"+date.getTime()+".txt");
  }

  @Override
    public void print(String s)
  {
    //do what ever you like        
    errors.println(s);
    errors.flush(); // Writes the remaining data to the file
    super.print(s);
  }

  public void close() {
    
    errors.close(); // Finishes the file
  }
}
