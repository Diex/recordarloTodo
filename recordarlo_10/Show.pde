public class Show extends PApplet {
  
  public void settings(){
    this.size(1024, 768);
    fullScreen();
  }
  public void draw() {
    background(0);
    if (movie != null) {
      image(movie, 0, 0, this.width, this.height);
    }

    if (frameCount > 500) {
      //if (c.it != null && !c.it.hasFocus()) {
      //  c.it.requestFocus();
      //}
    }
  }
  public void load_video(String v) {
    new_movie(v);
    //last_time = 0.0;
    //k = 0;
  }


  void mousePressed() {
    c.state = "idle";
    //smoothPrevious = 120;
    println("------------------------------------- MOUSE PRESIONADO");
  }
}


// ===========================================================
void new_movie(String v) {
  if (movie != null) {
    movie.dispose();
    println("-|| DISPOSING MOVIE");
  }
  movie = null;

  println("-|| LOADING MOVIE: " + v);

  movie = new Movie(this, v);
  movie.play();
  delay(250);
  println(" ==> " + v + " : " + movie.duration());
}

void movieEvent(Movie m) {
  m.read();
}
