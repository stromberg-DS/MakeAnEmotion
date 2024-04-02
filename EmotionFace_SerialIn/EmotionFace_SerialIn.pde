// Base code used from below:
//  https://docs.arduino.cc/built-in-examples/communication/VirtualColorMixer/

int faceCount = 5;
PFont raleMed, raleBold, raleBlk;
PShape[] face = new PShape[faceCount];
String[] fileNames = {"FaceTest1.svg", "FaceTest2.svg", "FaceTest3.svg", "FaceTest4.svg", "FaceTest5.svg"};
String[] emotions = {"a pleased", "a happy", "a content", "a proud", //Joy
  "an excited", "a hopeful",
  "a peaceful", "a relieved", "a caring", //love
  "a scared", "an anxious", "a nervous", //fear
  "an angry", "a frustrated", "a mean", //angry
  "a sad", "a guilty", "a disappointed", //sad
  "a confused", "a surprised", "an amazed"};      //surprised
int rndEmo = 0;
int thisFaceNum;
float halfWidth;
float halfHeight;

int cx, cy;
int eyeXOffset =100;
int eyeYOffset = -15;
int eyeCenterX;
int eyeCenterY;
int pupilSize = 50;
float irisSize = pupilSize *1.5;
int browXoffset = 60;
int browYoffset = 100;
int browVariability = 15;
int smileVariability = 400;
int mouthYOffset = 300;
int mouthWidth = 120;
int mouthCurvePoint = mouthWidth - 30;


float[] featureInputs = new float[6];
int lftBrowAngle = 0;
int lftBrowHeight = 1;
int smile = 2;
int rghtBrowAngle = 3;
int rghtBrowHeight = 4;
int blush = 5;

int maxBrowDifference = 25;
int maxSmileSize = 650;

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
  thisFaceNum = int(random(0, 4));

  //size(900, 900);
  fullScreen();
  background(0);
  cy = height/2;
  cx = width/2;
  eyeCenterX = cx + eyeXOffset;
  eyeCenterY = cy -eyeYOffset;
  raleMed = createFont("Raleway_Med.ttf", 100);
  raleBold = createFont("Raleway_Bold.ttf", 100);
  raleBlk = createFont("Raleway_Black.ttf", 100);
  textFont(raleBold);
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
  float lOutsideBrow = featureInputs[lftBrowAngle];
  float lInsideBrow = featureInputs[lftBrowHeight];
  float rOutsideBrow = featureInputs[rghtBrowAngle];
  float rInsideBrow = featureInputs[rghtBrowHeight];
  float smileSize = featureInputs[smile];

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
  fill(#2B1100);    //Irises
  circle(cx + eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy-eyeYOffset+(map(mouseY, 0, height, -20, +20)), irisSize);
  circle(cx -eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy -eyeYOffset+(map(mouseY, 0, height, -20, +20)), irisSize);

  fill(0);  //Pupils
  circle(cx + eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy-eyeYOffset+(map(mouseY, 0, height, -20, +20)), pupilSize);
  circle(cx -eyeXOffset+(map(mouseX, 0, width, -20, +20)), cy -eyeYOffset+(map(mouseY, 0, height, -20, +20)), pupilSize);


  shape(face[thisFaceNum], cx, cy+100);            // Draw at coordinate (280, 40) at the default size

  //Eyebrows
  stroke(#2B1100);
  strokeWeight(27);
  //line(x1, y1, x2, y2)
  //left eyebrow
  line((eyeCenterX-2*eyeXOffset)-browXoffset, eyeCenterY-browYoffset+lInsideBrow, (eyeCenterX-2*eyeXOffset)+browXoffset, eyeCenterY-browYoffset+lOutsideBrow);
  //right eyebrow
  line(eyeCenterX-browXoffset, eyeCenterY-browYoffset+rInsideBrow, eyeCenterX+browXoffset, eyeCenterY-browYoffset+rOutsideBrow);


  //line(eyeCenterX-browXoffset, eyeCenterY-browYoffset+insideBrow, eyeCenterX+browXoffset, eyeCenterY-browYoffset+outsideBrow);
  //line((eyeCenterX-2*eyeXOffset)-browXoffset, eyeCenterY-browYoffset+outsideBrow, (eyeCenterX-2*eyeXOffset)+browXoffset, eyeCenterY-browYoffset+insideBrow);

  //mouth
  strokeWeight(15);
  noFill();
  beginShape();
  curveVertex(cx-mouthCurvePoint, cy+mouthYOffset-smileSize);
  curveVertex(cx-mouthWidth, cy+mouthYOffset);
  curveVertex(cx+mouthWidth, cy+mouthYOffset);
  curveVertex(cx+mouthCurvePoint, cy+mouthYOffset-smileSize);
  endShape();

  fill(240);
  text("What does " + emotions[rndEmo] + "\nface look like?", cx, 150);
}



void serialEvent(Serial myPort) {

  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);    // trim off any whitespace:
    float[] potVals = float(split(inString, ","));    // split the string on the commas and convert the resulting substrings
    // into an integer array:

    // if the array has at least 9 elements, you know you got the whole
    // thing.  Put the numbers in the variables:
    if (potVals.length >= 9) {

      featureInputs[smile] = map(potVals[4], 0, 1023, -maxSmileSize, maxSmileSize);
      featureInputs[lftBrowHeight] = map(potVals[0], 0, 1023, 30, -25);
      featureInputs[lftBrowAngle] = map(potVals[3], 0, 1023, featureInputs[lftBrowHeight]+maxBrowDifference, featureInputs[lftBrowHeight]-maxBrowDifference);
      featureInputs[rghtBrowHeight] = map(potVals[2], 0, 1023, 30, -25);
      featureInputs[rghtBrowAngle] = map(potVals[5], 0, 1023, featureInputs[rghtBrowHeight]+maxBrowDifference, featureInputs[rghtBrowHeight]-maxBrowDifference);
      featureInputs[blush] = map(potVals[1], 0, 1023, 0, 100);
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
  } else if (mouseButton == RIGHT) {
    rndEmo = int(random(emotions.length));
  }
}
