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
    //movieDuration = movie.duration();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );
    changeState = new Ani(this, 10, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoProcess");
    
  }
  
  private void gotoProcess(){
     fadeOut = new Ani(this, fadeOutTime, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );                 
  }
  
  private void nextState(){
    context.currentState = context.process;
    context.currentState.onEnter();
    movie.stop();
  }
}
