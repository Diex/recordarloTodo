public class Show extends PApplet {
  
  Movie currentMovie;
  
  public void settings(){
    this.size(1024, 768);
    fullScreen(1);
    //frameRate(60);
  }
  
  
  public void draw() {
    background(0);
    if (currentMovie != null) {
      int x = (this.width-currentMovie.width)/2;
      int y = (this.height-currentMovie.height)/2;
      image(currentMovie, x, y, currentMovie.width, currentMovie.height);
    }
  }
  
  public void load_video(String v) {
    new_movie(v);
    //last_time = 0.0;
    //k = 0;
  }


  void mousePressed() {
    controller.state = "idle";
    //smoothPrevious = 120;
    println("------------------------------------- MOUSE PRESIONADO");
  }
  
  // ===========================================================
void new_movie(String v) {
  if (currentMovie != null) {
    currentMovie.dispose();
    //println("-|| DISPOSING MOVIE");
  }
  currentMovie = null;

  //println("-|| LOADING MOVIE: " + v);

  currentMovie = new Movie(this, v);
  currentMovie.play();
  //delay(250);
  //println(" ==> " + v + " : " + movie.duration());
}

void movieEvent(Movie m) {
  m.read();
}
}
