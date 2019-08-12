import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import java.util.*;
import java.util.HashSet;
class ProcessState extends RecordarState {

  Ani timeOut;
  float dummy = 0.0f;

  public ProcessState (RecordarloTodo context, String file) {
    super(context, file);
  }

  public void onEnter() {    
    movie.loop();
    fadeIn = new Ani(this, fadeInTime, "alpha", 1.0f );        
    // dispara la busqueda en la db....
    context.search.find(context.controller.getWords());
    // y le doy tiempo    ...

    timeOut = new Ani(this, 4.f, "dummy", 0.f, Ani.LINEAR, "onEnd:gotoMemory");
  }

  private void gotoMemory() {
    fadeOut = new Ani(this, fadeOutTime, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );
  }
  
  public void nextState(){
    movie.stop();   
    context.currentState = context.memory;    
    context.currentState.onEnter();
  }
}
