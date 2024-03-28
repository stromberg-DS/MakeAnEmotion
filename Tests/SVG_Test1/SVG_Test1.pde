int faceCount = 5;
PShape[] face = new PShape[faceCount];
String[] fileNames = {"FaceTest1.svg", "FaceTest2.svg", "FaceTest3.svg", "FaceTest4.svg", "FaceTest5.svg"};
int thisFaceNum;
int lastFaceNum;
float halfWidth;
float halfHeight;
float centerX;
float centerY;
int pupilDistance = 92;
int pupilSize = 40;
int irisSize = pupilSize +20;

void setup() {
  thisFaceNum = round(random(0, 5));
  lastFaceNum = thisFaceNum;
  println(thisFaceNum);
  //size(800, 800);
  fullScreen();
  centerX = width/2;
  centerY = height/2;
  // The file "bot1.svg" must be in the data folder
  // of the current sketch to load successfully
  for (int i=0; i<faceCount; i++) {
    face[i] = loadShape(fileNames[i]);
  }
  halfWidth = face[1].getWidth();
  halfHeight = face[1].getHeight();
  shapeMode(CENTER);
  rectMode(CENTER);
}

void draw() {
  background(100);
  noStroke();

  //Eyeball
  fill(251, 237, 227);
  rect(centerX, centerY-50, 400, 250);
  //Iris
  fill(43, 17, 0);
  ellipse(mouseX+pupilDistance, mouseY, irisSize, irisSize);
  ellipse(mouseX-pupilDistance, mouseY, irisSize, irisSize);
  //Pupil
  fill(0);
  ellipse(mouseX+pupilDistance, mouseY, pupilSize, pupilSize);
  ellipse(mouseX-pupilDistance, mouseY, pupilSize, pupilSize);

  shape(face[thisFaceNum], (centerX), height/2);            // Draw at coordinate (280, 40) at the default size
}

void mouseClicked() {
  if(thisFaceNum < faceCount-1){
    thisFaceNum++;
  } else{
    thisFaceNum = 0;
  }
}
