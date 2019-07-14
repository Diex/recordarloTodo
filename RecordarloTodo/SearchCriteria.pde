import java.util.HashSet;
import java.util.Map;
class SearchCriteria {

  public final int INTERSECTION = 1;

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

    Map<String, Integer> movieCount = new HashMap<String, Integer>();


    for (String tag : words) {
      ArrayList<String> matches = dbGetVideosForTag(tag);
      for (String movie : matches) {
        Integer count = movieCount.get(movie);          
        movieCount.put(movie, (count==null) ? 1 : count+1);
      }
    }
    
    for(Integer appeareances : movieCount.values()){
       //println(movieCount.
    }
    
    return result;
  }
}
