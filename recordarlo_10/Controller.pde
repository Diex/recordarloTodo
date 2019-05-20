import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class Controller extends JFrame {
  private static final long serialVersionUID = 1L;


  JTextField it;
  JTextArea log;
  JLabel state_label;

  String  last_text = "";
  float time = 0.0;
  float total_len;
  String state;
  //Timer recordTimer;
File folder = null;   
PApplet parent;

  public Controller(PApplet parent) {
    super("Control");
      //keywords = new ArrayList<VideoFolder>();
    this.parent = parent;
    this.setSize(500, 100);

    log = new JTextArea();
    log.setLocation(10, 50);
    log.setSize(500, 300);
    log.setVisible(true);
    log.setText("Palabras Clave:");
    this.add(log);
        
    try {       
       folder = new File(settings.getString("defaultPath"));
       //continue();
       
    }catch (NullPointerException e){
      parent.selectFolder("Select a folder to process:", "folderSelected");
    }
  }
  
  
    
   /*

    File[] listOfFiles = folder.listFiles();
    
    for (File file : listOfFiles) {
      if (file.isDirectory()) {
        //VideoFolder vf = new VideoFolder(file);
        //keywords.add(vf);
        //log.append("\n   "+vf.keyword() + " ("+vf.size()+")");
      }
    }

    this.setLayout(null);
    this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    this.setSize(640, 480);

    it = new JTextField();
    it.setLocation(10, 10);
    it.setSize(300, 30);
    it.setVisible(true);
    it.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        println("Se apreto tecla sobre ventana fea");
        //enter();
      }
    }
    );
    this.add(it);
    state_label = new JLabel("-");
    state_label.setLocation(310, 10);
    state_label.setSize(80, 30);
    state_label.setVisible(true);
    this.add(state_label);
    this.setVisible(true);

    //recordTimer = new Timer();
    //recordTimer.setDurationInSeconds(30);
    //println("Duracion de Grabacion: " + recordTimer.getTotalTime());
    
    */
  //}


  // se llama cuando el usuario elije la carpeta
  File folderSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + selection.getAbsolutePath());
      settings.setString("defaultPath", selection.getAbsolutePath());
      this.folder = selection;
      //vf = new VideoFolder(selection);
      //videosList.clear();    
      //videosList.addItems(vf.files);
      //videosList.open();
      //dbConnect(vf);
      //dbAddFiles(vf);
      //replaceTagsList(null);
    }
    
    return selection;
  }
  /*
  public void in() {
   //println("Hay alguien");
   if (state.equals("idle"))
   ira("intro");
   }
   public void out() {
   //println("No hay nadie");
   if (!state.equals("idle"))
   ira("idle");
   }
   public void elapsed_time(float t, float lt) {
   if (state.equals("showing")) {
   state_label.setText(state+" "+int(total_len));
   } else {
   state_label.setText(state+" "+int(t));
   }
   
   if (state.equals("recording")) {
   String text = it.getText();
   
   if (!text.equals("")) {
   
   t -= lt;
   
   
   if (text.equals(last_text)) {
   time += t;
   
   
   if (time > stop_talking) {
   if (recordTimer.isFinished()) {
   ira("showing");
   }
   }
   } else {
   time = 0.0;
   }
   last_text = text;
   }
   }
   }
   public void begin() {
   ira("idle");
   }
   private void enter() {
   println("Se apreto tecla sobre ventana fea");
   state_label.setText(state);
   if (state.equals("idle")) {
   ira("intro");
   } else if (state.equals("intro")) {
   ira("recording");
   } else if (state.equals("recording")) {
   ira("showing");
   } else if (state.equals("showing")) {
   ira("end");
   } else if (state.equals("end")) {
   ira("idle");
   }
   }
   private void ira (String s) {
   if (s.equals("idle")) {
   load_video(idle_video);
   state = "idle";
   total_len = 0.0;
   } else if (s.equals("intro")) {
   println("Entrando a Intro");
   load_video(intro_video);
   state = "intro";
   } else if (s.equals("recording")) {
   recordTimer.start();
   println("TIMER START");
   
   last_text = "";
   time = 0.0;
   load_video(recording_video);
   state = "recording";
   it.setText("");
   } else if (s.equals("showing")) {
   load_video(test_video);
   current_video = -1;
   state = "showing";
   } else if (s.equals("end")) {
   //println("==> END: Garbage Collector");
   System.gc();
   load_video(end_video);
   state = "end";
   println("-=--- ENTRO A END");
   smoothPrevious = 1000;
   
   waitAtEnd.start();
   }
   state_label.setText(state);
   }
   private void load_video(String v) {
   show.load_video(v);
   }
   public void Log(String v) {
   this.log.append(v+"\n");
   }
   public void ended_video() {
   state_label.setText(state);
   if (state.equals("idle")) {
   load_video(idle_video);
   } else if (state.equals("intro")) {
   ira("recording");
   } else if (state.equals("recording")) {
   ira("showing");
   } else if (state.equals("showing")) {
   if (current_video == -1) {
   keys_list = new ArrayList<VideoFolder>();
   String recuerdo = it.getText();
   String[] palabras = recuerdo.toLowerCase().replace(".", " ").split(" ");
   for (int i=0; i<palabras.length; i++) {
   String palabra = palabras[i];
   if (pertenece(palabra, keys_list) == -1) {
   int p = pertenece(palabra, keywords);
   if (p != -1) {
   agregar(keywords.get(p), keys_list);
   }
   }
   }
   log.append("\nRecuerdo ingresado: "+recuerdo+"\n");
   videos = new ArrayList<String>();
   if (keys_list.size() == 0) videos.add(trash_video);
   for (int i=0; i<keys_list.size(); i++) {
   videos.add(keys_list.get(i).get_video());
   log.append(videos.get(i)+"\n");
   }
   }
   current_video++;
   println("Video => " + current_video);
   
   
   
   if (current_video == videos.size()) {
   if (total_len > duracion_recuerdo || keys_list.size()==0) {
   ira("end");
   } else {
   for (int i=0; i<keys_list.size(); i++) {
   String new_video = keys_list.get(i).get_video();
   videos.add(new_video);
   log.append(new_video+"\n");
   }
   load_video(videos.get(current_video));
   total_len += movie.duration();
   }
   println("VideosSize => " + videos.size());
   } else {
   load_video(videos.get(current_video));
   total_len += movie.duration();
   }
   } else if (state.equals("intro")) {
   ira("recording");
   } else if (state.equals("recording")) {
   ira("showing");
   }
   }
   int pertenece(String w, ArrayList<VideoFolder> ws) {
   for (int j=0; j<ws.size(); j++) {
   if (w.equals(ws.get(j).keyword())) {
   return j;
   }
   }
   return -1;
   }
   void agregar(VideoFolder w, ArrayList<VideoFolder> ws) {
   ws.add(w);
   }
   */
}
