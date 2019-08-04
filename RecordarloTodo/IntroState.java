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
    fadeIn = new Ani(this, fadeInTime, "alpha", 1.0f );
    
    float movieDuration = movie.duration();    
    changeState = new Ani(this, movieDuration-2, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoRec");    
  }
   
  private void gotoRec(){
     fadeOut = new Ani(this, fadeOutTime, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );                 
  }
  
  private void nextState(){
    context.currentState = context.rec;
    context.currentState.onEnter();
    movie.stop();
  }
}
