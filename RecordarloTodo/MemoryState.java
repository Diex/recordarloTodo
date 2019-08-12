import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.ArrayList;
import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;

class MemoryState extends RecordarState {
  Ani timeOut;
  float dummy = 0;
  
  Movie trash;
    
  float sessionTime = 40; // secs  
  int MAX_MOVIES = 10;
  private ArrayList<Movie> movies;
  boolean ready = false;  

  public MemoryState (RecordarloTodo context, String file) {
    super(context, file);
    trash = movie;
  }

  public void onEnter() {          
    System.out.println(this+":onEnter");
    ready = false;
    movies = new ArrayList<Movie>();
    alpha = 1.0f;
    loadMovies(context.search);    
    timeOut = new Ani(this, sessionTime, "dummy", 1.0f, Ani.LINEAR, "onEnd:nextState");
  }

  private void loadMovies(SearchCriteria search) {  
    System.out.println("loadMovies()");    
    if (!search.hasMovies()) {
      System.out.println("search.hasMovies() == false");
      movie = trash;
      return;
    }

    ArrayList<String> um = search.usefulMovies();     
    int maxMovies = um.size() > MAX_MOVIES ? MAX_MOVIES : um.size(); 
    
    for (int qty = 0; qty < maxMovies; qty ++) {
      String movieFile = context.footage.getAbsolutePath()+"/"+ um.get(qty);
      context.println("loading: " + movieFile);
      
      try{
        Movie m = new Movie((PApplet) context, movieFile);
        movies.add(m);
      }catch (Exception e){
        e.printStackTrace();
      }
    }    
    
    movie.stop();
    movie = movies.get(0);
    ready = true;
  }

  public void render() {    
    if(!ready) return;
    super.render();    
    if (lastFrame(movie)) nextMovie();
  }

  private boolean lastFrame(Movie movie) {    
    int lastFrame = context.floor(movie.duration() * 25.f);
    int currentFrame = context.floor(movie.time()*25.f);    
    return currentFrame + 5 >= lastFrame;
  }

  private void nextMovie() {
    if (movies == null) return;    
    int current = movies.indexOf(movie);
    movie.stop();
    System.out.println("playing "+current+ " of "+ movies.size());
    movie = movies.get((current+1) % movies.size());
    movie.loop();
  }

  public void nextState() {
    clearMovies();
    context.currentState = context.idle;
    context.currentState.onEnter();
    movie = trash;
  }

  private void clearMovies() {
    while (movies.size() > 0) {
      Movie m = movies.remove(0);
      m.stop();
      m = null;
    }    
    movies = null;
    movie.stop();
  }
}
