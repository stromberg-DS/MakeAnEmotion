// Base code used from below:
//  https://docs.arduino.cc/built-in-examples/communication/VirtualColorMixer/

int cx;
int cy;
int eyeX =70;
int eyeY = 40;
int eyeCenterX;
int eyeCenterY;
int browXoffset = 30;
int browYoffset = 45;
int browVariability = 15;
int smileVariability = 400;

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


  size(900, 900);
  background(0);
  cy = height/2;
  cx = width/2;
  eyeCenterX = cx + eyeX;
  eyeCenterY = cy -eyeY;
}

void draw() {
  float insideBrow = map(featureInputs[inBrow], -10, 10, -browVariability, browVariability);
  float outsideBrow = map(featureInputs[outBrow], -10, 10, -browVariability, browVariability);
  float smileSize = map(featureInputs[smile], -10, 10, -smileVariability, smileVariability);

  //Face
  fill(#DEB887);
  noStroke();
  circle(cx, cy, 400);
  fill(255);
  circle(cx + eyeX, cy-eyeY, 70);
  circle(cx -eyeX, cy -eyeY, 70);

  //Pupils
  fill(80, 105, 148);
  circle(cx + eyeX+(map(mouseX, 0, width, -20, +20)), cy-eyeY+(map(mouseY, 0, height, -20, +20)), 30);
  circle(cx -eyeX+(map(mouseX, 0, width, -20, +20)), cy -eyeY+(map(mouseY, 0, height, -20, +20)), 30);

  fill(0);
  circle(cx + eyeX+(map(mouseX, 0, width, -20, +20)), cy-eyeY+(map(mouseY, 0, height, -20, +20)), 20);
  circle(cx -eyeX+(map(mouseX, 0, width, -20, +20)), cy -eyeY+(map(mouseY, 0, height, -20, +20)), 20);

  //Eyebrows
  stroke(0);
  strokeWeight(15);
  line(eyeCenterX-browXoffset, eyeCenterY-browYoffset+insideBrow, eyeCenterX+browXoffset, eyeCenterY-browYoffset+outsideBrow);
  line((eyeCenterX-2*eyeX)-browXoffset, eyeCenterY-browYoffset+outsideBrow, (eyeCenterX-2*eyeX)+browXoffset, eyeCenterY-browYoffset+insideBrow);

  //mouth
  strokeWeight(5);
  noFill();

  //smile
  beginShape();
  curveVertex(cx-60, cy+60-smileSize);
  curveVertex(cx-90, cy+60);
  curveVertex(cx+90, cy+60);
  curveVertex(cx+60, cy+60-smileSize);
  endShape();

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
      featureInputs[inBrow] = map(potVals[4], 0, 1023, featureInputs[outBrow]+maxBrowDifference,featureInputs[outBrow]-maxBrowDifference);
      featureInputs[outBrow] = map(potVals[5], 0, 1023, 10, -25);
    }
  }
}
