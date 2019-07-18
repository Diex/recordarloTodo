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
  int MAX_MOVIES = 5;
  
  ArrayList<Movie> movies;
  Movie trash;
  
  public MemoryState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    //trash = movie;
    movie.loop();    
    loadMovies();    
    fadeIn = new Ani(this, 1, "alpha", 1.0f );
    timeOut = new Ani(this, 40, "dummy", 1.0f, Ani.LINEAR, "onEnd:nextState");  
  }
  
  private void loadMovies(){
  
    if(context.usefulMovies.size() < 1) return;  /// no hay peliculas    
    movies = new ArrayList<Movie>();
    
    for(int qty = 0; qty < (MAX_MOVIES < context.usefulMovies.size() ? MAX_MOVIES : context.usefulMovies.size()); qty ++){
        Movie m = new Movie(context, context.footage.getAbsolutePath()+"/"+ context.usefulMovies.get(qty));      
        movies.add(m);
        context.println("loading: " + context.footage.getAbsolutePath()+"/"+ context.usefulMovies.get(qty));
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
    
    if(lastFrame(movie)) nextMovie();
  }
  
  private boolean lastFrame(Movie movie){    
    int lastFrame = context.floor(movie.duration() * 25.f);
    int currentFrame = context.floor(movie.time()*25.f);    
    return currentFrame + 5 >= lastFrame;
  }
  
  private void nextMovie(){
    if(movies == null) return;    
    int current = movies.indexOf(movie);
    movie.stop();
    movie = movies.get((current+1) % movies.size());
    movie.loop();
  }
  
  public void onExit(){
        
  }
  
  private void nextState(){
    context.currentState = context.idle;
    context.currentState.onEnter();    
    while(movies.size() > 0) {
      Movie m = movies.remove(0);
      m.stop();
      m = null;
    }
    
    movies = null;
    movie.stop();
    
  }
  
  public void callToAction(){
    
  }
 
  
}
