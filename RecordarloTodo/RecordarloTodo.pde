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
RecordarState currentState, idle, intro, rec, process, memory;
SearchCriteria search;
Date date;


boolean withErrors = false;

public boolean isSomeone = false;

public boolean isFullScreen = false;


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
    {//do what ever you like
        
        errors.println(s);
        super.print(s);
    }
    
    public void close(){
      errors.flush(); // Writes the remaining data to the file
      errors.close(); // Finishes the file
    }
}


//public static void main(String[] args)
//{

//}

    
void setup() {  

  PrintStream origOut = System.out;
    PrintStream interceptor = new Interceptor(origOut);
    System.setOut(interceptor);// just add the interceptor
  
  try {
    // no existe settings.json
    String mediaFolderPath = settings.getString("defaultPath");
    println(mediaFolderPath);    
    if (mediaFolderPath == null || mediaFolderPath == "" ) {
      System.out.println("settings.defaultPath.null");
      throw new NullPointerException("settings.defaultPath.null");
    }

    // no existe la carpeta
    mediaFolder = new File(mediaFolderPath);    
    if (!mediaFolder.exists() || !mediaFolder.isDirectory()) {
      System.out.println("defaultPath.notExists");
      throw new FileNotFoundException("defaultPath.notExists");
    }

    // no existe screens en la carpeta
    screens = new File(mediaFolder.getAbsolutePath()+"/screens");
    if (!screens.exists() || !screens.isDirectory()) {
      System.out.println("defaultPath/screens.notExists");
      throw new FileNotFoundException("defaultPath/screens.notExists");
    }

    // no existe footage en la carpeta
    footage = new File(mediaFolder.getAbsolutePath()+"/footage");
    if (!footage.exists() || !footage.isDirectory()) {
      System.out.println("defaultPath/footage.notExists");
      throw new FileNotFoundException("defaultPath/footage.notExists");
    }
  }  
  catch (Exception e) {
    e.printStackTrace();
    exit();
  }

  continueSetup();
  
  
}

public void settings(){
  date = new Date();
 

  try {    
    settings = loadJSONObject("settings.json");
    println("settings.loaded");
  }
  catch(Exception e) {
    println("settings.notExists");
    System.out.println("settings.notExists");
    exit();
  }

  if(settings.getString("fullScreen").equals("YES")){    
    int screen = settings.getInt("screen"); 
    isFullScreen = true;
    fullScreen(screen);
  } else{
     size(640, 480); 
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
    System.out.println(e.toString());
    exit();
  }

  String dbConnector = "jdbc:sqlite:"+footage+File.separator+"videos.db";
  search = new SearchCriteria(dbConnector);

  //currentState = idle;
  //idle.onEnter();

  currentState = rec;
  rec.onEnter();
  
  
}
boolean flag = true;

void draw() {
  if(flag && !isFullScreen) {
    int screenX = settings.getInt("screenX");
    int screenY = settings.getInt("screenY");    
    surface.setLocation(screenX, screenY);
    flag = false;
  }
  
  background(0);
  if (currentState != null) {
    currentState.render();
  }
}


public void keyPressed() {
  println("keyPressed", key);
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
  
  System.out.println("recordarlo todo says bye bye...");
  ((Interceptor) System.out).close();
  
  println("recordarlo_10 says bye bye...");
  controller.openDictation();
  super.exit();
}
