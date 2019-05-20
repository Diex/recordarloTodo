public class ScreenVideos {

  HashMap<String, Movie> videos;

  PApplet parent;

  public final static String IDLE = "idle";
  public final static String INTRO = "intro";
  public final static String REC = "record";
  public final static String TRASH = "trash";
  public final static String TRANSITION = "transicion";

  private String[] separators = {IDLE, INTRO, REC, TRASH, TRANSITION};

  ScreenVideos(PApplet parent, File screenFolder) {
    this.parent = parent;
    videos = new HashMap<String, Movie>();
    for (String video : separators) {
      try {
        videos.put(video, 
        new Movie(parent, screenFolder.getAbsolutePath()+"/screens/"+video+".mp4"){
          @Override 
            public void eosEvent() {
              super.eosEvent();
              movieEnded();
            }
        });
        println("loaded.["+video+"]."+screenFolder+video+".mp4");
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
  
  
  
  public Movie getVideo(String ID){
    return videos.get(ID);
  }
}
