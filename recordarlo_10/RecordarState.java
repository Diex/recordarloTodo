import processing.video.*;
import processing.core.*;
import java.lang.reflect.*;

public class RecordarState extends Movie{

  Class<?> clazz;
  Object something;
    
    
  public RecordarState(Object parent, String file){
    super((PApplet) parent, file);
     clazz = parent.getClass();
     //c = parent.getClass();
     something = parent;
  }

  public void onEnter(){
    this.jump(0.0f);
    this.loop();
  }
  
  
  public void onExit(){
    this.stop();
  }
  
  public void update(){
    //if(time() >= duration()){
      
      //Class c = parent.getClass();
      
      try {                
        // Call method from obj
          Method method = clazz.getMethod("myMethod", "".getClass());
        method.invoke(something, "blabla");
    
         //c.getMethod("myMethod").invoke(something, ""+(duration()-time()));
      } catch(Exception e) {
         e.printStackTrace();         
      }
 
      //parent.method("println", ); // Java only!
    }
  
  //}
  
  
}
