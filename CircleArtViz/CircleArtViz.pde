class Rect {
  //top left corner
  float x, y, w, h;
  color c;
  int colorIdx;
  Rect(float xx, float yy, float ww, float hh) {
    x = xx;
    y = yy;
    w = ww;
    h = hh;
    c = color(255, 0, 0);
    colorIdx = 0;
  }
  boolean intersect() {
    return (x <= mouseX && mouseX <= (x+w)) && (y <= mouseY && mouseY <= (y+h));
  }
  void display() {
    fill(c);
    rect(x, y, w, h);
  }
}

int activeRect = 0;
int activeColorIdx = 58;

HashMap<Integer, String> colorLookup; 

color[] crayonColors = {#CD4A4A, #CC6666, #BC5D58, #FF5349, 
  #FD5E53, #FD7C6E, #FDBCB4, #FF6E4A, #FFA089, #EA7E5D, 
  #B4674D, #A5694F, #FF7538, #FF7F49, #DD9475, #FF8243, 
  #FFA474, #9F8170, #CD9575, #EFCDB8, #D68A59, #DEAA88, 
  #FAA76C, #FFCFAB, #FFBD88, #FDD9B5, #FFA343, #EFDBC5, 
  #FFB653, #E7C697, #8A795D, #FAE7B5, #FFCF48, #FCD975, 
  #FDDB6D, #FCE883, #F0E891, #ECEABE, #BAB86C, #FDFC74, 
  #FDFC74, #FFFF99, #C5E384, #B2EC5D, #87A96B, #A8E4A0, 
  #1DF914, #76FF7A, #71BC78, #6DAE81, #9FE2BF, #1CAC78, 
  #30BA8F, #45CEA2, #3BB08F, #1CD3A2, #17806D, #158078, 
  #1FCECB, #78DBE2, #77DDE7, #80DAEB, #414A4C, #199EBD, 
  #1CA9C9, #1DACD6, #9ACEEB, #1A4876, #1974D2, #2B6CC4, 
  #1F75FE, #C5D0E6, #B0B7C6, #5D76CB, #A2ADD0, #979AAA, 
  #ADADD6, #7366BD, #7442C8, #7851A9, #9D81BA, #926EAE, 
  #CDA4DE, #8F509D, #C364C5, #FB7EFD, #FC74FD, #8E4585, 
  #FF1DCE, #FF1DCE, #FF48D0, #E6A8D7, #C0448F, #6E5160, 
  #DD4492, #FF43A4, #F664AF, #FCB4D5, #FFBCD9, #F75394, 
  #FFAACC, #E3256B, #FDD7E4, #CA3767, #DE5D83, #FC89AC, 
  #F780A1, #C8385A, #EE204D, #FF496C, #EF98AA, #FC6C85, 
  #FC2847, #FF9BAA, #CB4154, #EDEDED, #DBD7D2, #CDC5C2, #95918C, #232323};

float[] sizes;
//ArrayList<Circle> circles;
ArrayList<Ring> rings;
color[] colors;

ArrayList<Rect> rects;

int numPoints = 32;

void setup() {
  size(960, 720);
  //sizes = new float[] {0.25, 0.5, 0.75, 1.0};
  //circles = new ArrayList<Circle>();
  rings = new ArrayList<Ring>();



  colors = new color[]{
    //color(31, 117, 254), //blue
    //color(25, 158, 189), //blue green
    //color(  29, 172, 214), //Cerulean
    //color(  128, 218, 235)             //sky blue

    color(62, 100, 255), 
    color(94, 223, 255), 
    color(178, 252, 255), 
    color(236, 252, 255), 
  };


  //middle
  CreateCircleRings(rings, height/3.0/2.0, 5, colors, width/2.0, height/2.0);

  //above and below
  CreateCircleRings(rings, height/3.0/2.0, 5, colors, width/2.0, height/6.0);
  CreateCircleRings(rings, height/3.0/2.0, 5, colors, width/2.0, 5*height/6.0);

  //left and right
  CreateCircleRings(rings, height/3.0/2.0, 5, colors, width/2.0-height/3.0, height/2.0);
  CreateCircleRings(rings, height/3.0/2.0, 5, colors, width/2.0+height/3.0, height/2.0);


  //diag
  CreateCircleRings(rings, height/3.0/2.0/2.0-10, 4, colors, width/2.0+height/3.0/2.0, height/2.0-height/3.0/2.0);
  CreateCircleRings(rings, height/3.0/2.0/2.0-10, 4, colors, width/2.0-height/3.0/2.0, height/2.0+height/3.0/2.0);
  CreateCircleRings(rings, height/3.0/2.0/2.0-10, 4, colors, width/2.0+height/3.0/2.0, height/2.0+height/3.0/2.0);
  CreateCircleRings(rings, height/3.0/2.0/2.0-10, 4, colors, width/2.0-height/3.0/2.0, height/2.0-height/3.0/2.0);
  println(rings.get(0).r, rings.get(0).t);



  println(rings.size());

  colorLookup = new HashMap<Integer, String>();
  String[] lines = loadStrings("colors.csv");
  //skip header
  crayonColors = new color[lines.length-1];
  for (int i = 1; i < lines.length; ++i) {
    String[] parts = lines[i].split(",");
    String colorName = parts[0];
    color colorVal = unhex("FF" + parts[1]);
    //println(colorName, colorVal);
    crayonColors[i-1] = colorVal;
    colorLookup.put(colorVal, colorName);
  }


  rects = new ArrayList<Rect>();
  rects.add(new Rect(0, 0, width, height/4.0));
  rects.add(new Rect(0, height/4.0, width, height/4.0));
  rects.add(new Rect(0, 2*height/4.0, width, height/4.0));
  rects.add(new Rect(0, 3*height/4.0, width, height/4.0));




  println(colors.length);
}


float XtoInches(float x) {
  return x/40.0;
}
float XtoCentimeters(float x) {
  return XtoInches(x)*2.54;
}

color getClosestColor(color c) {
  float minDiff = colorDiff(c, crayonColors[0]);
  int minIdx = 0;
  for (int ci = 1; ci < crayonColors.length; ++ci) {
    float diff = colorDiff(c, crayonColors[ci]);
    if (diff < minDiff) {
      minDiff = diff;
      minIdx = ci;
    }
  }
  return crayonColors[minIdx];
}
long colorVal(color c) {
  long ret = 0;
  ret |= int(alpha(c));
  ret <<= 8;
  ret |= int(red(c));
  ret <<= 8;
  ret |= int(green(c));
  ret <<= 8;
  ret |= int(blue(c)); 
  return ret;
}
color longToColor(long l) {
  int blue = int(l&0xFF);
  l >>= 8;
  int green = int(l&0xFF);
  l >>= 8;
  int red = int(l&0xFF);
  return color(red, green, blue);
}
float colorDiff(color c1, color c2) {
  float redDiff = (red(c1)-red(c2))*0.75;//*0.39;
  float greenDiff = (green(c1)+5-green(c2));//*0.59;
  float blueDiff = (blue(c1)-blue(c2))*0.5;//*0.11;
  return (redDiff*redDiff)+(greenDiff*greenDiff)+(blueDiff*blueDiff);
}
String colorToString(color c) {
  return red(c) + "," + green(c) + "," + blue(c);
}



void draw() {
  background(255);
  for (Ring r : rings) {
    r.display();
  }

  //for (Rect r : rects) {
  //  r.display();
  //}
}

void CreateCircleRings(ArrayList<Ring> rings, float r, int numRings, color[] colors, float midX, float midY) {
  int i = 0;
  //CreateCircleUnknownT(rings, r, 32, colors[i%colors.length], midX, midY);
  float firstR = FindNextCircle(new Circle(midX+r, midY, 0, color(0)), 32, midX, midY);
  CreateCircleUnknownT(rings, firstR, numPoints, colors[i%colors.length], midX, midY);
  ++i;
  float r2 = r;
  println(numRings);
  for (int j = 0; j < numRings-1; ++j) {
    //r2 = FindNextCircle(circles.get(circles.size()-32), 32, midX, midY);
    r2 = FindNextCircle(rings.get(rings.size()-1).get(0), 32, midX, midY);
    CreateCircleUnknownT(rings, r2, numPoints, colors[i%colors.length], midX, midY);
    ++i;
  }
}




//cos(q) = 1-((2*t*t)/(r*r))
//q = delta angle
//t = size of circles 
//r = size of big circle

void CreateCircleUnknownQ(ArrayList<Ring> rings, float r, float t, color cc, float midX, float midY) {
  float q = acos(1-((2*t*t)/(r*r)));
  int num = int(2*PI/q);
  //println("Q:", q, num);
  CreateCircle(rings, r, t, q, num, cc, midX, midY);
}
void CreateCircleUnknownT(ArrayList<Ring> rings, float r, int num, color cc, float midX, float midY) {
  float q = 2*PI/float(num);
  float t = sqrt((r*r*(1-cos(q)))/2.0);
  CreateCircle(rings, r, t, q, num, cc, midX, midY);
}
void CreateCircleUnknownR(ArrayList<Ring> rings, float t, int num, color cc, float midX, float midY) {
  float q = 2*PI/float(num);
  float r = sqrt((2*t*t)/(1-cos(q)));
  CreateCircle(rings, r, t, q, num, cc, midX, midY);
}


void CreateCircle(ArrayList<Ring> rings, float r, float t, float q, int num, color cc, float midX, float midY) {
  float x, y;
  //println("Create circle: ", r, t, q, num); 

  Ring curRing = new Ring(r, t, num);

  float a = 0.0;
  for (int i = 0; i < num; ++i) {
    x = r*cos(a)+midX;
    y = r*sin(a)+midY;
    //circles.add(new Circle(x, y, t, cc));
    curRing.Add(new Circle(x, y, t, cc));
    a += q;
  }

  rings.add(curRing);
}
//for unknown q: q = acos(1-t^2/2r^2)
//for unknown r: r = sqrt(t^2 / (2 - 2cos(q)))
//for unknown t: t = sqrt(2r^2 * (1 - cos(q)))

//cos(q) = 1-(t/(r*r))
//q = acos(1-(t/(r*r)))
//r = sqrt(t/(1-cos(q)))
//t = r*r*(1-cos(q))


//last circle at angle=0
float FindNextCircle(Circle lastCircle, int num, float midX, float midY) {
  float r, t, q;
  Circle c;
  r = lastCircle.x-midX-lastCircle.r;
  q = 2*PI/float(num);
  t = 0;
  println(r, t, q);
  float rstep = 0.001;
  boolean found = false;
  while (!found) {
    t = sqrt((r*r*(1-cos(q)))/2.0);
    //println(r, t, lastCircle.r);
    c = new Circle(r*cos(0)+midX, r*sin(0)+midY, t, color(0, 0, 0));
    //println(dist(c.x, c.y, lastCircle.x, lastCircle.y), c.distance(lastCircle), t+lastCircle.r);
    if (!c.intersect(lastCircle)) {
      found = true;
      break;
    }
    r -= rstep;
    if (r <= 10) {
      println("hit base case");
      break;
    }
  }
  println("final: ", r, t, q);
  return r;
}


void keyPressed() {
  //37 left, 39 right
  int idxChange = 0;
  if (keyCode == 37) {
    idxChange = -1;
  } else if (keyCode == 39) {
    idxChange = 1;
  }
  activeColorIdx += idxChange;
  activeColorIdx %= crayonColors.length;
  if (activeColorIdx < 0) {
    activeColorIdx = 0;
  }
  println(hex(crayonColors[activeColorIdx]), colorLookup.get(crayonColors[activeColorIdx]), activeColorIdx);
  rects.get(activeRect).c = crayonColors[activeColorIdx];
}

void mousePressed() {
  println(mouseX, mouseY);
  for (Ring r : rings) {
    boolean intersect = false;
    for (Circle c : r.circles) {
      if (c.intersect(new Circle(mouseX, mouseY, 0, color(0)))) {
        println("circle: ", c.r, XtoInches(c.r), "d: ", XtoInches(2.0*c.r), " ");
        println("circle (cm): ", c.r, "r: ", XtoCentimeters(c.r), "d: ", XtoCentimeters(2.0*c.r), " ");
        //c.print();
        intersect = true;
        break;
      }
    }
    if (intersect) {
      println("ring", r.r, "r:", XtoInches(r.r), "in d: ", XtoInches(2*r.r), "in ", XtoInches(r.r+r.circles.get(0).r));
      println("ring (cm)", r.r, "r:", XtoCentimeters(r.r), "cm d: ", XtoCentimeters(2*r.r), "cm ");
      line(width/2.0, height/2.0, width/2.0+r.r, height/2.0);
    }
  }
}
