//ShapeObject class using BVH for acceleration
//Ruichen He <he000239@umn.edu>

import java.util.Arrays;

public class ShapeObject{
  private int ID;
  private String shapeType = "";
  private float[] objectInfo;
  public AABB objectAABB;
  public float xc;
  public float yc;
  public ShapeObject(int ID, String shapeType, float[] objectInfo){
    this.ID = ID;
    this.shapeType = shapeType;
    this.objectInfo = objectInfo;
  }
  public void showInfo(){
    println("ID:", this.ID);
    println("Shape Type:", this.shapeType);
    println("Shape Detail", Arrays.toString(this.objectInfo));
  }
  public float[] getBBOXInfo(){
    //println("Get BBOX");
    float[] currentBBOX = this.objectAABB.getAABBInfo();
    
    return currentBBOX;
  }
  public void calculateAABB(){
    Vec2 p1;
    Vec2 p2;
    //println("Calculate AABB");
    switch (this.shapeType){
      case "Lines":
      p1 = new Vec2(min(this.objectInfo[0], this.objectInfo[2]), min(this.objectInfo[1], this.objectInfo[3]));
      p2 = new Vec2(max(this.objectInfo[0], this.objectInfo[2]), max(this.objectInfo[1], this.objectInfo[3]));
      xc = (p1.x + p2.x)/2;
      yc = (p1.y + p2.y)/2;
      break;
      case "Boxes":
      p1 = new Vec2(this.objectInfo[0] - this.objectInfo[2]/2, this.objectInfo[1] - this.objectInfo[3]/2);
      p2 = new Vec2(this.objectInfo[0] + this.objectInfo[2]/2, this.objectInfo[1] + this.objectInfo[3]/2);;
      xc = (p1.x + p2.x)/2;
      yc = (p1.y + p2.y)/2;
      break;
      case "Circles":
      p1 = new Vec2(this.objectInfo[0] - this.objectInfo[2], this.objectInfo[1] - this.objectInfo[2]);
      p2 = new Vec2(this.objectInfo[0] + this.objectInfo[2], this.objectInfo[1] + this.objectInfo[2]);;
      xc = (p1.x + p2.x)/2;
      yc = (p1.y + p2.y)/2;
      break;
      default:
      p1 = new Vec2(0, 0);
      p2 = new Vec2(0, 0);
      xc = (p1.x + p2.x)/2;
      yc = (p1.y + p2.y)/2;
      break;
    }
    this.objectAABB = new AABB(p1, p2);
  }
}
