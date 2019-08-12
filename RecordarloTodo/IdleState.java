import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class IdleState extends RecordarState{
  
  public IdleState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();    
  }
  
  public void onExit(){
    nextState();
  }
  
  private void nextState(){
    context.currentState = context.intro;
    context.currentState.onEnter();
    movie.stop();
  }
}
