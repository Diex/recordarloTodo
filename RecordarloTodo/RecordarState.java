import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;
//import de.looksgood.ani.*;
//import de.looksgood.ani.easing.*;



public class RecordarState {

  Class clazz;
  RecordarloTodo context;
  Movie movie;
  PApplet parent;
 
  float fadeOutTime = 0.2f;  
  float alpha = 1.0f;
  
  public RecordarState(RecordarloTodo context, String file) {
    parent = (PApplet) context;
    
    movie = new Movie(parent, file);
    clazz = context.getClass();
    this.context = context;
  }

  public void onEnter() {
       }


  public void onExit() {
  }

  public void render(){        
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }  
}
