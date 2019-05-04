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
    statement.executeQuery("CREATE TABLE IF NOT EXISTS videos (video_id INTEGER PRIMARY KEY, name TEXT NOT NULL);");

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
  for (String video : vf.files) {
    dbAddVideo(video);
  }
}

int dbAddVideo(String name) {
  if (getVideoId(name) == null) {
    println("inserting: "+ name);
    insert(name);
  }
  return 0;
}



public String getVideoId(String name) {

  String sql = "SELECT * "
    + "FROM videos WHERE name LIKE ?";

// loop through the result set
    String video_id = null;

  try {

    PreparedStatement pstmt  = connection.prepareStatement(sql);

    pstmt.setString(1, name);
    ResultSet rs  = pstmt.executeQuery();

    
    while (rs.next()) {
      video_id = rs.getString("video_id");
      //System.out.println(video_id);
    }
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
  
  return video_id;
  
}


public void insert(String name) {
  String sql = "INSERT INTO videos(name) VALUES(?)";

  try { //(Connection conn = this.connect();
    PreparedStatement pstmt = connection.prepareStatement(sql);
    pstmt.setString(1, name);
    pstmt.executeUpdate();
  } 
  catch (SQLException e) {
    System.out.println(e.getMessage());
  }
}
