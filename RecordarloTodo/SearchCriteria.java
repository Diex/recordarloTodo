
import java.util.*;
public class SearchCriteria {

  

  private HashMap<String, Float> playlist;

  private ArrayList<String> usefulMovies;
  private RecordarDB db;

  private float recurrence = 1.0f;
  private float repetition = 0.1f;
  

  public SearchCriteria(String dbConnector) {
    this.db = new RecordarDB();  
    this.db.dbConnect(dbConnector);
    
  }

  public  void find(HashSet<String> words) {    
    playlist = new HashMap<String, Float>();    
    recurrence(words, playlist);
    usefulMovies = scoringSort();
  }


  // busca las tags y suma puntos por repeticion
  private void recurrence(HashSet<String> words, HashMap<String, Float> playlist) {            
    if (RecordarloTodo.debug) System.out.println(this.toString()+": recurrence()");
    for (String tag : words) {
      ArrayList<String> matches = db.dbGetVideosForTag(tag);
      for (String movie : matches) {                
        Float score = playlist.get(movie);          
        playlist.put(movie, (score == null) ? recurrence : score+recurrence);
      }
    }
    
    System.out.println(this.toString()+": playlist.size(): "+playlist.size());
  }




  private ArrayList<String> scoringSort() {    
    if (RecordarloTodo.debug) System.out.println(this.toString()+": scoringSort()");    
    Comparator c = new Comparator() {
      public int compare(Object o1, Object o2) {
        return ((Map.Entry<String, Float>) o2).getValue()
          .compareTo(((Map.Entry<String, Float>) o1).getValue());
      }
    };

      
    Object[] a = playlist.entrySet().toArray();    
    if (RecordarloTodo.debug) System.out.println(a.length);
    
    Collections.shuffle(Arrays.asList(a));
    Arrays.sort(a, c);

    ArrayList<String> result = new ArrayList<String>();    

    for (Object e : a) {
      String m = ((Map.Entry<String, Float>) e).getKey();
      result.add(m);
      if (RecordarloTodo.debug) System.out.println(m);
    }

    return result;
  }

  ArrayList<String> usefulMovies() { 
    if (RecordarloTodo.debug) System.out.println("usefulMovies()");
    return usefulMovies;
  }

  public boolean hasMovies() {
    return playlist.size() > 0 ? true : false;
  }

  public String[] dbGetRandomTags(int qty) {
    return db.dbGetRandomTags(qty);
  }
}
