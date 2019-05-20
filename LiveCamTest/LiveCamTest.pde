import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
Movie movie; 
PImage halfMovie;

void setup() {
  size(1280, 720);
  //video = new Capture(this, 640/2, 480/2);
  movie = new Movie(this, "people walkink.mp4");
  
    halfMovie = new PImage(1280/2,720/2);
    
  movie.loop();
  
  opencv = new OpenCV(this, 1280/2, 720/2);
  opencv.loadCascade(OpenCV.CASCADE_PEDESTRIAN);
  //video.start();
}

void draw() {
  //scale(2);
  if(movie != null) {
      
    opencv.loadImage(movie);
    image(movie, 0, 0, movie.width, movie.height);
  }
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}

void captureEvent(Capture c) {
  c.read();
}

void movieEvent(Movie m){
  m.read();
  halfMovie.copy(m,0,0,m.width,,,,,)
}
