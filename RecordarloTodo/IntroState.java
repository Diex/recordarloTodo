import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;



class IntroState extends RecordarState{
  
  Ani fadeIn,fadeOut, changeState;
  float dummy = 0.0f;
  float alpha = 0.0f;
  float movieDuration;
  
  public IntroState (RecordarloTodo context, String file){
    super(context, file);
    //Ani.init(parent);
  }

  public void onEnter(){    
    movie.loop();
    movieDuration = movie.duration();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );
    changeState = new Ani(this, movieDuration-2, "dummy", 0.0f, Ani.LINEAR, "onEnd:gotoRec");
    
  }
  
  public void render(){    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }
  
  private void gotoRec(){
    //context.println("gotoRec");
     fadeOut = new Ani(this, 1, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );                 
  }
  
  private void nextState(){
    context.currentState = context.rec;
    context.currentState.onEnter();
    movie.stop();
  }
  
  public void onExit(){
        
  }
  
  public void callToAction(){
    
    
  }
 
  
}
