import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;



class IdleState extends RecordarState{
  
  
  public IdleState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();
    fadeIn = new Ani(this, 0.0f, "alpha", 1.0f );      
  }
  
  
  
  
  public void onExit(){
    this.nextState = nextState; 
    fadeOut = new Ani(this, 1, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );    
  }
  
  private void nextState(){
    context.currentState = context.intro;
    context.currentState.onEnter();
    movie.stop();
  }
  
  public void callToAction(){
      onExit();          
  }
 
  
}
