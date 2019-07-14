import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;



class IdleState extends RecordarState{
  
  Ani fadeIn,fadeOut;
  float alpha = 0.0f;
  
  
  public IdleState (RecordarloTodo context, String file){
    super(context, file);    
  }

  public void onEnter(){    
    movie.loop();
    fadeIn = new Ani(this, 1, "alpha", 1.0f );      
  }
  
  public void render(){    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }
  
  
  public void onExit(RecordarState nextState){
    this.nextState = nextState; 
    fadeOut = new Ani(this, 1, "alpha", 0.0f, Ani.LINEAR, "onEnd:nextState" );    
  }
  
  private void nextState(){
    context.currentState = nextState;
    context.currentState.onEnter();
    movie.stop();
  }
  
  public void callToAction(){
    if(context.isSomeone){
      context.switchState(context.intro);      
    }
    
  }
 
  
}
