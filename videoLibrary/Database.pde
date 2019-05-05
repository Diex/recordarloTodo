import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.sql.PreparedStatement;


Connection connection = null;

void dbConnect(VideoFolder vf) {

  // load the sqlite-JDBC driver using the current class loader
  try {
    Class.forName("org.sqlite.JDBC");
  }
  catch(ClassNotFoundException e) {
    e.printStackTrace();
  }


  try
  {

    // create a database connection
    connection = DriverManager.getConnection("jdbc:sqlite:"+vf.folder+File.separator+"videos.db");

    Statement statement = connection.createStatement();
    statement.setQueryTimeout(30);  // set timeout to 30 sec.
    statement.addBatch("CREATE TABLE IF NOT EXISTS videos (video_id INTEGER PRIMARY KEY, name TEXT NOT NULL);");
    statement.addBatch("CREATE TABLE IF NOT EXISTS tags (tag_id INTEGER PRIMARY KEY, tag TEXT NOT NULL);");
    statement.addBatch("CREATE TABLE IF NOT EXISTS links (link_id INTEGER PRIMARY KEY, video_id TEXT NOT NULL, tag_id TEXT NOT NULL);");
    statement.executeBatch();

    //ResultSet rs = statement.executeQuery("select * from person");
    //while(rs.next())
    //{
    //  // read the result set
    //  System.out.println("name = " + rs.getString("name"));
    //  System.out.println("id = " + rs.getInt("id"));
    //}
  }
  catch(SQLException e)
  {
    // if the error message is "out of memory", 
    // it probably means no database file is found
    System.err.println(e.getMessage());
  }
  //finally
  //{
  //  try
  //  {
  //    //if (connection != null)
  //    //  connection.close();
  //  }
  //  catch(SQLException e)
  //  {
  //    // connection close failed.
  //    System.err.println(e);
  //  }
  //}
}


void dbAddFiles(VideoFolder vf) {

  // TODO limpiar la db si el file no está lo saco de la tabla

  for (String video : vf.files) {
    dbAddVideo(video);
  }
}

int dbAddVideo(String name) {
  if (getVideoId(name) == null) {
    println("inserting: "+ name);
    insert("videos", "name", name);
  }
  return 0;
}

void addTagToVideo(String video, String tag) {

  String tagId = getTagId(tag); 
  String videoId = getVideoId(video);

  if (tagId == null) {
    println("inserting: "+ tag);
    insert("tags", "tag", tag);
    tagId = getTagId(tag);
  }

  String linkExists = getLinkId(videoId, tagId);

  if (linkExists == null) {
    insertLink(videoId, tagId);
  }
}

public void insertLink(String videoId, String tagId) {
  String sql = "INSERT INTO links (video_id, tag_id) VALUES(?,?)";
  try { 
    PreparedStatement pstmt = connection.prepareStatement(sql);
    pstmt.setString(1, videoId);
    pstmt.setString(2, tagId);
    pstmt.executeUpdate();
    println("inserting: "+videoId+" -> "+tagId);
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
}

public String getLinkId(String video_id, String tag_id) {

  String sql = "SELECT link_id FROM links WHERE video_id = ?"+ 
    "AND tag_id LIKE ?";

  String link_id = null;

  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);
    pstmt.setString(1, video_id);    
    pstmt.setString(2, tag_id);
    ResultSet rs  = pstmt.executeQuery();

    while (rs.next()) {      
      link_id = rs.getString("link_id");
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }

  return link_id;
}


public String getTagId(String tag) {

  String sql = "SELECT * "
    + "FROM tags WHERE tag LIKE ?";
  String tag_id = null;
  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);
    pstmt.setString(1, tag);

    ResultSet rs  = pstmt.executeQuery();
    while (rs.next()) {
      tag_id = rs.getString("tag_id");
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }

  return tag_id;
}

public String getVideoId(String name) {

  String sql = "SELECT * "
    + "FROM videos WHERE name = ?";
    
  String video_id = null;
  
  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);
    pstmt.setString(1, name);
    ResultSet rs  = pstmt.executeQuery();
    while (rs.next()) {
      println(rs.getString("video_id"));
      video_id = rs.getString("video_id");
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }

  return video_id;
}


public void insert(String table, String field, String value) {
  String sql = "INSERT INTO "+table+"("+field+") VALUES(?)";
  try { //(Connection conn = this.connect();
    PreparedStatement pstmt = connection.prepareStatement(sql);
    pstmt.setString(1, value);
    pstmt.executeUpdate();
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
}

public ArrayList<String> dbGetTagsIdForVideo(String moviePath) {
 
  ArrayList<String> tags = new ArrayList<String>();  
  String videoId = getVideoId(moviePath);
  String sql = "SELECT * "
    + "FROM links WHERE video_id = ?";

  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);
    pstmt.setString(1, videoId);    
    ResultSet rs  = pstmt.executeQuery();

    while (rs.next()) {
      String tagId = rs.getString("tag_id");
      println(tagId);
      tags.add(tagId);      
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
  
  
  return tags;
}

public String dbGetTag(String tagId){
  
  String tag = null;
  
   String sql = "SELECT * "
    + "FROM tags WHERE tag_id = ?";

  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);
    pstmt.setString(1, tagId);    
    ResultSet rs  = pstmt.executeQuery();

    while (rs.next()) {
      
      tag = rs.getString("tag");      
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
  return tag;
}
