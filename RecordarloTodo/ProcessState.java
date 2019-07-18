import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;
import java.util.HashSet;
class ProcessState extends RecordarState {

  Ani fadeIn, fadeOut, timeOut;
  float alpha = 0.0f;
  float dummy = 0.0f;

  public ProcessState (RecordarloTodo context, String file) {
    super(context, file);
  }

  public void onEnter() {    
    movie.loop();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );    
    HashSet<String> words = context.controller.getWords();

    ArrayList<String> usefulMovies = context.search.find(words, context.search.INTERSECTION);
    context.usefulMovies = usefulMovies;
    
    timeOut = new Ani(this, 2.f, "dummy", 0.f, Ani.LINEAR, "onEnd:gotoMemory");
    
  }

  public void render() {    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }

  public void onExit(RecordarState nextState) {
    
     
  }

  private void gotoMemory() {
    fadeOut = new Ani(this, 1, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );
  }
  
  public void nextState(){
    this.movie.stop();   
    context.currentState = context.memory;    
    context.currentState.onEnter();

  }

  public void callToAction() {
    
  }
}
