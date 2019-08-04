import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.ArrayList;
import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;

class MemoryState extends RecordarState{
  
  Ani timeOut;
  float dummy = 0;
  float sessionTime = 10; // secs  
  int MAX_MOVIES = 5;  
  ArrayList<Movie> movies;
  boolean noMovies = false;
  
  
  public MemoryState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){      
    noMovies = false;
    loadMovies();
    movie.loop();    
    fadeIn = new Ani(this, fadeInTime, "alpha", 1.0f );
    timeOut = new Ani(this, sessionTime, "dummy", 1.0f, Ani.LINEAR, "onEnd:nextState");  
  }
  
  private void loadMovies(){  
    movies = new ArrayList<Movie>();    
    if(context.usefulMovies.size() < 1) {
      noMovies = true;
      return;  /// no hay peliculas
    }
    
    for(int qty = 0; qty < (MAX_MOVIES < context.usefulMovies.size() ? MAX_MOVIES : context.usefulMovies.size()); qty ++){
        Movie m = new Movie(context, context.footage.getAbsolutePath()+"/"+ context.usefulMovies.get(qty));      
        movies.add(m);
        context.println("loading: " + context.footage.getAbsolutePath()+"/"+ context.usefulMovies.get(qty));
    }    
    movie.stop();
    movie = movies.get(0);
  }
  
  public void render(){    
    super.render();    
    if(!noMovies && lastFrame(movie)) nextMovie();
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
  public void nextState(){
    clearMovies();
    context.currentState = context.idle;
    context.currentState.onEnter();    
  }
  
  private void clearMovies(){
    while(movies.size() > 0) {
      Movie m = movies.remove(0);
      m.stop();
      m = null;
    }    
    movies = null;
    movie.stop();
  }
}
