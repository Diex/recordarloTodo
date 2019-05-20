import processing.video.*;


JSONObject settings;

// controller
public final int IDLE = 0;
public final int INTRO = 1;
public final int REC = 2;
public final int TRASH = 3;
public final int TRANSITION = 4;

int state = IDLE;


Controller controller;

File mediaFolder = null;   
ScreenVideos screenVideos;
Movie currentMovie;


//public void settings() {
//  fullScreen(1);
//}

void setup() {

  //size(640, 380);
  // opening settings
  try {
    settings = loadJSONObject("./data/settings.json");
    
    println("settings.loaded");
  }
  catch(Exception e) {
    println("settings.notExists");
    settings = new JSONObject();
    saveJSONObject(settings, "./data/settings.json");
  }

  // opening mediafolder
  try {
    mediaFolder = new File(settings.getString("defaultPath"));
    println("mediaFolder.OK");
    loadScreens();
  }  
  catch (NullPointerException e) {
    e.printStackTrace();
    selectFolder("Select a folder to process:", "onMediaFolderSelected");
  }
 
 // fullscreen
  fullScreen(1);

  String[] args = {"Show"};


  println("controller.createGui");
  controller = new Controller(this);
  println("controller.gui.created");

  enterState(IDLE);
  frameRate(30);
  
  
}

void draw() {
  background(0);
  if (currentMovie != null) {
    int x = (this.width-currentMovie.width)/2;
    int y = (this.height-currentMovie.height)/2;
    
    if( currentMovie.width > 0) image(currentMovie, x, y, currentMovie.width, currentMovie.height);
  }
}


private void loadScreens() {
  screenVideos = new ScreenVideos(this, mediaFolder);
}

public void newPerson(){
  enterState(INTRO);
}

public void keyPressed(){
  println("keyPressed", key);
  if(key == 'p') newPerson();
}

public void enterState(int state) {
  switch(state) {
    case IDLE:
      if(currentMovie != null) currentMovie.stop();
      currentMovie = screenVideos.getVideo(ScreenVideos.IDLE);
      currentMovie.jump(0.0);
      currentMovie.loop();
      println("controller.enterState.IDLE");
    break;
    
    case INTRO:
      if(currentMovie != null) currentMovie.stop();
      currentMovie = screenVideos.getVideo(ScreenVideos.INTRO);
      currentMovie.jump(0.0);
      currentMovie.play();
      println("controller.enterState.INTRO");
    
    break;
    
        
    case REC:
      if(currentMovie != null) currentMovie.stop();
      currentMovie = screenVideos.getVideo(ScreenVideos.REC);
      currentMovie.jump(0.0);
      currentMovie.play();
      println("controller.enterState.REC");    
    break;
  
}
    
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
    loadScreens();
    enterState(IDLE);



    //vf = new VideoFolder(selection);
    //videosList.clear();    
    //videosList.addItems(vf.files);
    //videosList.open();
    //dbConnect(vf);
    //dbAddFiles(vf);
    //replaceTagsList(null);
  }

  return selection;
}

void movieEvent(Movie m) {
  m.read();
}

public void movieEnded(){
    println("movie.end");
    if(currentMovie == null) return;
    
    if(currentMovie == screenVideos.getVideo(ScreenVideos.INTRO)){
      enterState(REC);
    }
    
    if(currentMovie == screenVideos.getVideo(ScreenVideos.REC)){
      controller.getWords();
      enterState(IDLE);
    }
    
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
