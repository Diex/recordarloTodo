
import java.util.*;
public class SearchCriteria {

  public final int INTERSECTION = 1;
  
  private ArrayList<String> usefulMovies;
  private RecordarDB db;

  public SearchCriteria(String dbConnector) {
    this.db = new RecordarDB();  
    this.db.dbConnect(dbConnector);
  }

  public  void find(HashSet<String> words, int criteria) {
    switch(criteria) {
    case INTERSECTION:
      intersection(words);
    }

  }

  private void intersection(HashSet<String> words) {

    ArrayList<String> result = new ArrayList<String>();    
    HashMap<String, Integer> movieCount = new HashMap<String, Integer>();

    for (String tag : words) {
      
      ArrayList<String> matches = db.dbGetVideosForTag(tag);

      for (String movie : matches) {
        Integer count = movieCount.get(movie);          
        movieCount.put(movie, (count==null) ? 1 : count+1);
      }
    }


    Comparator c = new Comparator() {
      public int compare(Object o1, Object o2) {
        return ((Map.Entry<String, Integer>) o2).getValue()
          .compareTo(((Map.Entry<String, Integer>) o1).getValue());
      }
    };

    Object[] a = movieCount.entrySet().toArray();

    Arrays.sort(a, c);
 
    for (Object e : a) {
      String m = ((Map.Entry<String, Integer>) e).getKey();

      result.add(m);
    


      System.out.println(m + " : "
        + ((Map.Entry<String, Integer>) e).getValue());
    }

    usefulMovies = result;
    //return result;
  }
  
  ArrayList<String> usefulMovies(){
    return usefulMovies; 
  }

  public boolean hasMovies() {
    return usefulMovies.size() > 0 ? true : false;
  }

  public String[] dbGetRandomTags(int qty) {
    return db.dbGetRandomTags(qty);
  }

}
