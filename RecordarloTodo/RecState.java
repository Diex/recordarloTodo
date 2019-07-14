import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;



class RecState extends RecordarState{
  
  Ani fadeIn,fadeOut, changeState;
  float dummy = 0.0f;
  float alpha = 0.0f;
  float movieDuration;
  
  public RecState (RecordarloTodo context, String file){
    super(context, file);
    //Ani.init(parent);
  }

  public void onEnter(){    
    //System.out.println("enter recState");
    context.controller.clearInput();
    movie.loop();
    movieDuration = movie.duration();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );
    //ENGANA PICHANGA movieDuration-2
    changeState = new Ani(this, 10, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoProcess");
    
  }
  
  public void render(){    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }
  
  private void gotoProcess(){
     fadeOut = new Ani(this, 1, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );                 
  }
  
  private void nextState(){
    context.currentState = context.process;
    context.currentState.onEnter();
    movie.stop();
  }
  
  public void onExit(){
        
  }
  
  public void callToAction(){
    
    
  }
 
  
}
