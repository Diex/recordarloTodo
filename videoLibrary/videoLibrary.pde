import processing.video.*;

import controlP5.*;
 
ControlP5 cp5;
ScrollableList videos;
int controllerWidth = 250;
void setup(){
  size(1200, 800, P3D);
  cp5 = new ControlP5(this);
  // create a new button with name 'buttonA'
  cp5.addButton("openFolder")
     .setLabel("Open data folder")
     .setId(02)
     .setPosition(20,20)
     .setSize(controllerWidth,30)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
     
  /* add a ScrollableList, by default it behaves like a DropdownList */
 videos = cp5.addScrollableList("videos")
     .setPosition(20, 60)
     .setSize(controllerWidth, 300)
     .setBarHeight(20)
     .setItemHeight(20);
     folderSelected(new File ("/Users/diex/Documents/Processing/personas/ivanaNebuloni/recordarloTodo/dual_screen_arduino/data/footage/"));
}

Movie current;

void draw(){
  //noLoop();
  
  background(0);
  if(current != null){
    image(current, controllerWidth + 40, 20, current.width, current.height);
  }
  
  
}

void movieEvent(Movie m) {
  m.read();
}


class VideoFolder {
  
  
  private ArrayList<String> files;
  private File folder;
  
  public VideoFolder(File f) {
    this.folder = f;
    this.files = new ArrayList<String>();
    File[] listOfFiles = f.listFiles();
    for (File file : listOfFiles) {
        if (file.isFile()) {
          String n = file.getName();
          if (n.substring(n.length()-4,n.length()).equals(".mp4")) {
            this.files.add(n);
          }
        }
    }
  }
  
  public int size() {
    return files.size();
  }
  
  public String get_video(int file) {
    return this.folder.getPath() + File.separator + files.get(file);
  }
}


class VideoPlayer{


}


public void controlEvent(ControlEvent theEvent) {
  
  
  if(theEvent.getController().getName().equals("openFolder")){
    selectFolder("Select a folder to process:", "folderSelected");
    return;
  }
  
  if(theEvent.getController().getName().equals("videos")){
    String movieName = ((ScrollableList) theEvent.getController()).getItem((int) theEvent.getController().getValue()).get("text").toString();
    String moviePath = vf.folder+File.separator+movieName;
    
    if(current != null) {
      current.stop();
      current = null;
    }
    
    current = new Movie(this,moviePath);
    println(moviePath);
    current.loop(); //<>//
    return;
  }
  
  
  println(theEvent);
  
}


VideoFolder vf;

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    vf = new VideoFolder(selection);
    println(vf.size());
    println(vf.files);
    videos.addItems(vf.files);
    
  }
}
