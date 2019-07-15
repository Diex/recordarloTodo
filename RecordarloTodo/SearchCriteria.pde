import java.util.HashSet;
import java.util.Map;
import java.util.List;
import java.util.LinkedList;
import java.util.Collections;
import java.util.Map.Entry;
import java.util.Arrays;
import java.util.Comparator;
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
    
    Object[] a = movieCount.entrySet().toArray();
    Arrays.sort(a, c);
    
    for (Object e : a) {
      String m = ((Map.Entry<String, Integer>) e).getKey();
      System.out.println(m + " : "
        + ((Map.Entry<String, Integer>) e).getValue());
         result.add(m);
    }


    //List<String> sorted = new ArrayList<String>(movieCount.values());    
    //for (String movie : sorted) {
    //  println(movie, movieCount.get(movie));
    //  result.add(movie);
    //}

    //for(String movie : movieCount.keySet()){
    //   println(movie, movieCount.get(movie));
    //   result.add(movie);
    //}

    return result;
  }

  //private HashMap<String, Integer> sortByComparator(HashMap<String, Integer> unsortMap, final boolean order)
  //    {

  //        List<Entry<String, Integer>> list = new LinkedList<Entry<String, Integer>>(unsortMap.entrySet());

  //        // Sorting the list based on values
  //        Collections.sort(list, new Comparator<Entry<String, Integer>>()
  //        {
  //            public int compare(Entry<String, Integer> o1,
  //                    Entry<String, Integer> o2)
  //            {
  //                if (order)
  //                {
  //                    return o1.getValue().compareTo(o2.getValue());
  //                }
  //                else
  //                {
  //                    return o2.getValue().compareTo(o1.getValue());

  //                }
  //            }
  //        });

  //        // Maintaining insertion order with the help of LinkedList
  //        Map<String, Integer> sortedMap = new LinkedHashMap<String, Integer>();
  //        for (Entry<String, Integer> entry : list)
  //        {
  //            sortedMap.put(entry.getKey(), entry.getValue());
  //        }

  //        return sortedMap;
  //    }
  //}
}
