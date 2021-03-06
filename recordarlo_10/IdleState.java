import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;



class IdleState extends RecordarState{
  
  Ani fadeIn,fadeOut;
  float alpha = 1.0f;
  
  public IdleState (recordarlo_10 context, String file){
    super(context, file);
    Ani.init(parent);
  }

  public void onEnter(){    
    movie.loop();
    fadeIn = new Ani(this, 5, "alpha", 1.0f );      
  }
  
  public void render(){    
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) {
      parent.tint(255, alpha * 255);
      parent.image(movie, x, y, movie.width, movie.height);
    }
  }
  
  
  public void onExit(){
    fadeOut = new Ani(this, 5, "alpha", 0.0f );    
  }
  
  public void callToAction(){
    //((clazz)context).switch
    
  }
 
  
}
