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
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.KeyEvent;

public class Controller extends JFrame implements ActionListener, DocumentListener {

  private static final long serialVersionUID = 1L;

  JTextField userInput;
  JTextArea log;
  public JLabel state_label;

  JButton exit;
  JButton getWordsBtn;
  JButton newPerson;

  PApplet parent;
  
//para apagar el ducking del dictation

//roma:~ diex$ defaults write com.apple.SpeechRecognitionCore AllowAudioDucking -bool NO
//roma:~ diex$ defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMAllowAudioDucking -bool NO
//roma:~ diex$ 




  public Controller(PApplet p) {    
    super("Control");    
    this.parent = p;        
    createGui();
    openDictation();
  }

  public void openDictation() {

    try {
      Robot r = new Robot();
      r.keyPress(KeyEvent.VK_CONTROL);
      r.keyPress(KeyEvent.VK_ALT);  
      r.keyPress(KeyEvent.VK_META);
      r.keyPress(KeyEvent.VK_D);
      r.keyRelease(KeyEvent.VK_CONTROL);
      r.keyRelease(KeyEvent.VK_ALT);  
      r.keyRelease(KeyEvent.VK_META);
      r.keyRelease(KeyEvent.VK_D);
    }
    catch (AWTException e) {
      e.printStackTrace();
    }
  }

  public void warn(DocumentEvent e) {
    if (e.getLength() <= 0) {
      //JOptionPane.showMessageDialog(null, 
      //  "Error: Please enter number bigger than 0", "Error Message", 
      //  JOptionPane.ERROR_MESSAGE);
    }
  }

  public void clearInput() {
    userInput.setText("");
  }

  public void newPerson() {
    parent.key = 'p';
    parent.keyPressed();
  }

  public void randomTags(){
    parent.key = 'r';
    parent.keyPressed();
  }

  public HashSet<String> getWords() {
    log.setText("");
    String text = "";
    HashSet <String> uniqueWords = new HashSet<String>();

    try {
      text = userInput.getText();
      if (text != null) {
        String[] words = text.split(" ");
        Arrays.sort(words);
        
        ArrayList<String> lowerCaseWords = new ArrayList<String>();
        
        for(String w : words){
          String removedenie = w.toLowerCase().replace("ñ", "n");
          lowerCaseWords.add(removedenie);
        }
        
        uniqueWords = new HashSet<String>(lowerCaseWords);
        for (String s : uniqueWords) {
          log.append(s+'\n');
        }        
      }else{
          log.append("words not detected" +'\n');
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    userInput.setText("");
    return uniqueWords;
  }


  private void println(String s) {
    System.out.println(s);
  }

  public void Log(String v) {
    this.log.append(v+"\n");
  }

 


  void createGui() {

    int componentWidth = 400;
    int componentHeight = 200;
    int leftMargin = 10;

    this.setLayout(null);
    this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    this.setSize(640, 480);


    userInput = new JTextField();
    userInput.setSize(componentWidth, 30);    
    userInput.setLocation(leftMargin, 10);
    userInput.setVisible(true);
    userInput.addActionListener(this);
    //userInput.getDocument().addDocumentListener(this);
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
    if (e.getActionCommand().equals("getWords")) randomTags();
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
