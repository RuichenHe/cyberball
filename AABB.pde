//AABB class, will be use in BVH class
//Ruichen He <he000239@umn.edu>


public class AABB{
  public Vec2 p1;
  public Vec2 p2;
  private float[] bbox;
  public AABB(Vec2 p1, Vec2 p2){
    this.p1 = p1;
    this.p2 = p2;
  }
  public float[] getAABBInfo(){
    //Get the xc, yc, w, h from p1 and p2
    float[] bbox = {(p1.x + p2.x)/2, (p1.y + p2.y)/2, abs(p1.x - p2.x), abs(p1.y - p2.y)};
    this.bbox = bbox;
    return bbox;
  }
  public boolean isNotOverlap(AABB other) {
    return (this.p2.x < other.p1.x || this.p1.x > other.p2.x || this.p2.y < other.p1.y || this.p1.y > other.p2.y);
  }
}

AABB merge(AABB a, AABB b) {
  if (a != null && b != null){
    Vec2 p1 = new Vec2(min(a.p1.x, b.p1.x), min(a.p1.y, b.p1.y));
    Vec2 p2 = new Vec2(max(a.p2.x, b.p2.x), max(a.p2.y, b.p2.y));
    AABB newAABB = new AABB(p1, p2);
    return newAABB;
  } else if (a == null) {
    return b;
  } else {
    return a;
  }
}
