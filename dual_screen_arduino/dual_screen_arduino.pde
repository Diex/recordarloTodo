// Ruta a la carpeta "data", donde están los videos
//String path_to_videos = "/Users/ivananebuloni/Desktop/dual_screen_arduino/data";
//String path_to_videos = "C:/Users/HacheG.Zeta/Desktop/dual_screen/data";
String path_to_videos = "/Users/ivananebuloni/Documents/Processing/recordadarloTodo/dual_screen_arduino/data";
// Ancho del video (deberia ser igual al ancho de la resolucion de la pantalla)
int video_x = 720;
// Alto del video (deberia ser igual al alto de la resolucion de la pantalla)
int video_y = 576;
// Video mientras no hay nadie
String idle_video = "idle.mp4";
// Video introductorio con las instrucciones
String intro_video = "intro.mp4";
// Video mientras se esta grabando
String recording_video = "record.mp4";
// Video para mostrar (de prueba) -> Puede ser la transicion tipo recuerdo borroso para dejar un tiempo a que se termine de escribir el recuerdo
String test_video = "transicion.mp4";
// Video para mostrar si no se encontró ninguna palabra clave
String trash_video = "trash.mp4";
// Video para mostrar al finalizar y hasta que la persona se vaya
String end_video = "end.mp4";
// Ancho de la ventana de control
int ctrl_screen_x = 800;
// Alto de la ventana de control
int ctrl_screen_y = 600;
// Mínimo de segundos que se espera que dure un recuerdo
float duracion_recuerdo = 30.0;
// umbral de corte: como los videos no se reproducen hasta el final, para saber cuando termina preguntamos si falta menos de esta cantidad de segundos para que termine.
// nota: suponer que esta cantidad de segundos del final de cada video no se va a reproducir.
float umbral = 0.1;
// Cantidad de veces que tolero que me llegue el mismo valor de tiempo de video antes de subir el umbral
int k_veces = 5;
// Cantidad de segundos en silencio para considerar que la persona dejó a hablar
float stop_talking = 5.0;
// Distancia en centímetros tal que si se detecta un obstáculo a menor distnacia, se considera que hay alguien.
int distancia_persona = 80;

import processing.video.*;
import processing.serial.*;
import apsync.*;
import controlP5.*;
ControlP5 cp5;
ShowApplet show;
Movie movie;
Control c;
PFont f;
AP_Sync streamer;

// ArrayList<Movie> movieList;

public int Distancia = -1;
int umbralRuido = 30;
int distanciaFinal = 50;
public boolean enActividad;

float smoothPrevious = 120;
float smoothFactor = 0.03;

Timer waitAtEnd = new Timer();


void setup() {
  //String portName = Serial.list()[5];
  frameRate(15);
  println (Serial.list());
  //streamer = new AP_Sync(this, "/dev/cu.usbmodem1411", 9600);

  String[] args = {"YourSketchNameHere"};
  show = new ShowApplet();
  PApplet.runSketch(args, show);
  cp5 = new ControlP5(this);
  c = new Control();
  c.setSize(500, 300);
  c.begin();

  enActividad = false;
  // movieList = new ArrayList<Movie>();

  waitAtEnd.setDuration(10);
  waitAtEnd.start();
}


public void settings() {
  size(100, 100);
}

float last_time;
int k;

void draw() {
  background(0);

  float time = 1;
  float duration = 1;
  if (movie != null) {
    time = movie.time();
    duration = movie.duration();
  }

  if (!c.state.equals("end") && duration > 0.0 && time > 0.0) {
    if (time == last_time) {
      k++;
      if (k > k_veces) {
        umbral += 0.1;
        c.Log("OJO! el umbral subió a "+umbral);
      }
    } else {
      k = 0;
    }
    if (duration-time < umbral) {
      c.ended_video();
    }
    c.elapsed_time(time, last_time);
    /* DEBUG
     if (time > 3)
     Distancia = 100;
     if (time > 4)
     Distancia = 10;
     last_time = time;*/
  }
  /*
  if (Distancia > 5) {
   
   // SOLO FILTRAMOS CUANDO LA SE DETECTO ALGUIEN
   //println("-|| EN ACTIVIDAD: ");
   if (distanciaFinal < distancia_persona) {
   println("-|| FILTRANDO");
   
   if (Distancia > (distanciaFinal - umbralRuido) &&  Distancia < (distanciaFinal + umbralRuido)) {
   distanciaFinal = Distancia;
   } else if (Distancia > distancia_persona) {
   distanciaFinal = Distancia;
   }
   } else {
   distanciaFinal = Distancia;
   println("-|| NO FILTRANDO");
   }
   
   }
   */

  if (!enActividad) {
    //if (waitAtEnd.isFinished()) {
      distanciaFinal = int(smoothingExponential(float(Distancia)));
    //}
  }

  println("--- || DISTANCIA: " + Distancia + " | SMOOTHED: " + distanciaFinal);


  if (c.state.equals("idle") || c.state.equals("end")) {
    enActividad = false;
  } else {
    enActividad = true;
  }
  println(enActividad ? "EN ACTIVIDAD" : "ESPERANDO" );
  println(waitAtEnd.isFinished() ? "ESPERANDO END" : "NO EN END");

  if (Distancia > 5) {
    if (distanciaFinal < distancia_persona) {
      c.in();
      println("-|| PERSONA DETECTADA");
      //delay(1000);
    } else {
      c.out();
      println("-|| NADA EN RANGO");
    }
  } else {
    println("-|| DISTANCIA < 5");
  }
  println("===========================");
}     

public class ShowApplet extends PApplet {
  public void settings() {
    //fullScreen();
    size(720, 576);
  }
  public void draw() {
    background(0);
    if (movie != null) {
      image(movie, 0, 0, video_x, video_y);
    }


    ///// MOSTAR DATOS
    /*
    String estadoActual = c != null ? c.state : "Esperando";
     textSize(40);
     fill(255, 0, 0);
     if (enActividad) {
     text("--|| PERSONA  | ESTADO: " + estadoActual, 20, 100);
     } else {
     text("--|| VACIO    | ESTADO: " + estadoActual, 20, 100);
     }
     
     textSize(20);
     text("-|| DISTANCIA: " + Distancia + " | SMOOTHED: " + distanciaFinal, 20, 150);
     */

    ///// MOSTAR DATOS - FIN

    if (frameCount > 500) {
      if (c.it != null && !c.it.hasFocus()) {
        c.it.requestFocus();
      }
    }
  }
  public void load_video(String v) {
    new_movie(v);
    last_time = 0.0;
    k = 0;
  }


  void mousePressed() {
    c.state = "idle";
    smoothPrevious = 120;
    println("------------------------------------- MOUSE PRESIONADO");
  }
}



// ===========================================================
void new_movie(String v) {
  if (movie != null) {
    movie.dispose();
    println("-|| DISPOSING MOVIE");
  }
  movie = null;

  println("-|| LOADING MOVIE: " + v);

  movie = new Movie(this, v);
  movie.play();
  delay(250);
  println(" ==> " + v + " : " + movie.duration());
}

void movieEvent(Movie m) {
  m.read();
}

float smoothingExponential(float value) {
  float smoothedValue = smoothFactor * value + ((1 - smoothFactor) * smoothPrevious);
  smoothPrevious = smoothedValue;
  return smoothedValue;
}
