//import de.looksgood.ani.*;
//import de.looksgood.ani.easing.*;

class IntroState extends RecordarState{
  
  //Ani changeState;
  
  float dummy = 0.0f;  

  public IntroState (RecordarloTodo context, String file){
    super(context, file);
    
  }

  public void onEnter(){    
    movie.loop();
    //changeState = new Ani(this, movie.duration() - 2, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoRec");
    new TimeoutThread(this, "gotoRec", (long) (movie.duration() - 3) * 1000,false);
  }
   
  public void gotoRec(){
    nextState();
  }
  
  private void nextState(){
    context.currentState = context.rec;
    context.currentState.onEnter();
    movie.stop();
  }
}
