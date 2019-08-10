
import java.util.*;
public class SearchCriteria {

  public final int INTERSECTION = 1;

  //private ArrayList<String> matches;
  //private ArrayList<String> usefulMovies;

  private HashMap<String, Float> playlist;

  private RecordarDB db;


  private float recurrence = 1.0f;
  private float repetition = -1.0f;


  public SearchCriteria(String dbConnector) {
    this.db = new RecordarDB();  
    this.db.dbConnect(dbConnector);
  }

  public  void find(HashSet<String> words, int criteria) {    
    playlist = new HashMap<String, Float>();    

    recurrence(words, playlist); 

    //switch(criteria) {
    //case INTERSECTION:
    //  playlist = intersection(matches);
    //}
  }


  // busca las tags y suma puntos por repeticion
  private void recurrence(HashSet<String> words, HashMap<String, Float> playlist) {            
    System.out.println("recurrence:");
    for (String tag : words) {
      ArrayList<String> matches = db.dbGetVideosForTag(tag);
      for (String movie : matches) {
        Float score = playlist.get(movie);          
        playlist.put(movie, (score == null) ? recurrence : score+recurrence);        
      }
    }
    
    Object[] a = playlist.entrySet().toArray();
    for (Object e : a) {
      String m = ((Map.Entry<String, Integer>) e).getKey();
      //result.add(m);
      System.out.println(m + " : "
        + ((Map.Entry<String, Integer>) e).getValue());
    }
    //Serial.out.println("recurrence:");
  }


  //private HashMap<String, Float> intersection(ArrayList<String> matches) {
  //}


  //private ArrayList<String> intersection(ArrayList<String> matches) {

  //  ArrayList<String> intersection = new ArrayList<String>();    
  //  HashMap<String, Integer> movieCount = new HashMap<String, Integer>();

  //  for (String movie : matches) {
  //    Integer count = movieCount.get(movie);          
  //    movieCount.put(movie, (count==null) ? 1 : count+1);
  //  }

  //  Comparator c = new Comparator() {
  //    public int compare(Object o1, Object o2) {
  //      return ((Map.Entry<String, Integer>) o2).getValue()
  //        .compareTo(((Map.Entry<String, Integer>) o1).getValue());
  //    }
  //  };

  //  Object[] a = movieCount.entrySet().toArray();
  //  Arrays.sort(a, c);

  //  for (Object e : a) {
  //    String m = ((Map.Entry<String, Integer>) e).getKey();
  //    result.add(m);
  //    System.out.println(m + " : "
  //      + ((Map.Entry<String, Integer>) e).getValue());
  //  }

  //  return intersection;
  //}

  ArrayList<String> usefulMovies() {
    ArrayList<String> usefulMovies = new ArrayList<String>();
    usefulMovies.addAll(playlist.keySet());
    return usefulMovies;
  }

  public boolean hasMovies() {
    return playlist.size() > 0 ? true : false;
  }

  public String[] dbGetRandomTags(int qty) {
    return db.dbGetRandomTags(qty);
  }
}
