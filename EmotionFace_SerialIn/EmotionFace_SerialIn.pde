// Base code used from below:
//  https://docs.arduino.cc/built-in-examples/communication/VirtualColorMixer/

int faceCount = 5;
PShape[] face = new PShape[faceCount];
String[] fileNames = {"FaceTest1.svg", "FaceTest2.svg", "FaceTest3.svg", "FaceTest4.svg", "FaceTest5.svg"};
String[] emotions = {"pleased", "happy", "content", "proud",  //Joy
                    "excited", "hopeful", "excited",  
                    "peaceful", "relieved", "caring",        //love
                    "scared", "anxious", "nervous",          //fear
                    "angry", "frustrated", "mean",          //angry
                    "sad", "guilty", "disappointed",        //sad
                    "confused", "surprised", "amazed"};      //surprised
int rndEmo = 0; 
int thisFaceNum;
float halfWidth;
float halfHeight;

int cx;
int cy;
int eyeXOffset =100;
int eyeYOffset = 75;
int eyeCenterX;
int eyeCenterY;
int pupilSize = 50;
float irisSize = pupilSize *1.5;
int browXoffset = 60;
int browYoffset = 110;
int browVariability = 15;
int smileVariability = 400;
int mouthYOffset = 200;
int mouthWidth = 120;
int mouthCurvePoint = mouthWidth - 30;

boolean[] keys = new boolean[6];
int UPP = 0;
int DWN = 1;
int LFT = 2;
int RGT = 3;
int AAA = 4;
int DDD = 5;


//keyboard input values. stored in array for ease of use.
float[] featureInputs = new float[3];
int inBrow = 0;
int outBrow = 1;
int smile = 2;
int maxBrowDifference = 25;
int maxSmileSize = 14;

import processing.serial.*;

float redValue = 0;        // red value
float greenValue = 0;      // green value
float blueValue = 0;       // blue value

Serial myPort;



void setup() {
  // angleMode(DEGREES);
  // colorMode(HSB, 255);

  myPort = new Serial(this, Serial.list()[0], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  thisFaceNum = round(random(0, 5));

  //size(900, 900);
  fullScreen();
  background(0);
  cy = height/2;
  cx = width/2;
  eyeCenterX = cx + eyeXOffset;
  eyeCenterY = cy -eyeYOffset;
  for (int i=0; i<faceCount; i++) {
    face[i] = loadShape(fileNames[i]);
  }
  halfWidth = face[1].getWidth();
  halfHeight = face[1].getHeight();
  shapeMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER);
  textSize(100);
}

void draw() {
  float insideBrow = map(featureInputs[inBrow], -10, 10, -browVariability, browVariability);
  float outsideBrow = map(featureInputs[outBrow], -10, 10, -browVariability, browVariability);
  float smileSize = map(featureInputs[smile], -10, 10, -smileVariability, smileVariability);
  background(100);


  //Face
  //fill(#DEB887);
  //noStroke();
  //circle(cx, cy, 400);
  //fill(255);
  //circle(cx + eyeXOffset, cy-eyeYOffset, 70);
  //circle(cx -eyeXOffset, cy -eyeYOffset, 70);




  //Eyes
  fill(255);
  noStroke();
  rect(cx, cy-50, 400, 250);
  fill(#2B1100);
  circle(cx + eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy-eyeYOffset+(map(mouseY, 0, height, -20, +20)), irisSize);
  circle(cx -eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy -eyeYOffset+(map(mouseY, 0, height, -20, +20)), irisSize);

  fill(0);
  circle(cx + eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy-eyeYOffset+(map(mouseY, 0, height, -20, +20)), pupilSize);
  circle(cx -eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy -eyeYOffset+(map(mouseY, 0, height, -20, +20)), pupilSize);


  shape(face[thisFaceNum], (cx), height/2);            // Draw at coordinate (280, 40) at the default size

  //Eyebrows
  stroke(#2B1100);
  strokeWeight(27);
  line(eyeCenterX-browXoffset, eyeCenterY-browYoffset+insideBrow, eyeCenterX+browXoffset, eyeCenterY-browYoffset+outsideBrow);
  line((eyeCenterX-2*eyeXOffset)-browXoffset, eyeCenterY-browYoffset+outsideBrow, (eyeCenterX-2*eyeXOffset)+browXoffset, eyeCenterY-browYoffset+insideBrow);

  //mouth
  strokeWeight(15);
  noFill();
  beginShape();
  curveVertex(cx-mouthCurvePoint, cy+mouthYOffset-smileSize);
  curveVertex(cx-mouthWidth, cy+mouthYOffset);
  curveVertex(cx+mouthWidth, cy+mouthYOffset);
  curveVertex(cx+mouthCurvePoint, cy+mouthYOffset-smileSize);
  endShape();
  
  fill(255);
  text("What does a " + emotions[rndEmo] + "\nface look like?", cx, 100);
  println(emotions.length);
  
}



void serialEvent(Serial myPort) {

  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);    // trim off any whitespace:
    float[] potVals = float(split(inString, ","));    // split the string on the commas and convert the resulting substrings
    // into an integer array:

    // if the array has at least three elements, you know you got the whole
    // thing.  Put the numbers in the color variables:
    if (potVals.length >= 6) {

      featureInputs[smile] = map(potVals[3], 0, 1023, maxSmileSize, -maxSmileSize);
      featureInputs[inBrow] = map(potVals[4], 0, 1023, featureInputs[outBrow]+maxBrowDifference, featureInputs[outBrow]-maxBrowDifference);
      featureInputs[outBrow] = map(potVals[5], 0, 1023, 30, -25);
    }
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    if (thisFaceNum < faceCount-1) {
      thisFaceNum++;
    } else {
      thisFaceNum = 0;
    }
  } else if(mouseButton == RIGHT) {
        rndEmo = int(random(emotions.length));
  }
}
