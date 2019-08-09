
import java.util.*;
public class SearchCriteria {

  ArrayList<String> session = new ArrayList<String>();
  public ArrayList<String> usefulMovies;
  
  public final int INTERSECTION = 1;
  
  private static SearchCriteria instance = null;
  RecordarDB db;
  
  private public SearchCriteria(RecordarDB db){
    this.db = db;  
  }
  
  public static SearchCriteria getInstance(RecordarDB db){
    if(instance == null){
      instance = new SearchCriteria(db);
    }
    
    return instance;
  }

  public class Element {
    String movie;
    int apparences;
  }

  public  ArrayList<String> find(HashSet<String> words, int criteria) {
    switch(criteria) {
    case INTERSECTION:
      return intersection(words);
    }

    return null;
  }

  private ArrayList<String> intersection(HashSet<String> words) {
    
    ArrayList<String> result = new ArrayList<String>();    
    HashMap<String, Integer> movieCount = new HashMap<String, Integer>();
    
    for (String tag : words) {
      ArrayList<String> matches = dbGetVideosForTag(tag);
      
    
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
    
        Comparator rand = new Comparator() {
      public int compare(Object o1, Object o2) {
        
        return Math.random() < 0.5 ? -1 : 1;
        //((Map.Entry<String, Integer>) o2).getValue()
        //  .compareTo(((Map.Entry<String, Integer>) o1).getValue());
      }
    };
    
    Object[] a = movieCount.entrySet().toArray();
    
    //Arrays.sort(a, c);
    Arrays.sort(a,rand);
    for (Object e : a) {
      String m = ((Map.Entry<String, Integer>) e).getKey();
      
      //if(session.indexOf(m) == -1) {
        result.add(m);
        //session.add(m);
      //}
      
      
      
      System.out.println(m + " : "
        + ((Map.Entry<String, Integer>) e).getValue());
      
    }

    return result;
  }
}
