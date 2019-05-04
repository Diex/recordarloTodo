import processing.video.*;

class VideoPlayer
{
  
  PApplet parent;
  
  
  int state;
  final int PAUSE = 0;
  final int PLAY = 1;
  

  Movie movie;
  
  VideoPlayer(PApplet parent){
    this.parent = parent;
    
  }
  
  
  void movieEvent(Movie m) {
    m.read();
  }

}
