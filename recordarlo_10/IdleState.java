

class IdleState extends RecordarState{
  
  public IdleState (Object context, String file){
    super(context, file);
  }

  public void onEnter(){
    movie.loop();
  }
  public void render(){
  
    int x = (parent.width-movie.width)/2;
    int y = (parent.height-movie.height)/2;
    if ( movie.width > 0) parent.image(movie, x, y, movie.width, movie.height);
  }
  
  
  
}
