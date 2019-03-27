

static final boolean IS_PJS = 1/2 == 1/2.;

void settings() {

  size(window.innerWidth, window.innerHeight);


}

String msg = "";

MessageArea messageArea = new MessageArea();

void setup(){
  sysprint("Note:");
  sysprint("In the online version of the demo");
  sysprint("backspace doesnt work because it");
  sysprint("is intercepted by the browser.");
  sysprint("The final solution would have a working")
  sysprint("backspace function.");
  //size(1280,720);
  //surface.setResizable(true);
  //size(400,400);
  if (IS_PJS)  settings();

  //size(screen.width, screen.height);
}

void draw(){
  background(255);
  fill(0);
  messageArea.updatePosition(400,0,width-400,height);
  messageArea.render();
  fill(#428cf4);
  rect(0,0,400,height);

  if(frameCount%60==0){
    sysprint(""+millis());
  }

  fill(255);
  text(frameRate,20,20)
}

float ease(float x, int tx, float e){
  x +=(tx - x)*e;
  return x;
}

String substr(String str, int len){
    if(str!=null){
      if(str.length()>len){
        return(str.substring(0,len-2)+"..");
      }
      return str;
    }
    return "null";
}

class MessageArea {
  ArrayList<TextLine> console = new ArrayList<TextLine>();


  int x;
  int y;
  int w;
  int h;

  void updatePosition(int x, int y, int w, int h){
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }


  void render(){
    textSize(24);

    fill(255);
    strokeWeight(2);
    stroke(200);
    rect(x+10,y+h-58,w-20,48,24);
    noStroke();
    fill(0);
    textAlign(LEFT,CENTER);
    text(msg,x+30,y+h-58-3,w-100,48);

    for(int i = 0;i<console.size();i++){
      //text(console.get(i).text,10,height-90-30*console.size()+30*i,width-10,height-55);
      TextLine line = console.get(i);
      line.parent=this;
      line.render(x+10,y+h-90-(line.bheight+10)*console.size()+(line.bheight+10)*i);
    }



  }
}

class TextLine {
  String txt;
  int type;

  int xpadding = 40;
  int bheight = 48;
  int cradius = 24;

  float animspeed = 0.5;

  int maxchar = 75;

  int ty;
  float ay;
  int y;

  int tx;
  float ax;
  int x;

  int tw;
  float aw;
  int w;




  MessageArea parent;

  TextLine(String txt, int type, MessageArea parent){
    this.txt=txt;
    this.type=type;

    ay=height-48;
    this.parent=parent;
    ax=parent.x+10;
    aw=-parent.w+20;

    if(type==0){
      ay=height-106;
      ax=parent.x-textWidth(substr(txt,maxchar));
    }

  }



  void render(int tx, int ty){

    if(type==1){
      tw=int(-textWidth(substr(txt,maxchar))-xpadding);
    }

    ay=ease(ay,ty,animspeed);
    y=int(ay);

    ax=ease(ax,tx,animspeed);
    x=int(ax);

    aw=ease(aw,tw,animspeed);
    w=int(aw);

    if(type==0){
      textAlign(LEFT,CENTER);
      noStroke();
      fill(200);
      rect(x,y,textWidth(substr(txt,maxchar))+xpadding,bheight,cradius);
      fill(0);
      text(substr(txt,maxchar),x+xpadding/2,y-5,textWidth(substr(txt,maxchar))+xpadding,bheight);
      textAlign(LEFT);
    }else if(type==1){
      textAlign(LEFT,CENTER);
      noStroke();
      fill(#4286f4);
      rect(parent.x+parent.w-10+w,y,-w,bheight,cradius);
      fill(255);
      text(substr(txt,maxchar),parent.x+parent.w-10+w+xpadding/2,y-5,-w,bheight);

      noFill();
      strokeWeight(4);
      stroke(255,0,0);
      //rect(parent.x+parent.w-10+w,y-3,-w,bheight);
      textAlign(LEFT);
      noStroke();
    }
  }

}

void userprint(String txt){
  messageArea.console.add(new TextLine(txt,1,messageArea));
}

void sysprint(String txt){
  messageArea.console.add(new TextLine(txt,0,messageArea));
}

void bprint(String txt, int type){
  messageArea.console.add(new TextLine(txt,type,messageArea));
}

void keyPressed(){
  try{
    if(key!=BACKSPACE&&key<128&&key!=ENTER&&key!=27&&key!='`'){
      msg+=str(key);
    }else if(key==BACKSPACE&&msg.length()>=1){
      msg=msg.substring(0,msg.length()-1);
    }
    if(key==ENTER){
      //userprint(msg);
      bprint(msg,1);
      msg="";
    }

    if(key=='`'){
      bprint(msg,1);
      msg="";
    }
    //println(key+", ");

  }catch(Exception e){
    userprint(e.getMessage());
  }
}

interface externals {
  interface window {
    int innerWidth = 800, innerHeight = 600;
  }
}


void sendBackspace(){

  msg=msg.substring(0,msg.length()-1);
  //println("Backspace detected");
}
