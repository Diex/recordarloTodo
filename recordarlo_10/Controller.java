import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.io.File;
import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.event.*;
import javax.swing.text.Document;
import javax.swing.text.Element;

import javax.swing.text.BadLocationException;
import java.util.*;
import processing.core.*;

public class Controller extends JFrame implements ActionListener, DocumentListener {

  private static final long serialVersionUID = 1L;

  // GUI
  JTextField userInput;
  JTextArea log;
  JLabel state_label;
  JButton exit;
  JButton getWordsBtn;
  JButton newPerson;
  
  PApplet parent;


  public Controller(PApplet p) {    
    super("Control");    
    this.parent = p;        
    createGui();
  }

  
  public void warn(DocumentEvent e) {
    if (e.getLength() <= 0) {
      //JOptionPane.showMessageDialog(null, 
      //  "Error: Please enter number bigger than 0", "Error Message", 
      //  JOptionPane.ERROR_MESSAGE);
    }
  }
  
  public void clearInput(){
    userInput.setText("");
  }
  
  public void newPerson(){
    parent.key = 'p';
    parent.keyPressed();
  }
  
  public HashSet<String> getWords(){
    log.setText("");
    println("getwords.");    
    String text = "";    
    try{
       text = userInput.getText();
    }catch (Exception e){
       e.printStackTrace();
    }
    
    String[] words = text.split(" ");
    Arrays.sort(words);    
    HashSet <String> uniqueWords = new HashSet<String>(Arrays.asList(words));
    for(String s : uniqueWords){
      log.append(s+'\n');      
      println(s);
    }
    
    userInput.setText("");
    return uniqueWords;
  }


  private void println(String s) {
    System.out.println(s);
  }
  public void in() {
    ////println("Hay alguien");
    //if (state.equals("idle"))
    //  ira("intro");
  }
  public void out() {
    ////println("No hay nadie");
    //if (!state.equals("idle"))
    //  ira("idle");
  }
  public void elapsed_time(float t, float lt) {
    //if (state.equals("showing")) {
    //  state_label.setText(state+" "+int(total_len));
    //} else {
    //  state_label.setText(state+" "+int(t));
    //}

    //if (state.equals("recording")) {
    //  String text = it.getText();

    //  if (!text.equals("")) {

    //    t -= lt;


    //    if (text.equals(last_text)) {
    //      time += t;


    //      if (time > stop_talking) {
    //        if (recordTimer.isFinished()) {
    //          ira("showing");
    //        }
    //      }
    //    } else {
    //      time = 0.0;
    //    }
    //    last_text = text;
    //  }
    //}
  }
  public void begin() {
    //ira("idle");
  }
  private void enter() {
    //println("Se apreto tecla sobre ventana fea");
    //state_label.setText(state);
    //if (state.equals("idle")) {
    //  ira("intro");
    //} else if (state.equals("intro")) {
    //  ira("recording");
    //} else if (state.equals("recording")) {
    //  ira("showing");
    //} else if (state.equals("showing")) {
    //  ira("end");
    //} else if (state.equals("end")) {
    //  ira("idle");
    //}
  }
  private void ira (String s) {
    //if (s.equals("idle")) {
    //  load_video(idle_video);
    //  state = "idle";
    //  total_len = 0.0;
    //} else if (s.equals("intro")) {
    //  println("Entrando a Intro");
    //  load_video(intro_video);
    //  state = "intro";
    //} else if (s.equals("recording")) {
    //  recordTimer.start();
    //  println("TIMER START");

    //  last_text = "";
    //  time = 0.0;
    //  load_video(recording_video);
    //  state = "recording";
    //  it.setText("");
    //} else if (s.equals("showing")) {
    //  load_video(test_video);
    //  current_video = -1;
    //  state = "showing";
    //} else if (s.equals("end")) {
    //  //println("==> END: Garbage Collector");
    //  System.gc();
    //  load_video(end_video);
    //  state = "end";
    //  println("-=--- ENTRO A END");
    //  smoothPrevious = 1000;

    //  waitAtEnd.start();
    //}
    //state_label.setText(state);
  }
  private void load_video(String v) {
    //show.load_video(v);
  }
  public void Log(String v) {
    this.log.append(v+"\n");
  }
  public void ended_video() {
    //state_label.setText(state);
    //if (state.equals("idle")) {
    //  load_video(idle_video);
    //} else if (state.equals("intro")) {
    //  ira("recording");
    //} else if (state.equals("recording")) {
    //  ira("showing");
    //} else if (state.equals("showing")) {
    //  if (current_video == -1) {
    //    keys_list = new ArrayList<VideoFolder>();
    //    String recuerdo = it.getText();
    //    String[] palabras = recuerdo.toLowerCase().replace(".", " ").split(" ");
    //    for (int i=0; i<palabras.length; i++) {
    //      String palabra = palabras[i];
    //      if (pertenece(palabra, keys_list) == -1) {
    //        int p = pertenece(palabra, keywords);
    //        if (p != -1) {
    //          agregar(keywords.get(p), keys_list);
    //        }
    //      }
    //    }
    //    log.append("\nRecuerdo ingresado: "+recuerdo+"\n");
    //    videos = new ArrayList<String>();
    //    if (keys_list.size() == 0) videos.add(trash_video);
    //    for (int i=0; i<keys_list.size(); i++) {
    //      videos.add(keys_list.get(i).get_video());
    //      log.append(videos.get(i)+"\n");
    //    }
    //  }
    //  current_video++;
    //  println("Video => " + current_video);



    //  if (current_video == videos.size()) {
    //    if (total_len > duracion_recuerdo || keys_list.size()==0) {
    //      ira("end");
    //    } else {
    //      for (int i=0; i<keys_list.size(); i++) {
    //        String new_video = keys_list.get(i).get_video();
    //        videos.add(new_video);
    //        log.append(new_video+"\n");
    //      }
    //      load_video(videos.get(current_video));
    //      total_len += movie.duration();
    //    }
    //    println("VideosSize => " + videos.size());
    //  } else {
    //    load_video(videos.get(current_video));
    //    total_len += movie.duration();
    //  }
    //} else if (state.equals("intro")) {
    //  ira("recording");
    //} else if (state.equals("recording")) {
    //  ira("showing");
    //}
  }
  //int pertenece(String w, ArrayList<VideoFolder> ws) {
  //  for (int j=0; j<ws.size(); j++) {
  //    if (w.equals(ws.get(j).keyword())) {
  //      return j;
  //    }
  //  }
  //  return -1;
  //}
  //void agregar(VideoFolder w, ArrayList<VideoFolder> ws) {
  //  ws.add(w);
  //}


  int componentWidth = 400;
  int componentHeight = 200;
  int leftMargin = 10;

  void createGui() {
    this.setLayout(null);
    this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    this.setSize(640, 480);


    userInput = new JTextField();
    userInput.setSize(componentWidth, 30);    
    userInput.setLocation(leftMargin, 10);
    userInput.setVisible(true);
    userInput.addActionListener(this);
    userInput.getDocument().addDocumentListener(this);
    this.add(userInput);

    log = new JTextArea();    
    log.setSize(componentWidth, componentHeight);
    log.setLocation(leftMargin, 50);
    log.setVisible(true);
    log.setText("Palabras Clave:");    
    this.add(log);



    state_label = new JLabel("-");
    state_label.setLocation(componentWidth+leftMargin*2, 10);
    state_label.setSize(80, 30);
    state_label.setVisible(true);    
    this.setVisible(true);
    this.add(state_label);


    exit = new JButton("exit");
    exit.setLocation(310, 350);
    exit.setSize(200, 30); 
    exit.setActionCommand("exit");
    exit.setVisible(true);
    exit.addActionListener(this);
    this.add(exit);

    getWordsBtn = new JButton("get words");
    getWordsBtn.setLocation(310, 380);
    getWordsBtn.setSize(200, 30);
    getWordsBtn.setActionCommand("getWords");
    getWordsBtn.setVisible(true);
    getWordsBtn.addActionListener(this);
    this.add(getWordsBtn);
    
    newPerson = new JButton("new Person");
    newPerson.setLocation(310, 410);
    newPerson.setSize(200, 30);
    newPerson.setActionCommand("newPerson");
    newPerson.setVisible(true);
    newPerson.addActionListener(this);
    this.add(newPerson);
  }
  
  // interfases
  @Override
    public void actionPerformed(ActionEvent e) {   
    if (e.getActionCommand().equals("exit")) parent.exit();
    if (e.getActionCommand().equals("getWords")) getWords();
    if (e.getActionCommand().equals("newPerson")) newPerson();
  }

  @Override
    public void changedUpdate(DocumentEvent e) {
      //this.setVisible(true);
  }
  @Override
    public void removeUpdate(DocumentEvent e) {
  }

  @Override
    public void insertUpdate(DocumentEvent e) {
  }

}
