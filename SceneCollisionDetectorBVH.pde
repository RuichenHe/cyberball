//Scene Object Collision Detection Library using BVH for acceleration
//Ruichen He <he000239@umn.edu>

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.File;

public class SceneCollisionDetectorBVH{
  public ArrayList<ShapeObject> objectList;
  public float duration;
  public int[] collisionList;
  public int totalCollisionNum;
  public int circleCollisionNum;
  public int lineCollisionNum;
  public int boxCollisionNum;
  public boolean isCurrentCollide;
  public int currentCollideInId;
  public String currentCollideInShape;
  public float[] currentCollideInShapeInfo;
  public SceneCollisionDetectorBVH(ArrayList<ShapeObject> objectList){
    this.objectList = objectList;
  }
  
  public boolean checkCollision(ShapeObject currentObject){
    BVH bvh = new BVH(this.objectList);
    bvh.detectSingleObjCollisoin(currentObject);
    if (bvh.isCurrentCollide){
      this.currentCollideInId = bvh.currentCollideInId;
      this.currentCollideInShape = bvh.currentCollideInShape;
      this.currentCollideInShapeInfo = bvh.currentCollideInShapeInfo;
      return true;
    } else {
      return false;
    }
  }
  public void getAllCollision(){
    this.totalCollisionNum = 0;
    this.circleCollisionNum = 0;
    this.lineCollisionNum = 0;
    this.boxCollisionNum = 0;
    long startTime;
    long finishTime;
    startTime = System.nanoTime();
    BVH bvh = new BVH(this.objectList); // Initilize the BVH using the shapeobject list
    finishTime = System.nanoTime();
    println("BVH initilized, spent time:", (float)(finishTime - startTime)/1000000, "ms");
    startTime = System.nanoTime();
    for (int i = 0; i < this.objectList.size(); i++){
      bvh.detectSingleObjCollisoin(this.objectList.get(i));
    }
    finishTime = System.nanoTime();
    this.duration = (float)(finishTime - startTime)/1000000;
    println("Collision detection finished for BVH...");
    this.collisionList = bvh.collisionList;
    for (int i = 0; i < this.collisionList.length; i++){
      this.totalCollisionNum = this.totalCollisionNum + this.collisionList[i];
    }
  }
  
  public void checkResultLocation(String resultFolder){
    File folder = new File(resultFolder);
    if (!folder.exists()) {
      if (folder.mkdirs()) {
        println("Solutions folder was created!");
      } else {
        println("Solutions folderFailed to create folder.");
      }
    } else {
      println("Solutions folder already exists.");
    }
  }
  
  public void writeDetectionResult(String resultFileName){
    try{
      FileWriter writer = new FileWriter(resultFileName);
      BufferedWriter bufferedWriter = new BufferedWriter(writer);
      println("Duration: " + this.duration + " ms");
      bufferedWriter.write("Duration: " + this.duration + " ms");
      bufferedWriter.newLine();
      println("Num Collisions: " + this.totalCollisionNum);
      bufferedWriter.write("Num Collisions: " + this.totalCollisionNum);
      bufferedWriter.newLine();
      for (int i = 0; i < this.collisionList.length; i++){
        if (this.collisionList[i] == 1){
          bufferedWriter.write(""+i);
          bufferedWriter.newLine();
        }
      }
      bufferedWriter.close();
      println("Result has been saved in: ", resultFileName);
    }
    catch (IOException e){
      e.printStackTrace();
      }
  }
  public void visualizeResult(){
    for (int i = 0; i < this.objectList.size(); i++){
      if (this.collisionList[this.objectList.get(i).ID] == 1){
        stroke(255, 0, 0);
        switch (this.objectList.get(i).shapeType){
          case "Lines":
          this.lineCollisionNum++;
          break;
          case "Boxes":
          this.boxCollisionNum++;
          break;
          case "Circles":
          this.circleCollisionNum++;
          break;
          default:
          break;
          
        }
      } else {
        stroke(0, 0, 0);
      }
      drawBasedOnShape(this.objectList.get(i).shapeType, this.objectList.get(i).objectInfo);
    }
    println("Circles Colliding: ", this.circleCollisionNum);
    println("Boxes Colliding: ", this.boxCollisionNum);
    println("Lines Colliding: ", this.lineCollisionNum);
  }
}

class BVH {
  public BVHNode root;
  public ShapeObject currentCollision;
  public int[] collisionList; //If collision, will be 1
  public boolean isCurrentCollide = false;
  public int currentCollideInId;
  public String currentCollideInShape;
  public float[] currentCollideInShapeInfo;
  public BVH(ArrayList<ShapeObject> objects) {
    root = build(objects);
    this.collisionList = new int[objects.size()];
  }
  private BVHNode build(ArrayList<ShapeObject> objects){
    if (objects.size() == 0) {
      return null;
    }
    if (objects.size() == 1) {
      return new BVHNode(objects.get(0).objectAABB, objects.get(0));
    }
    //Use median number split along x to split the list, it can be potentially optimized by switching between x and y
    objects.sort((o1, o2) -> Float.compare(o1.xc, o2.xc));
    int medianNum = objects.size() / 2;
    ArrayList<ShapeObject> leftObjects = new ArrayList<ShapeObject>(objects.subList(0, medianNum));
    ArrayList<ShapeObject> rightObjects = new ArrayList<ShapeObject>(objects.subList(medianNum, objects.size()));
    BVHNode left = build(leftObjects);
    BVHNode right = build(rightObjects);
    return new BVHNode(left, right);
  }
  private boolean collisionDetection(ShapeObject obj1, ShapeObject obj2){
    boolean isCollide;
    if (obj1.shapeType == "Boxes"){
      switch (obj2.shapeType) {
        case "Boxes":
        isCollide = boxBoxCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        case "Circles":
        isCollide = boxCircleCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        case "Lines":
        isCollide = boxLineCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        default:
        println(obj2.shapeType);
        println("Shape info error");
        return false;
      }
    } else if (obj1.shapeType == "Lines"){
      switch (obj2.shapeType) {
        case "Boxes":
        isCollide = boxLineCollisionDetection(obj2.objectInfo, obj1.objectInfo);
        return isCollide;
        
        case "Lines":
        isCollide = lineLineCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        case "Circles":
        isCollide = lineCircleCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        default:
        println(obj2.shapeType);
        println("Shape info error");
        return false;
      }
    } else if (obj1.shapeType == "Circles"){
      switch (obj2.shapeType) {
        case "Boxes":
        isCollide = boxCircleCollisionDetection(obj2.objectInfo, obj1.objectInfo);
        return isCollide;
        
        case "Lines":
        isCollide = lineCircleCollisionDetection(obj2.objectInfo, obj1.objectInfo);
        return isCollide;
        
        case "Circles":
        isCollide = circleCircleCollisionDetection(obj1.objectInfo, obj2.objectInfo);
        return isCollide;
        
        default:
        println(obj2.shapeType);
        println("Shape info error");
        return false;
      }
    } else {
      return false;
    }
  }
  
  private void traverseAndCheck(BVHNode node, ShapeObject obj){
    if (node == null) {
      return;
    }
    if (node.bbox.isNotOverlap(obj.objectAABB)){
      return;
    }
    if (node.left == null && node.right == null){
      //Here we do collision detection
      boolean isCollide;
      if (obj.ID == node.shapeObject.ID){
        return;
      }
      isCollide = this.collisionDetection(obj, node.shapeObject);
      if (isCollide == true){
        this.isCurrentCollide = true;
        this.currentCollideInId = node.shapeObject.ID;
        this.currentCollideInShape = node.shapeObject.shapeType;
        this.currentCollideInShapeInfo = node.shapeObject.objectInfo;
        //println("Collision object info:", node.shapeObject.objectInfo);
        //this.collisionList[obj.ID] = 1;
        return;
        //println("Collision for ID:", obj.ID);
      }
    } else {
        // Otherwise, traverse the child nodes
        traverseAndCheck(node.left, obj);
        traverseAndCheck(node.right, obj);
    }
  }
  public void detectSingleObjCollisoin(ShapeObject obj){
    this.traverseAndCheck(this.root, obj);
  }
}

class BVHNode {
  public AABB bbox;
  public BVHNode left;
  public BVHNode right;
  public ShapeObject shapeObject;
  
  // Construct leaf node
  BVHNode(AABB bbox, ShapeObject shapeObject) {
    this.bbox = bbox;
    this.shapeObject = shapeObject;
    this.left = null;
    this.right = null;
  }

  // Construct internal node
  BVHNode(BVHNode left, BVHNode right) {
    this.left = left;
    this.right = right;
    this.bbox = merge(left.bbox, right.bbox);
  }
}
