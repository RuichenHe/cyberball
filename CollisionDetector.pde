//Collision Detection Library
//Ruichen He <he000239@umn.edu>

boolean boxBoxCollisionDetection(float[] box1Info, float[] box2Info){
  //If |y2-y1| <= (h1+h2)/2 && |x2-x1| <= (w1+w2)/2, two box collides.
  return abs(box1Info[0]-box2Info[0]) <= (box1Info[2]+box2Info[2])/2 && abs(box1Info[1]-box2Info[1]) <= (box1Info[3]+box2Info[3])/2;
}

boolean boxCircleCollisionDetection(float[] boxInfo, float[] circleInfo){
  // By this method, if the circle is inside box, or box is inside circle, it will consided collided
  Vec2 closestPoint = new Vec2(clamp(circleInfo[0], boxInfo[0] - boxInfo[2]/2, boxInfo[0] + boxInfo[2]/2), clamp(circleInfo[1], boxInfo[1] - boxInfo[3]/2, boxInfo[1] + boxInfo[3]/2));
  return closestPoint.minus(new Vec2(circleInfo[0], circleInfo[1])).sqrLength() < circleInfo[2] * circleInfo[2];
}

boolean lineLineCollisionDetection(float[] line1Info, float[] line2Info){
  //Detect the collision based on the direction of the product of two vectors
  Vec2 line1 = new Vec2(line1Info[2]-line1Info[0], line1Info[3]-line1Info[1]);
  Vec2 line2 = new Vec2(line2Info[2]-line2Info[0], line2Info[3]-line2Info[1]);
  return prod(line1, new Vec2(line2Info[0] - line1Info[0], line2Info[1] - line1Info[1])) * prod(line1, new Vec2(line2Info[2] - line1Info[0], line2Info[3] - line1Info[1])) <= 0 &&
  prod(line2, new Vec2(line1Info[0] - line2Info[0], line1Info[1] - line2Info[1])) * prod(line2, new Vec2(line1Info[2] - line2Info[0], line1Info[3] - line2Info[1])) <= 0;
}

boolean lineCircleCollisionDetection(float[] lineInfo, float[] circleInfo){
  //Based on class activity CCD method, slightly adjustment to solve several issues
  Vec2 l_start = new Vec2(lineInfo[0], lineInfo[1]);
  Vec2 line = new Vec2(lineInfo[2]-lineInfo[0], lineInfo[3] - lineInfo[1]);
  Vec2 l_dir = line.normalized();
  float l_len = line.length();
  Vec2 circle = new Vec2(circleInfo[0], circleInfo[1]);
  Vec2 toCircle = circle.minus(l_start);
  float a = 1;  //Lenght of l_dir (we noramlized it)
  float b = -2*dot(l_dir,toCircle);
  float c = toCircle.sqrLength() - circleInfo[2] * circleInfo[2]; //different of squared distances
  float d = b*b - 4*a*c; //discriminant 
  if (d >=0 ){ 
    float sqrt_d = sqrt(d);
    float t1 = (-b - sqrt_d)/(2*a);
    if (t1 > 0 && t1 < l_len){
      return true;
    } else {
      t1 = (-b + sqrt_d)/(2*a);
      if (t1 > 0 && t1 < l_len){
        return true;
      }
    }
  }
  return false;
}

boolean boxLineCollisionDetection(float[] boxInfo, float[] lineInfo){
  //Use the 4 line-line collision detection to detect line-box collision
  Vec2 point1 = new Vec2(boxInfo[0] - boxInfo[2]/2, boxInfo[1] - boxInfo[3]/2);
  Vec2 point2 = new Vec2(boxInfo[0] + boxInfo[2]/2, boxInfo[1] - boxInfo[3]/2);
  Vec2 point3 = new Vec2(boxInfo[0] + boxInfo[2]/2, boxInfo[1] + boxInfo[3]/2);
  Vec2 point4 = new Vec2(boxInfo[0] - boxInfo[2]/2, boxInfo[1] + boxInfo[3]/2);
  float[] boxLine1 = {point1.x, point1.y, point2.x, point2.y};
  float[] boxLine2 = {point2.x, point2.y, point3.x, point3.y};
  float[] boxLine3 = {point3.x, point3.y, point4.x, point4.y};
  float[] boxLine4 = {point4.x, point4.y, point1.x, point1.y};
  return lineLineCollisionDetection(lineInfo, boxLine1) || lineLineCollisionDetection(lineInfo, boxLine2) || 
  lineLineCollisionDetection(lineInfo, boxLine3) || lineLineCollisionDetection(lineInfo, boxLine4);
}

boolean circleCircleCollisionDetection(float[] circle1Info, float[] circle2Info){
  //Calculate the distance between two circles' center. Inner circle will be considered as collisions. 
  Vec2 r1r2 = new Vec2(circle1Info[0] - circle2Info[0], circle1Info[1] - circle2Info[1]);
  return r1r2.sqrLength() < (circle1Info[2] + circle2Info[2]) * (circle1Info[2] + circle2Info[2]);
}

float clamp(float value, float min, float max) {
  if (value < min) {
    return min;
  } else if (value > max) {
    return max;
  } else {
    return value;
  }
}
