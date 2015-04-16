// This is the function that tells whether a pixel is of 
// the desired color
boolean RightColor (color c) {
  /*int alpha = (c >> 24) & 0xFF; // Alpha
  int red   = (c >> 16) & 0xFF; // Can be either hue or red
  int green = (c >> 8)  & 0xFF; // Can be either saturation or green
  int blue  =  c        & 0xFF; // Can be either brightness or blue*/
  float hue=hue(c); 
  float saturation=saturation(c);
  float brightness=brightness(c);
  boolean hueFilter=(hue>=180/360*255&&hue<=(220/360*255));
  boolean saturationFilter=saturation>=0.5*255&&saturation<=1*255;
  boolean brightnessFilter=brightness>=0.3*255&&brightness<=1*255;
  return hueFilter&&brightnessFilter&&saturationFilter;
}

void DrawDebugInfo()
{
  //println("redHue:"+hue(color(255,0,0))+",greenHue:"+hue(color(0,255,0))/255*360+",blueHue:"+hue(color(0,0,255))/255*360);
  /*int j;
  for (SegmentList sl : foundComp) {
        //println("Actual Centroid "+str(j)+":"+sl.getCentroidX()+","+sl.getCentroidY());
        //println("Brute Centroid "+str(j)+":"+sl.getCentroidXBrute()+","+sl.getCentroidYBrute());
        println("Area "+str(j)+":"+sl.getArea());
        println("Perimeter "+str(j)+":"+sl.getPerimeter());
        println("Circularity "+str(j)+":"+sl.getCircularity());
        j++;
    }
    */
    /*if(tracking)
    {
      
      for (Rectangle r:trackingBounds)
      {
        println(r.toString());
      }
    }*/
    //println("Time taken"+j+":"+time);
    println ("Total Found Size:"+foundComp.size());
    println ("Total Size:"+comp.size());
}


// Rectangles to be tracked on the screen
ArrayList<Rectangle> trackingBounds;

void SetTrackingBounds()
{
  if (tracking)
  {
    int left=img.width,top=img.height,w=0,h=0;
    
    trackingBounds=new ConnectedRectangles();
    int mycounter=0;
    for (SegmentList sl:foundComp)
    {
     int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
     int estimatedRadius=(int)(radius*1.3);
     int currentLeft=sl.getCentroidX()-estimatedRadius;
     int currentTop=sl.getCentroidY()-estimatedRadius;
     left=max(0,min(left,currentLeft));
     top=max(0,min(top,currentTop));
     w=min(img.width,max(w,sl.getCentroidX()+estimatedRadius-left));
     h=min(img.height,max(h,sl.getCentroidY()+estimatedRadius-top));
     //Rectangle newRect=new Rectangle(left,top,w,h);

     //trackingBounds.add(newRect);
    } 
    Rectangle trackingRectangle=new Rectangle(left,top,w,h);
    trackingBounds.add(trackingRectangle);
    /*trackingBounds.sortYX();
    for (Rectangle r:trackingBounds)
    {
      println("X:"+r.getX()+",Y:"+r.getY()+",W:"+r.getWidth()+",H:"+r.getHeight());
    }
    trackingBounds.removeRepeated();
    for (Rectangle r:trackingBounds)
    {
      println("X:"+r.getX()+",Y:"+r.getY()+",W:"+r.getWidth()+",H:"+r.getHeight());
    }
    */
  }
}
void CreateComponents()
{    
    if (tracking)
    {
      comp = new Components (img,trackingBounds);
    }
    else
    {
      comp=new Components(img);
    }
}


void FindCircles()
{  
    int radius;
    float minCircularity;
    float minArea;
    float minPerimeter=minCirclePerimeter;
    float maxCircularity;
    float maxArea;
    float maxPerimeter=maxCirclePerimeter;
    int perimeter;
    int area;
    float circularity;
    foundComp=new Components();
    for (SegmentList sl : comp) {
      circularity=sl.getCircularity();
      area=sl.getArea();
      
      perimeter=sl.getPerimeter();
      radius=(int)CircleRadiusFromPerimeter(perimeter);
      
      minCircularity=AcceptableCircularity(radius,0.7);
      minArea=AcceptableArea(radius,0.7);
      maxCircularity=AcceptableCircularity(radius,1.3);
      maxArea=AcceptableArea(radius,1.3);
      if ((perimeter<=maxPerimeter)&&(perimeter>=minPerimeter)&&(area<=maxArea)&&(area>=minArea)&&(circularity<=maxCircularity)&&(circularity>=minCircularity))
      {
        foundComp.add(sl);
        // Limit to 3 first found objects
        if (foundComp.size()==3)
        {
          tracking=true;
          SetTrackingBounds();          
          break;
        }
      }
    }
    if(foundComp.size()!=3)
    {
      tracking=false;
    }
}
float ratioX=1;
float ratioY=1;;
void DrawMarkers()
{
    PFont f=createFont("Arial",16,true);
    //textFont(f,36);
    int j=0;
    int i=0;
    FillPallette(comp.size());
    for(SegmentList sl:comp)
    {
      stroke(pallette[i++]);
      for (Segment s:sl)
      {
        line(s.x0,s.y,s.x1,s.y);
      }
    }
    FillPallette(foundComp.size());
    for (SegmentList sl:foundComp)
    {
        int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
        fill(color(255,0,0,100));
        ellipse(ratioX*sl.getCentroidX(), ratioY*sl.getCentroidY(), ratioX*radius*2, ratioY*radius*2);
        text(radius,ratioX*sl.getCentroidX(),ratioY*sl.getCentroidY());
        
        fill(255);
        if (!usecam)
        {
        stroke (pallette[j]);
         for (Segment s : sl) 
          {
            line (ratioX*s.x0, ratioY*s.y, ratioX*s.x1, ratioY*s.y);
          }
        }
        j++; 
    }  
    if (foundComp.size()==3)
    {
      SegmentList leftEye,rightEye;
      if (foundComp.get(0).getCentroidX()<foundComp.get(1).getCentroidX())
      {
        rightEye=foundComp.get(0);
        leftEye=foundComp.get(1);
      }
      else
      {
        rightEye=foundComp.get(1);
        leftEye=foundComp.get(0);
      }
      SegmentList axisPoint=foundComp.get(2);
      int betweenEyesX=(int)(ratioX*(leftEye.getCentroidX()+rightEye.getCentroidX())/2);
      int betweenEyesY=(int)(ratioY*(leftEye.getCentroidY()+rightEye.getCentroidY())/2);
      stroke(color(255,0,0,255));
      
      line(ratioX*rightEye.getCentroidX(),ratioY*rightEye.getCentroidY(),ratioX*leftEye.getCentroidX(),ratioY*leftEye.getCentroidY());
      line(ratioX*leftEye.getCentroidX(),ratioY*leftEye.getCentroidY(),ratioX*axisPoint.getCentroidX(),ratioY*axisPoint.getCentroidY());
      line(ratioX*axisPoint.getCentroidX(),ratioY*axisPoint.getCentroidY(),ratioX*rightEye.getCentroidX(),ratioY*rightEye.getCentroidY());
      line(ratioX*axisPoint.getCentroidX(),ratioY*axisPoint.getCentroidY(),ratioX*betweenEyesX,ratioY*betweenEyesY);    
    }
    if(tracking)
    {
      println("bounds size:"+trackingBounds.size());
      fill(color(255,0,0,50));
      for (Rectangle r:trackingBounds)
      {
        rect(ratioX*r.getX(),ratioY*r.getY(),ratioX*r.getWidth(),ratioY*r.getHeight());
      }
    }
}

// Obtains a list of segments of pixel ranges in line y of the given
// image containing pixels of the 'right' color
SegmentList SegmentRow (PImage img, int y,Rectangle r) {
  SegmentList result = new SegmentList ();
  int x0,x;
  x0 = 0;
  boolean inside = false;
  for (x = (int)r.getX(); x < r.getX()+r.getWidth(); ++x) {
    boolean right = RightColor (img.get(x, y));
    if (right != inside) {
      if (inside) {
        result.add (new Segment (y, x0, x-1));
      } else {
        x0 = x;
      }
      inside = right;
    }
  }
  if (inside) {
    result.add (new Segment (y, x0, x-1));
  }
  return result;
}

SegmentList SegmentRow (PImage img, int y) {
  return SegmentRow(img,y,new Rectangle(0,0,img.width,img.height));
}

// Calculates area of a circle based on SegmentList's own method
int DiscreteCircleArea(int radius)
{
  SegmentList circle=new SegmentList();
  for (int y=-radius;y<=radius;y++)
  {
    int x1=(int)sqrt(radius*radius-y*y);
    int x0=-x1;
    Segment strip=new Segment(y,x0,x1);
    circle.add(strip);
  }
  return circle.getArea();
}

// Calculates perimeter of a circle based on SegmentList's own method
int DiscreteCirclePerimeter(int radius)
{
  SegmentList circle=new SegmentList();
  for (int y=-radius;y<=radius;y++)
  {
    int x1=(int)sqrt(radius*radius-y*y);
    int x0=-x1;
    Segment strip=new Segment(y,x0,x1);
    circle.add(strip);
  }
  return circle.getPerimeter();
}

// Calculates circularity of a circle based on SegmentList's own method
float DiscreteMaxCircularity(int radius)
{
  SegmentList circle=new SegmentList();
  for (int y=-radius;y<=radius;y++)
  {
    int x1=(int)sqrt(radius*radius-y*y);
    int x0=-x1;
    Segment strip=new Segment(y,x0,x1);
    circle.add(strip);
  }
  return circle.getCircularity();
}

// This function is not symmetrical in relation to a and b
boolean NearEqual(float a,float b,float delta,float factor)
{
  return abs(a-b*factor)<=delta;
}
boolean NearEqual(float a,float b,float delta)
{
  return NearEqual(a,b,delta,1);
}

float AcceptableArea(int radius,float ratio)
{
  return ratio*DiscreteCircleArea(radius);
}

float AcceptableCircularity(int radius,float ratio)
{
  return ratio*DiscreteMaxCircularity(radius);
}

// An approximation which allows the extraction of a radius
float CircleRadiusFromPerimeter(int perimeter)
{
  return perimeter/8;
}

// Fills the pallette with n colors, maintaining the ones already present
void FillPallette (int n) {
  int m = pallette.length;
  if (n > m)  {
    pallette = (color []) expand(pallette, n);
    for (int i = m; i < n; i++) {
       pallette [i] = color(random(255), random(255), random (255));
    }
  }
}

// Returns hue from RGB components
float HueFromRGB(int red,int green,int blue)
{
  float hue=degrees(atan2(sqrt(3)*(green-blue),2*red-green-blue)); // Treats red as 0, green as 120 and and blue as 240
  return (hue>=0)?(hue):(abs(hue)+120); // Establishes lower limit as 0 and upper limit as 360, as in the angles of a circle
}

// Returns hue from RGB value
float HueFromRGB(color c)
{
  int red   = (c >> 16) & 0xFF; // Can be either hue or red
  int green = (c >> 8)  & 0xFF; // Can be either saturation or green
  int blue  =  c        & 0xFF; // Can be either brightness or blue
  return HueFromRGB(red,green,blue);
}
