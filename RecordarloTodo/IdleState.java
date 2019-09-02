//import de.looksgood.ani.*;
//import de.looksgood.ani.easing.*;

class IdleState extends RecordarState{

  float dummy = 0.0f;  
  boolean enable = false;
  
  public IdleState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();
    enable = false;
     new TimeoutThread(this, "setEnable", (long) RecordarloTodo.enableTime * 1000,false);
  }
  
  public void setEnable(){
    enable = true;
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
