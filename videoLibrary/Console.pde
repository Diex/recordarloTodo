import controlP5.*;
 
ControlP5 controlP5;
 
Textarea Output;
Println console;
 
void setupConsole()
{
controlP5 = new ControlP5(this);
  
    Output=controlP5.addTextarea("Output")
    .setPosition(0, 700)
      .setSize(width, height - 700)
        .setLineHeight(14)
          .setColorBackground(color(255,200))
            .setColorForeground(color(255,100))
            .setColor(color(255,0,0))
              .scroll(10)              
              ;
                //.hideScrollbar();
   
   //console = controlP5.addConsole(Output);
   
 } 
 
