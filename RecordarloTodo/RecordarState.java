import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;

public class RecordarState {

  Class clazz;
  RecordarloTodo context;
  Movie movie;
  PApplet parent;
  RecordarState nextState;
  
  public RecordarState(RecordarloTodo context, String file) {
    parent = (PApplet) context;
    
    movie = new Movie(parent, file);
    clazz = context.getClass();
    this.context = context;
  }

  public void onEnter() {
    
  }


  public void onExit(RecordarState nextState) {
  }

  public void callToAction(){
  }
  
  public void update() {
  }

  public void render() {
  }
  
  
}



    // reflection
    //try {                
    //  // Call method from obj
    //  Method method = clazz.getMethod("myMethod", "".getClass());
    //  method.invoke(something, "blabla");  
    //   //c.getMethod("myMethod").invoke(something, ""+(duration()-time()));
    //} catch(Exception e) {
    //   e.printStackTrace();         
    //}
  
