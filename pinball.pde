import java.util.HashMap;
import java.io.File;
import processing.sound.*;

//Parameters required changing start here
String fileName = "Scene2";// File name of the scene, these scenes should be in the same folder as this sde file.

PImage bg;
PImage circleObstacle;
String detectMethod = "BVH"; //Normal or BVH

import ddf.minim.*;
Minim minim;
AudioPlayer playerBox;
AudioPlayer playerBall;
AudioPlayer playerLoseBall;
int deadBall;

float cor = 0.95f;
float[] gateInfo = {8, 1, 8, 2.5};
float[] finishLine = {0, 10, 10, 10};
int maxParticles = 3;
int currentBall = 0;
Vec2 pos[] = new Vec2[maxParticles];
Vec2 vel[] = new Vec2[maxParticles];
int[] status = new int[maxParticles];
Vec2 g = new Vec2(0,980);
//9.8 m / s^2 = 980 pixel / s^2
float ballRadius = 10;
float velMax = 500;
int transparentGreen = color(0, 255, 255, 127);
int neonPink = color(255, 20, 147, 127);
int neonYellow = color(255, 223, 0, 255);
int darkBlue = color(100, 100, 200, 200);
int darkBlue2 = color(100, 100, 255, 255);
int darkBlack = color(0, 0, 0, 255);
int shinyBlue = color(135, 206, 250, 200);
SceneCollisionDetectorBVH sceneCD_BVH;

float fliperLength = 1.5;
float fliperAngleLeft = 33.69; // atan(1/2)
float fliperAngleRight = 33.69; // atan(1/2)

float maxFliperAngle = 33.69;
float minFliperAngle = -33.69;
float fliperRotateSpeed = 100;
float fliperRecoverSpeed = -300;
float fliperRotationSpeedLeft = 0;
float fliperRotationSpeedRight = 0;

float[] fliperPos1 = {2.5, 8, 4, 9};
float[] fliperPos2 = {6.5, 8, 5, 9};


float resizeFactor = 50; //Parameter used for rendering collision detection result
String[] shapeArray = {"Lines", "Circles", "Boxes"};
HashMap<String, float[][]> shapeDataMap = new HashMap<String, float[][]>();
ArrayList<ShapeObject> shapeObjects;

String currentShapeType = "";
int shapeElementNum;
int currentScore;
boolean detectAndSwitchHeader(String line){
  //Function to parse the input scene txt file, and switch the shape type based on the header in the file
  for (int i = 0; i < shapeArray.length; i++){
    if (line.startsWith(shapeArray[i])){
      int shapeCount = int(line.split(":")[1].trim());
      if (shapeArray[i] == "Circles") {
        shapeElementNum = 3;
      } else {
        shapeElementNum = 4;
      }
      shapeDataMap.put(shapeArray[i], new float[shapeCount][shapeElementNum]);
      currentShapeType = shapeArray[i];
      return true;
    }
  }
  return false;
}

void drawBasedOnShape(String shapeType, float[] shapeData){
  //Function to render the shape
  switch (shapeType){
    case "Lines":
      stroke(darkBlue2);
      fill(darkBlue2);
      strokeWeight(5);
      line(shapeData[0] * resizeFactor, shapeData[1] * resizeFactor, shapeData[2] * resizeFactor, shapeData[3] * resizeFactor);
      break;
    case "Fliper":
      stroke(darkBlack);
      fill(darkBlack);
      strokeWeight(5);
      line(shapeData[0] * resizeFactor, shapeData[1] * resizeFactor, shapeData[2] * resizeFactor, shapeData[3] * resizeFactor);
      break;
    case "Gate":
      stroke(color(255, 255, 255, 200));
      fill(255, 255, 255, 200);
      strokeWeight(5);
      line(shapeData[0] * resizeFactor, shapeData[1] * resizeFactor, shapeData[2] * resizeFactor, shapeData[3] * resizeFactor);
      break;
    case "Circles":
      stroke(neonYellow);
      fill(neonYellow);
      strokeWeight(3);
      circleObstacle.resize((int)(shapeData[2] * resizeFactor * 2), 0);
      image(circleObstacle, (shapeData[0] - shapeData[2]) * resizeFactor, (shapeData[1] - shapeData[2]) * resizeFactor, shapeData[2] * resizeFactor * 2, shapeData[2] * resizeFactor * 2);
      //circle(shapeData[0] * resizeFactor, shapeData[1] * resizeFactor, shapeData[2] * resizeFactor * 2);
      break;
    case "Boxes":
      stroke(darkBlue2);
      fill(darkBlue);
      strokeWeight(5);
      rect(shapeData[0] * resizeFactor, shapeData[1] * resizeFactor, shapeData[2] * resizeFactor, shapeData[3] * resizeFactor);
      break;
    default:
      println("No such type of shape!!");
      break;
  }
}
void drawObstacles(){
  stroke(neonYellow);
  fill(0, 0, 0, 0);
  strokeWeight(3);
  for (int i = 0; i < shapeObjects.size(); i++){
    drawBasedOnShape(shapeObjects.get(i).shapeType, shapeObjects.get(i).objectInfo);
  }
}


void updateFliper(float dt){
  if (leftPressed) {
    fliperRotationSpeedLeft = fliperRotateSpeed;
  } else {
    fliperRotationSpeedLeft = fliperRecoverSpeed;
  }
  if (rightPressed) {
    fliperRotationSpeedRight = fliperRotateSpeed;
  } else {
    fliperRotationSpeedRight = fliperRecoverSpeed;
  }
  
  fliperAngleLeft = fliperAngleLeft - fliperRotationSpeedLeft * dt;
  fliperAngleLeft = max(min(fliperAngleLeft, maxFliperAngle), minFliperAngle);
  if (fliperAngleLeft == maxFliperAngle || fliperAngleLeft == minFliperAngle){
    fliperRotationSpeedLeft = 0;
  }
  
  fliperAngleRight = fliperAngleRight - fliperRotationSpeedRight * dt;
  fliperAngleRight = max(min(fliperAngleRight, maxFliperAngle), minFliperAngle);
  if (fliperAngleRight == maxFliperAngle || fliperAngleRight == minFliperAngle){
    fliperRotationSpeedRight = 0;
  }
  
  fliperPos1[2] = fliperPos1[0] + cos(radians(fliperAngleLeft)) * fliperLength;
  fliperPos1[3] = fliperPos1[1] + sin(radians(fliperAngleLeft)) * fliperLength;

  fliperPos2[2] = fliperPos2[0] - cos(radians(fliperAngleRight)) * fliperLength;
  fliperPos2[3] = fliperPos2[1] + sin(radians(fliperAngleRight)) * fliperLength;
}

void setup(){
  size(500, 500);
  deadBall = 0;
  bg = loadImage(fileName + ".JPG");
  bg.resize(500, 0);
  circleObstacle = loadImage("circleObstacle.png");
  background(0, 0, 0);
  image(bg, 0, 0, 500, 500);
  minim = new Minim(this);
  
  // Load the sound file
  playerBox = minim.loadFile("boxCollide.mp3");
  playerLoseBall = minim.loadFile("loseBall.mp3");
  playerBall = minim.loadFile("ballCollide.mp3");

  currentScore = 0;
  pos[0] = new Vec2(425, 425);
  vel[0] = new Vec2(0, 0);
  
  
  //Load the txt file into shapeDataMaphashmap
  String[] lines = loadStrings(fileName + ".txt");
  shapeObjects = new ArrayList<ShapeObject>();
  HashMap<String, String> IDMap = new HashMap<String, String>();
  int shapeCounter = 0;
  int numObject = 0;
  rectMode(CENTER);
  stroke(neonPink);
  fill(0, 0, 0, 0);
  strokeWeight(3);
  //Load scene file
  for (int i = 0; i < lines.length; i++){
    String line = lines[i].trim();
    if (detectAndSwitchHeader(line)){
      shapeCounter = 0;
    } else if (line.startsWith("#")){
      continue;
    } else {
      float[][] currentShapeData = shapeDataMap.get(currentShapeType);
      String[] lineParts = line.split(":")[1].trim().split(" ");
      String currentID = line.split(":")[0].trim().split(" ")[0];
      IDMap.put(currentID, currentShapeType + shapeCounter);
      ShapeObject currentObject = new ShapeObject(numObject, currentShapeType, float(lineParts));
      //currentObject.showInfo();
      currentObject.calculateAABB();
      shapeObjects.add(currentObject);
      numObject++;
      //println(numObject);
      for (int j = 0; j < lineParts.length; j++){
        currentShapeData[shapeCounter][j] = float(lineParts[j]);
      }
      shapeCounter++;
    }
  }
  //Setup initial ball
  sceneCD_BVH = new SceneCollisionDetectorBVH(shapeObjects);
}
void updatePhysics(float dt){
  for (int i = 0; i < maxParticles; i++){
    if (status[i] < 1 || status[i] == 3){
      continue;
    }
    if (status[i] == 1){
      if ((pos[i].x + ballRadius )/resizeFactor < 8){
        status[i] = 2;
      }
    }
    //println(status[i]);
    pos[i].add(vel[i].times(dt));
    //println(g.y);
    if (status[i] == 2){
      vel[i].add(g.times(dt));
    }
    if (vel[i].length() > velMax){
      vel[i].normalize();
      vel[i].mul(velMax);
    }
    //println(pos[0].x,pos[0].y);
    float[] currentShapeInfo = {pos[i].x/resizeFactor, pos[i].y/resizeFactor, ballRadius/resizeFactor};
    ShapeObject currentObject = new ShapeObject(-1, "Circles", currentShapeInfo);
    currentObject.calculateAABB();
    if (status[i] == 2 && lineCircleCollisionDetection(finishLine, currentShapeInfo)){
      status[i] = 3;
      println("Ball:", i+1, "lose control!!!");
      playerLoseBall.rewind();
      playerLoseBall.play();
      deadBall++;
    }
    if (status[i] == 2 && lineCircleCollisionDetection(gateInfo, currentShapeInfo)){
      println("Go back");
      Vec2 velChange = velocityChange("Lines", gateInfo, currentShapeInfo, vel[i]);
      pos[i].subtract(vel[i].times(1.05*dt));
      //vel[i].x = - vel[i].x;
      if (dot(velChange, vel[i]) >= 0){
        vel[i].subtract(velChange);
      } else {
        vel[i].add(velChange);
      }
    } else if (sceneCD_BVH.checkCollision(currentObject)){
      //println("Collide!!");
      //println("Collision id:", sceneCD_BVH.currentCollideInId);
      //println("Collision shape:", sceneCD_BVH.currentCollideInShape);
      Vec2 velChange = velocityChange(sceneCD_BVH.currentCollideInShape, sceneCD_BVH.currentCollideInShapeInfo, currentShapeInfo, vel[i]);
      pos[i].subtract(vel[i].normalized().times(ballRadius));
      //println(velChange.x, velChange.y);
      if (dot(velChange, vel[i]) >= 0){
        vel[i].subtract(velChange);
      } else {
        vel[i].add(velChange);
      }
      
    } else if (lineCircleCollisionDetection(fliperPos1, currentShapeInfo)){
      Vec2 velChange = velocityChange("Lines", fliperPos1, currentShapeInfo, vel[i]);
      Vec2 closestPoint = new Vec2(clamp(currentShapeInfo[0], fliperPos1[0], fliperPos1[2]), clamp(currentShapeInfo[1], fliperPos1[1], fliperPos1[3]));
      Vec2 radius = new Vec2(closestPoint.x - fliperPos1[0], closestPoint.y - fliperPos1[1]);
      Vec2 colVel = radius.normalized();
      colVel = new Vec2(-radius.y, radius.x);
      colVel.mul(fliperRotationSpeedLeft);

      
      velChange.mul(1.5);
      println(colVel);
      println(velChange);
      if (dot(velChange, colVel) >= 0){
        velChange.add(colVel);
      } else {
        velChange.subtract(colVel);
      }
      pos[i].subtract(vel[i].normalized().times(1.5*ballRadius));
      //println(velChange.x, velChange.y);
      if (dot(velChange, vel[i]) >= 0){
        vel[i].subtract(velChange);
      } else {
        vel[i].add(velChange);
      }
    } else if (lineCircleCollisionDetection(fliperPos2, currentShapeInfo)){
      Vec2 velChange = velocityChange("Lines", fliperPos2, currentShapeInfo, vel[i]);
      Vec2 closestPoint = new Vec2(clamp(currentShapeInfo[0], fliperPos2[0], fliperPos2[2]), clamp(currentShapeInfo[1], fliperPos2[1], fliperPos2[3]));
      Vec2 radius = new Vec2(closestPoint.x - fliperPos2[0], closestPoint.y - fliperPos2[1]);
      Vec2 colVel = radius.normalized();
      colVel = new Vec2(-radius.y, radius.x);
      colVel.mul(fliperRotationSpeedLeft);
      
      velChange.mul(1.5);
      if (dot(velChange, colVel) >= 0){
        velChange.add(colVel);
      } else {
        velChange.subtract(colVel);
      }
      pos[i].subtract(vel[i].normalized().times(1.5*ballRadius));
      //println(velChange.x, velChange.y);
      if (dot(velChange, vel[i]) >= 0){
        vel[i].subtract(velChange);
      } else {
        vel[i].add(velChange);
      }
    }
    // Update ball-ball collision
    for (int j = i + 1; j < maxParticles; j++){
      if (status[j] < 1 || status[j] == 3){
        continue;
      }
      Vec2 delta = pos[i].minus(pos[j]);
      float dist = delta.length();
      if (dist < ballRadius + ballRadius){
        // Move balls out of collision
        float overlap = 0.5f * (dist - ballRadius - ballRadius);
        pos[i].subtract(delta.normalized().times(overlap));
        pos[j].add(delta.normalized().times(overlap));
        Vec2 dir = delta.normalized();
        float v1 = dot(vel[i], dir);
        float v2 = dot(vel[j], dir);
        float m1 = 1;
        float m2 = 1;

        float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
        float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
        vel[i].add(dir.times(new_v1-v1));
        vel[j].add(dir.times(new_v2-v2));
      }
    }
  }
  
}

Vec2 velocityChange(String shapeType, float[] shapeInfo, float[] ballInfo, Vec2 ballVelocity){
  Vec2 collideDir;
  Vec2 velChange;
  switch(shapeType){
  case "Lines":
  stroke(shinyBlue);
  fill(shinyBlue);
  strokeWeight(10);
  line(shapeInfo[0] * resizeFactor, shapeInfo[1] * resizeFactor, shapeInfo[2] * resizeFactor, shapeInfo[3] * resizeFactor);
  Vec2 line = new Vec2(shapeInfo[0] - shapeInfo[2], shapeInfo[1] - shapeInfo[3]);
  Vec2 normLine = line.normalized();
  collideDir = new Vec2(-normLine.y, normLine.x);
  velChange = projAB(ballVelocity, collideDir);
  velChange.mul(1.5);
  currentScore += 10;
  return velChange;
  case "Circles":
  collideDir = new Vec2(ballInfo[0] - shapeInfo[0], ballInfo[1] - shapeInfo[1]);
  collideDir.normalize();
  velChange = projAB(ballVelocity, collideDir);
  velChange.mul(2.5);
  currentScore += 20;
  playerBall.rewind();
  playerBall.play();
  return velChange;
  case "Boxes":
  stroke(darkBlue2);
  fill(shinyBlue);
  strokeWeight(5);
  rect(shapeInfo[0] * resizeFactor, shapeInfo[1] * resizeFactor, shapeInfo[2] * resizeFactor, shapeInfo[3] * resizeFactor);
  playerBox.rewind();
  playerBox.play();
  Vec2 closestPoint = new Vec2(clamp(ballInfo[0], shapeInfo[0] - shapeInfo[2]/2, shapeInfo[0] + shapeInfo[2]/2), clamp(ballInfo[1], shapeInfo[1] - shapeInfo[3]/2, shapeInfo[1] + shapeInfo[3]/2));
  collideDir = new Vec2(ballInfo[0] - closestPoint.x, ballInfo[1] - closestPoint.y); 
  //println(collideDir);
  collideDir.normalize();
  //println(collideDir);
  velChange = projAB(ballVelocity, collideDir);
  velChange.mul(2);
  currentScore += 50;
  return velChange;
  default:
  return null;
  }
}

void draw(){
  background(0, 0, 0);
  image(bg, 0, 0, 500, 500);
  if (deadBall == maxParticles){
    fill(57, 255, 20);
    textSize(32); // Set text size to 32 pixels
    text("Score: " + currentScore, 180, 250); // Position text at (10, 32)
    return;
  }
  stroke(transparentGreen);
  fill(0, 0, 0, 0);
  strokeWeight(3);
  drawBasedOnShape("Gate", gateInfo);
  drawBasedOnShape("Fliper", fliperPos1);
  drawBasedOnShape("Fliper", fliperPos2);
  
  drawObstacles();
  updateFliper(1.0/frameRate);
  updatePhysics(1.0/frameRate);
  stroke(color(255, 255, 255, 0));
  fill(255, 255, 255, 200);
  strokeWeight(3);
  if (currentBall < maxParticles){
    ellipse(425, 425, 20, 20);
  }
  for (int i = 0; i < currentBall; i++) {
    if (status[i] == 3){
      continue;
    }
    ellipse(pos[i].x, pos[i].y, 20, 20);
  }
  fill(57, 255, 20);
  textSize(32); // Set text size to 32 pixels
  text("Score: " + currentScore, 10, 30); // Position text at (10, 32)
  textSize(32); // Set text size to 32 pixels
  text("Ball Left: " + (maxParticles - deadBall), 350, 30); // Position text at (10, 32)
}
boolean leftPressed, rightPressed;
void keyPressed(){
  if (key == ' ' && currentBall < maxParticles){
    if (currentBall == 0){
      println("Game Begin");
    }
    currentBall++;
    if (currentBall <= maxParticles){
      println("New ball added:", currentBall, "/", maxParticles);
      status[currentBall - 1] = 1;
      vel[currentBall - 1] = new Vec2(0, -random(200) - 800);
      pos[currentBall - 1] = new Vec2(425, 425);
    }
    
  } 
  if (key == 'r' && deadBall == maxParticles) {
    currentBall = 0;
    currentScore = 0;
    deadBall = 0;
  }
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
}

void keyReleased(){
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
}
