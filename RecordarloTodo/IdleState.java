import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class IdleState extends RecordarState{
  Ani changeState;
  float dummy = 0.0f;  
  boolean enable = false;
  
  public IdleState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();
    enable = false;
    changeState = new Ani(this, RecordarloTodo.enableTime , "dummy", 0.0f, Ani.LINEAR, "onEnd:enableIntro");
  }
  
  public void enableIntro(){
    enable = true;
    if(RecordarloTodo.debug) System.out.println("enable: " + enable);
  }
  public void onExit(){
    if(enable) nextState();
  }
  
  private void nextState(){
    context.currentState = context.intro;
    context.currentState.onEnter();
    movie.stop();
  }
}
