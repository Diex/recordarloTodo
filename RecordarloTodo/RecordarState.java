import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;
import processing.core.*;

public class RecordarState {

  Class clazz;
  recordarlo_10 context;
  Movie movie;
  PApplet parent;

  public RecordarState(recordarlo_10 context, String file) {
    parent = (PApplet) context;
    System.out.println(context.getClass());
    movie = new Movie(parent, file);
    clazz = context.getClass();
    this.context = context;
  }

  public void onEnter() {
  }


  public void onExit() {
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
  
