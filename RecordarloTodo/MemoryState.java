import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.ArrayList;
import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;

class MemoryState extends RecordarState{
  
  Ani fadeIn,fadeOut, timeOut;
  float alpha = 0.0f;
  float dummy = 0;
  
  ArrayList<Movie> movies;
  
  public MemoryState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );
    
    loadMovies();
    
    
    //timeOut = new Ani(this, 20, "dummy", 1.0f);  
  }
  
  private void loadMovies(){
    
  
    if(context.usefulMovies.size() < 1) return;  /// no hay peliculas
    System.out.println(context.usefulMovies);
    
    movies = new ArrayList<Movie>();
    for(int qty = 0; qty < 4 ; qty ++){
        Movie m = new Movie(context, context.footage.getAbsolutePath()+"/"+ context.usefulMovies.get(qty));      
        movies.add(m);
    }
    
    movie.stop();
    movie = movies.get(0);
    movie.loop();
  }
  
  public void render(){    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }
  
  
  public void onExit(RecordarState nextState){
        
  }
  
  private void nextState(){
    
  }
  
  public void callToAction(){
    
  }
 
  
}
