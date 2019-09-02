
import java.lang.reflect.Method;
 
class TimeoutThread extends Thread{
  Method callback;
  long now,timeout;
  Object parent;
  boolean running;
  boolean loop;
 
  public TimeoutThread(Object parent,String callbackName,long time,boolean repeat){
    this.parent = parent; 
    try{
      callback = parent.getClass().getMethod(callbackName);
    }catch(Exception e){
      e.printStackTrace();
    }
    
    if(callback != null){
      timeout = time;
      now = System.currentTimeMillis();
      running = true;  
      loop = repeat; 
      new Thread(this).start();
    }
  }
 
  public void run(){
    while(running){
      if(System.currentTimeMillis() - now >= timeout){
        try{
          callback.invoke(parent);
        }catch(Exception e){
          e.printStackTrace();
        }
        if(loop){
          now = System.currentTimeMillis();
        }else running = false;
      }
    }
  }
  void kill(){
    running = false;
  }
 
}
