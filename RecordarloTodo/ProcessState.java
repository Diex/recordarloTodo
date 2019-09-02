//import de.looksgood.ani.*;
//import de.looksgood.ani.easing.*;

import java.util.*;
import java.util.HashSet;
class ProcessState extends RecordarState {

  //Ani timeOut;
  float dummy = 0.0f;

  public ProcessState (RecordarloTodo context, String file) {
    super(context, file);
  }

  public void onEnter() {    
    movie.loop();    
    HashSet<String> words = context.controller.getWords();       
    context.search.find(words);

    // y le doy tiempo    ...
    //timeOut = new Ani(this, 4.f, "dummy", 0.f, Ani.LINEAR, "onEnd:gotoMemory");
    new TimeoutThread(this, "gotoMemory", (long) 4 * 1000,false);
  }

  public void gotoMemory() {
    nextState();
  }

  public void nextState() {
    movie.stop();   
    context.currentState = context.memory;    
    context.currentState.onEnter();
  }
}
