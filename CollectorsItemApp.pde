// Declaring a variable of type PImage
//updateForce code from http://forum.processing.org/topic/fisica-attraction
import fisica.*;

FWorld world;
FBox cursorObject;
//FCircle peanut;
FBox[] boxes;

PImage bg;
PImage peanutImage;
PImage[] box_im;
PImage[] bgs;


int bg_num;
int timePressed;

float[] xmin;
float[] xmax;
float[] ymin;
float[] ymax;
float cursor_tip_x;
float cursor_tip_y;


// SETUP FUNCTION --
void setup() {
  bgs = new PImage[4];
  bgs[0] = loadImage("/CollectorsItemApp/Contents/Resources/background_1.png");
  bgs[1] = loadImage("/CollectorsItemApp/Resources/background_2.png");
  bgs[2] = loadImage("/CollectorsItemApp/Contents/Resources/background_3.png");
  bgs[3] = loadImage("/CollectorsItemApp/Contents/Resources/background_4.png");
  bg_num = 0;
  bg = bgs[bg_num];
  //size(displayWidth,displayHeight);
  size(1282,718);
  PImage cursor = loadImage("/CollectorsItemApp/Contents/Resources/mac-osx-arrow-cursor.png");
  xmin = new float[4];
  xmax = new float[4];
  ymin = new float[4];
  ymax = new float[4];
  xmin[0] = 1012;
  xmin[1] = 1087;
  xmin[2] = 1086;
  xmin[3] = 1088;
  xmax[0] = 1243;
  xmax[1] = 1245;
  xmax[2] = 1245;
  xmax[3] = 1247;
  ymin[0] = 511;
  ymin[1] = 392;
  ymin[2] = 347;
  ymin[3] = 336;
  ymax[0] = 542;
  ymax[1] = 418;
  ymax[2] = 373;
  ymax[3] = 362;
  
  boxes = new FBox[4];
  box_im = new PImage[4];
  box_im[0] = loadImage("/CollectorsItemApp/Contents/Resources/box_1.png");
  box_im[1] = loadImage("/CollectorsItemApp/Contents/Resources/box_2.png");
  box_im[2] = loadImage("/CollectorsItemApp/Contents/Resources/box_3.png");
  box_im[3] = loadImage("/CollectorsItemApp/Contents/Resources/box_4.png");
  
  peanutImage = loadImage("/CollectorsItemApp/Contents/Resources/peanut.png");
  
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  world.setEdgesFriction(0);
  world.setEdgesRestitution(.9);
  world.setGravity(0, 0);
  world.setGrabbable(false);
  cursorObject = new FBox(32,32);
  cursorObject.setPosition(350,200);
  cursorObject.attachImage(cursor);
  cursorObject.setAngularVelocity(random(-PI/2,PI/2));
  cursorObject.setVelocity(random(-200,200),random(-200,200));
  cursorObject.setRestitution(0);
  cursorObject.setFriction(0);
  cursorObject.setDamping(0.05);
  cursorObject.setAngularDamping(0.05);
  world.add(cursorObject);
}

void draw() { 
  refreshScreen();
}


void updateForce()
  {
    float x_coor = cursorObject.getX();
    float y_coor = cursorObject.getY();
    PVector a = new PVector(x_coor,y_coor);
    float rotation = cursorObject.getRotation();
    //println("time pressed is:" + timePressed);
    //println("x is " + x_coor + " y is " + y_coor + " rotation is " + rotation );
    //println("new x is " + (x_coor + 32*sin(rotation)) + "new y is " + (y_coor - 1500*sin(rotation)));
    cursor_tip_x = x_coor + 16*sin(rotation);
    cursor_tip_y = y_coor - 16*cos(rotation);
     
    PVector o = new PVector(cursor_tip_x, cursor_tip_y);
    PVector dir = PVector.sub(o, a); 
    dir.mult((timePressed*20)/dir.mag());
    if (dir.mag() < 1000) 
      dir.mult(1000/dir.mag());
    cursorObject.addForce(dir.x, dir.y);
  }
  
void mousePressed(){
  timePressed = millis();
}

void mouseReleased(){
  float x_coor = cursorObject.getX();
  float y_coor = cursorObject.getY();
  float rotation = cursorObject.getRotation();
  cursor_tip_x = x_coor + 16*sin(rotation);
  cursor_tip_y = y_coor - 16*cos(rotation);
  timePressed = millis() - timePressed;
  if (clickedBuy() == true)
    launchDebris();
  updateForce();
}

void launchDebris(){
  int boxNum = int(random(0,3));
  int peanutNum = int(random(25,60));
  FBox debrisBox = new FBox(box_im[boxNum].width,box_im[boxNum].height);
  debrisBox.setPosition(random(box_im[boxNum].width,bg.width-box_im[boxNum].width),random(box_im[boxNum].height,bg.height-box_im[boxNum].height));
  debrisBox.attachImage(box_im[boxNum]);
  debrisBox.setAngularVelocity(random(-PI/2,PI/2));
  debrisBox.setVelocity(random(-200,200),random(-200,200));
  debrisBox.setRestitution(0);
  debrisBox.setFriction(0.1);
  debrisBox.setDamping(0);
  debrisBox.setAngularDamping(0);
  world.add(debrisBox);
  for (int i = 0; i <= peanutNum; i++){
    FCircle peanut = new FCircle(peanutImage.width);
    peanut.attachImage(peanutImage);
    peanut.setPosition(random(0,bg.width),random(0,bg.height));
    peanut.setAngularVelocity(random(-PI/2,PI/2));
    peanut.setVelocity(random(-200,200),random(-200,200));
    peanut.setRestitution(0);
    peanut.setFriction(0.1);
    peanut.setDamping(0);
    peanut.setAngularDamping(0);
    world.add(peanut);
  }
}

boolean clickedBuy(){
  
  switch(bg_num){
    case 0:
      if (cursor_tip_x >= xmin[bg_num] && cursor_tip_x <= xmax[bg_num] && cursor_tip_y >= ymin[bg_num] && cursor_tip_y <= ymax[bg_num]){    
        bg_num++;
        bg = bgs[bg_num];
        cursorObject.setPosition(random(cursorObject.getWidth(),bg.width-cursorObject.getWidth()),random(cursorObject.getHeight(),bg.height-cursorObject.getHeight()));
        return true;
      }
      break;
    case 1:
      if (cursor_tip_x >= xmin[bg_num] && cursor_tip_x <= xmax[bg_num] && cursor_tip_y >= ymin[bg_num] && cursor_tip_y <= ymax[bg_num]){    
        bg_num++;
        bg = bgs[bg_num];
        cursorObject.setPosition(random(cursorObject.getWidth(),bg.width-cursorObject.getWidth()),random(cursorObject.getHeight(),bg.height-cursorObject.getHeight()));
        return true;
      }
      break;
    case 2:
      if (cursor_tip_x >= xmin[bg_num] && cursor_tip_x <= xmax[bg_num] && cursor_tip_y >= ymin[bg_num] && cursor_tip_y <= ymax[bg_num]){    
        bg_num++;
        bg = bgs[bg_num];
        cursorObject.setPosition(random(cursorObject.getWidth(),bg.width-cursorObject.getWidth()),random(cursorObject.getHeight(),bg.height-cursorObject.getHeight()));
        return true;
      }
      break;
    case 3:
      if (cursor_tip_x >= xmin[bg_num] && cursor_tip_x <= xmax[bg_num] && cursor_tip_y >= ymin[bg_num] && cursor_tip_y <= ymax[bg_num]){    
        bg_num = 0;
        bg = bgs[bg_num];
        cursorObject.setPosition(random(cursorObject.getWidth(),bg.width-cursorObject.getWidth()),random(cursorObject.getHeight(),bg.height-cursorObject.getHeight()));
        return true;
      }
      break;
  }
  return false;
}

void refreshScreen() {
  background(bg);
  world.step();
  world.step();
  world.draw();
}
