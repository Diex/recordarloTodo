import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class IntroState extends RecordarState{
  
  Ani changeState;
  float dummy = 0.0f;  

  public IntroState (RecordarloTodo context, String file){
    super(context, file);
  }

  public void onEnter(){    
    movie.loop();

    changeState = new Ani(this, movie.duration() - 2, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoRec");    
  }
   
  private void gotoRec(){
    nextState();
     //fadeOut = new Ani(this, fadeOutTime, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );                 
  }
  
  private void nextState(){
    context.currentState = context.rec;
    context.currentState.onEnter();
    movie.stop();
  }
}
