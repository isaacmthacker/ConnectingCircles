class Circle {
  float x, y, r;
  color c;
 Circle(float xx, float yy, float rr, color cc) {
   x = xx;
   y = yy;
   r = rr;
   c = cc;
 }
 void display() {
   stroke(0);
   fill(c);
   //ellipse drawing using width, not radius
   ellipse(x, y, 2*r, 2*r);
 }
 
 float distance(Circle c) {
   return dist(x, y, c.x, c.y);
 }
 boolean intersect(Circle c) {
   //println("dist: ", distance(c), c.r+r, "cr: ", c.r, "r: ", r);
   return distance(c) <= (c.r+r);
 }
 
 void print() {
   println(x, y, r);
 }
  
}
