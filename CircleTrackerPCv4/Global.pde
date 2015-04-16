// Connected components in the current image
Components comp = new Components ();
// Filtered components
Components foundComp=new Components();
// Image to be processed
PImage img; 

// Screen ratios for drawing
float ratioX=1;
float ratioY=1;;

// Determines whether components are being tracked
boolean tracking=false;
// Sets minimum distances for components to be considered overlappingg
int overlapDistanceX=0; // Should be set to 0 if no space between pixels is allowed
int overlapDistanceY=1; // Should be set to 1 if no space between pixels is allowed

// Limits circles being tracked
float minCirclePerimeter=DiscreteCirclePerimeter(5);
float maxCirclePerimeter=DiscreteCirclePerimeter(100);

// Color array for drawing the components
color pallette [] = { color (random(255),random(255),random(255)) };

// This is the function that tells whether a pixel is of 
// the desired color
float rightHueLower=180;
float rightHueUpper=220;
float rightSaturationLower=0.5;
float rightSaturationUpper=1;
float rightBrightnessLower=0.3;
float rightBrightnessUpper=1;
boolean RightColor (color c) {
  colorMode(HSB,360,100,100);
  float hue=hue(c); 
  float saturation=saturation(c);
  float brightness=brightness(c);
  boolean hueFilter=(hue>=rightHueLower&&hue<=rightHueUpper);
  boolean saturationFilter=saturation>=rightSaturationLower&&saturation<=rightSaturationUpper;
  boolean brightnessFilter=brightness>=rightBrightnessLower&&brightness<=rightBrightnessUpper;
  colorMode(RGB,255);
  return hueFilter&&brightnessFilter&&saturationFilter;
}

void DrawDebugInfo()
{    
    println ("Total Found Size:"+((foundComp!=null)?(foundComp.size()):(0)));
    println ("Total Size:"+((comp!=null)?(comp.size()):(0)));
}


// Rectangles to be tracked on the screen
ArrayList<Rectangle> trackingBounds;

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
    int radius,radiusPlus,radiusMinus;
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
    /*for(int i=0;i<3;i++)
    {
      println("i:"+i);
    SegmentList c=comp.get(i);
    int cRadius=(int)CircleRadiusFromPerimeter(c.getPerimeter());
    println("Perimeter:"+c.getPerimeter()+",Radius:"+cRadius+",Area:"+c.getArea()+",Circularity:"+c.getCircularity());
    println("MinPerimeter:"+DiscreteCirclePerimeter(5)+",MinRadius:5,MinArea:"+AcceptableArea(cRadius,0.7)+",MinCircularity:"+AcceptableCircularity(cRadius,0.7));
    println("MaxPerimeter:"+DiscreteCirclePerimeter(100)+",MaxRadius:100,MaxArea:"+AcceptableArea(cRadius,1.3)+",MaxCircularity:"+AcceptableCircularity(cRadius,1.3));
    }*/
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
        /*if (foundComp.size()==3)
        {
          tracking=true;
          SetTrackingBounds();          
          break;
        }*/
      }
    }
    if(foundComp.size()!=3)
    {
      tracking=false;
    }
}
void SetTrackingBounds()
{
  if (tracking)
  {
    int left=0,top=comp.get(0).get(0).y,w=img.width,h=0;
    trackingBounds=new ConnectedRectangles();
    int mycounter=0;
    for (SegmentList sl:foundComp)
    {
     int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
     int estimatedRadius=(int)(radius*1.3);     
     h=min(img.height,max(h,sl.getCentroidY()+estimatedRadius-top));
    } 
    Rectangle trackingRectangle=new Rectangle(left,top,w,h);
    trackingBounds.add(trackingRectangle);
  }
}

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
    if(foundComp!=null)
    {
      FillPallette(foundComp.size());
      for (SegmentList sl:foundComp)
      {
          int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
          fill(color(255,0,0,100));
          rect(ratioX*sl.getCentroidX()-ratioX*radius, ratioY*sl.getCentroidY()-ratioY*radius, ratioX*radius*2, ratioY*radius*2);
          text(radius,ratioX*sl.getCentroidX(),ratioY*sl.getCentroidY());
          
          /*fill(255);
          if (!usecam)
          {
          stroke (pallette[j]);
           for (Segment s : sl) 
            {
              line (ratioX*s.x0, ratioY*s.y, ratioX*s.x1, ratioY*s.y);
            }
          }*/
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
    }
    if(tracking)
    {
      //println("bounds size:"+trackingBounds.size());
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
