class Ring {
  ArrayList<Circle> circles;
  float r;
  float t;
  int n;
  Ring(float rr, float tt, int nn) {
    circles = new ArrayList<Circle>();
    r = rr;
    t = tt;
    n = nn;
  }
  
  void Add(Circle c) {
    circles.add(c);
  }

  Circle get(int i) {
    return circles.get(i);
  }

  void display() {
    for (Circle c : circles) {
      c.display();
    }
  }
}
