
import java.util.*;
import processing.core.*;
import processing.data.*;
public class SearchCriteria {



  private HashMap<String, Float> playlist;
  private HashMap<String, String> replacements;

  private ArrayList<String> usefulMovies;
  private RecordarDB db;

  private float recurrence = 1.0f;
  private float repetition = 0.1f;


  public SearchCriteria(String dbConnector) {
    this.db = new RecordarDB();  
    this.db.dbConnect(dbConnector);
    loadSynonyms();
  }

  private void loadSynonyms() {
    replacements = new HashMap<String, String>();

    JSONArray syns = RecordarloTodo.synonyms.getJSONArray("synonyms");

    for (int i = 0; i < syns.size(); i ++) { 
      JSONObject replacements = syns.getJSONObject(i);      
      JSONArray words = replacements.getJSONArray("words");      
      String tag = replacements.getString("tag");
      for (int word = 0; word < words.size(); word++) {
        if(RecordarloTodo.debug) System.out.println(words.getString(word) + " : " + tag);
        this.replacements.put(words.getString(word), tag);
      }
    }
  }

  public  void find(HashSet<String> words) {    

    System.out.println("find:"+words);

    playlist = new HashMap<String, Float>();    

    HashSet<String> replacements = getReplacementsForWords(words);
    System.out.println("replacement:"+ replacements);    
    recurrence(replacements, playlist);
    usefulMovies = scoringSort();
  }




  HashSet<String> getReplacementsForWords(HashSet<String> words) {
    HashSet<String> result = new HashSet<String>();   
    for (String w : words) {          
      String replacementWord = replacements.get(w);
      if (replacementWord != null) {
        result.add(replacementWord);
      } else {
        result.add(w);
      }
    }
    return result;
  }


  // busca las tags y suma puntos por repeticion
  private void recurrence(HashSet<String> words, HashMap<String, Float> playlist) {            
    if (RecordarloTodo.debug) System.out.println(this.toString()+": recurrence()");
    for (String tag : words) {
      if (RecordarloTodo.debug) System.out.println("for tag:" + tag);
      ArrayList<String> matches = db.dbGetVideosForTag(tag);
      if (RecordarloTodo.debug) System.out.println("matches:" + matches);
      for (String movie : matches) {                
        Float score = playlist.get(movie);          
        playlist.put(movie, (score == null) ? recurrence : score+recurrence);
      }
    }
    if(RecordarloTodo.debug) System.out.println(this.toString()+": playlist.size(): "+playlist.size());
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
