import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.sql.PreparedStatement;
import java.util.*;

import processing.core.*;
class RecordarDB {

  Connection connection = null;

  ArrayList<String> tags; //cache 


  //void dbConnect(VideoFolder vf) {
  void dbConnect(String db) {
    try {
      Class.forName("org.sqlite.JDBC");
    }
    catch(ClassNotFoundException e) {
      e.printStackTrace();
    }

    try
    {
      //connection = DriverManager.getConnection("jdbc:sqlite:"+vf.folder+File.separator+"videos.db");
      connection = DriverManager.getConnection(db);
    }
    catch(SQLException e)
    {
      // if the error message is "out of memory", 
      // it probably means no database file is found
      // TODO ERRORS
      //errors.println(e.getMessage());
      System.err.println(e.getMessage());
      System.exit(1111);
    }

    System.out.println("db connected !!!");
  }




  //void dbAddFiles(VideoFolder vf) {
  //  for (String video : vf.files) {
  //    dbAddVideo(video);
  //  }
  //}

  //int dbAddVideo(String name) {
  //  if (dbGetVideoId(name) == null) {
  //    insert("videos", "name", name);
  //  }
  //  return 0;
  //}

  //void dbAddTagToVideo(String video, String tag) {

  //  String tagId = dbGetTagId(tag); 
  //  String videoId = dbGetVideoId(video);

  //  if (tagId == null) {
  //    println("inserting tag: "+ tag);
  //    insert("tags", "tag", tag);
  //    tagId = dbGetTagId(tag);
  //  }

  //  String linkExists = dbGetLinkId(videoId, tagId);

  //  if (linkExists == null) {
  //    dbInsertLink(videoId, tagId);
  //  }
  //}



  //public void dbInsertLink(String videoId, String tagId) {
  //  String sql = "INSERT INTO links (video_id, tag_id) VALUES(?,?)";
  //  try { 
  //    PreparedStatement pstmt = connection.prepareStatement(sql);
  //    pstmt.setString(1, videoId);
  //    pstmt.setString(2, tagId);
  //    pstmt.executeUpdate();
  //    println("inserting link: "+videoId+" -> "+tagId);
  //  } 
  //  catch (SQLException e) {
  //    System.out.println(e.getMessage());
  //  }
  //}

  //public void insert(String table, String field, String value) {
  //  String sql = "INSERT INTO "+table+"("+field+") VALUES(?)";
  //  try { 
  //    PreparedStatement pstmt = connection.prepareStatement(sql);
  //    pstmt.setString(1, value);
  //    pstmt.executeUpdate();
  //    println("inserting: "+field+":"+value+" in table " +table);
  //  } 
  //  catch (SQLException e) {
  //    System.out.println(e.getMessage());
  //  }
  //}



  public String dbGetLinkId(String video_id, String tag_id) {

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


  public String dbGetTagId(String tag) {

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

  public String dbGetVideoId(String name) {

    String sql = "SELECT * "
      + "FROM videos WHERE name = ?";

    String video_id = null;

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, name);
      ResultSet rs  = pstmt.executeQuery();
      while (rs.next()) {      
        video_id = rs.getString("video_id");
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }

    return video_id;
  }




  public ArrayList<String> dbGetTagsIdForVideo(String moviePath) {

    ArrayList<String> tags = new ArrayList<String>();  
    String videoId = dbGetVideoId(moviePath);
    String sql = "SELECT * "
      + "FROM links WHERE video_id = ?";

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, videoId);    
      ResultSet rs  = pstmt.executeQuery();

      while (rs.next()) {
        String tagId = rs.getString("tag_id");
        tags.add(tagId);
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }


    return tags;
  }


  public ArrayList<String> dbGetTags(String value) {

    ArrayList<String> tags = new ArrayList<String>();

    if (value == null || value == "") {
      value = "%";
    } else {
      value += "%";
    }
    String sql = "SELECT * FROM tags WHERE tag LIKE ? ORDER BY tag ASC";
    ; 
    try {
      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, value);    
      ResultSet rs  = pstmt.executeQuery();

      while (rs.next()) {      
        tags.add(rs.getString("tag"));
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }
    return tags;
  }


  public String dbGetTag(String tagId) {

    String tag = null;

    String sql = "SELECT * "
      + "FROM tags WHERE tag_id = ?";

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, tagId);    
      ResultSet rs  = pstmt.executeQuery();

      while (rs.next()) {
        tag = rs.getString("tag");
        System.out.println(tag);
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }
    return tag;
  }

  public ArrayList<String> dbGetVideosForTag(String tag) {
    ArrayList<String> videos = new ArrayList<String>();  
    String tagId = dbGetTagId(tag);

    String sql = "SELECT * "
      + "FROM links WHERE tag_id = ?";

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, tagId);    
      ResultSet rs  = pstmt.executeQuery();

      while (rs.next()) {      
        videos.add(dbGetVideo(rs.getString("video_id")));
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }
    return videos;
  }


  public String[] dbGetRandomTags(int qty) {  
    if (tags == null) getTags();
    String[] result = new String[qty];  
    for (int i = 0; i < qty; i++) {
      result[i] = tags.get((int) (Math.random() * tags.size()));
    }

    return result;
  }

  void getTags() {

    tags = new ArrayList<String>();  
    String sql = "SELECT * FROM tags";

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);    
      ResultSet rs  = pstmt.executeQuery();
      while (rs.next()) {      
        tags.add(rs.getString("tag"));
      }
    } 
    catch (SQLException e) {    
      System.out.println(e.getMessage());
    }

    System.out.println("tags[] created...");
  }

  public String dbGetVideo(String videoId) {

    String video = null;

    String sql = "SELECT * "
      + "FROM videos WHERE video_id = ?";

    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, videoId);    
      ResultSet rs  = pstmt.executeQuery();

      while (rs.next()) {      
        video = rs.getString("name");
      }
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }

    return video;
  }

  public void dbDeleteLink(String videoName, String tag) {

    String videoId = dbGetVideoId(videoName);
    String tagId = dbGetTagId(tag);

    System.out.println(videoId+" , "+ tagId);


    String sql = "DELETE FROM links WHERE video_id = ? AND tag_id = ?";

    //String sql = "SELECT link_id FROM links WHERE video_id = ?"+ 
    //"AND tag_id LIKE ?";


    try {

      PreparedStatement pstmt  = connection.prepareStatement(sql);
      pstmt.setString(1, videoId);
      pstmt.setString(2, tagId);
      pstmt.executeUpdate();

      //while (rs.next()) {      

      //}
    } 
    catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }
}
