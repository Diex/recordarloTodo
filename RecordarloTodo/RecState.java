import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class RecState extends RecordarState{
  
  Ani changeState;
  float dummy = 0.0f;
  
  public RecState (RecordarloTodo context, String file){
    super(context, file);
  }

  public void onEnter(){    
    context.controller.clearInput();
    movie.loop();
    changeState = new Ani(this, movie.duration(), "dummy", 0.0f, Ani.LINEAR, "onEnd:nextState");    
  }
  
  
  public void nextState(){
    movie.stop();
    context.currentState = context.process;
    context.currentState.onEnter();
  }
}
