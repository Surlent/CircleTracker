// This is the function that tells whether a pixel is of 
// the desired color
boolean RightColor (color c) {
  
  //float theHue=hue(c);
  return brightness(c)<70;
}

void SetTrackingBounds()
{
  if (tracking)
  {
    if (foundComp.size()>0)
    {
      trackingBounds=new ArrayList<Rectangle>();
      int left=img.width,top=img.height,w=0,h=0;
      //int i=0;
      for (SegmentList sl:foundComp)
      {
       int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
       int k=(int)(radius*1.3);
       left=max(0,sl.getCentroidX()-k);
       top=max(0,sl.getCentroidY()-k);
       w=min(img.width,sl.getCentroidX()+k-left);
       h=min(img.height,sl.getCentroidY()+k-top);
       Rectangle newRect=new Rectangle(left,top,w,h);
       boolean intersectsPrevious=false;
       ArrayList<Rectangle> newTrackingRectangles=new ArrayList<Rectangle>();
       ArrayList<Integer> removeList=new ArrayList<Integer>();
       trackingBounds.add(newRect);
       int trackingBoundsSize=trackingBounds.size();
       
       for (int i=0;i<trackingBoundsSize-1;i++)
       {
         for (int j=i+1;j<trackingBoundsSize;j++)
         {
           Rectangle trackingRectangle1=trackingBounds.get(i);
           Rectangle trackingRectangle2=trackingBounds.get(j);
           if (trackingRectangle1.intersects(trackingRectangle2))
           {
              newTrackingRectangles.addAll(trackingRectangle1.union(trackingRectangle2));
              removeList.add(i);
              removeList.add(j);
           }
         }
       }
       int removeListSize=removeList.size();
       for (int i=0;i<removeListSize;i++)
       {
         trackingBounds.remove(removeList.get(i));
       }
       trackingBounds.addAll(newTrackingRectangles);
       
       trackingBoundsSize=trackingBounds.size();
       for (int i=0;i<trackingBoundsSize-1;i++)
       {
         for (int j=i+1;j<trackingBoundsSize;j++)
         {
           Rectangle trackingRectangle1=trackingBounds.get(i);
           Rectangle trackingRectangle2=trackingBounds.get(j);
           if (trackingRectangle1.intersects(trackingRectangle2))
           {
              Rectangle inter=trackingRectangle1.intersection(trackingRectangle2);
              println(inter.getX()+","+inter.getY()+","+inter.getWidth()+","+inter.getHeight());
              
           }
         }
       }
       
       /*for (Rectangle trackingRectangle:trackingBounds)
       {
         if (newRect.intersects(trackingRectangle))
         {
            ArrayList<Rectangle> newRectParts=newRect.difference(trackingRectangle);
            newTrackingRectangles.addAll(newRectParts);
            intersectsPrevious=true;
         }
       }
       if (!intersectsPrevious)
       {
         trackingBounds.add(newRect);
       }
       else
       {
         trackingBounds.addAll(newTrackingRectangles);
       }*/
      }
      
    }
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
      
      minCircularity=AcceptableCircularity(radius,0.5);
      minArea=AcceptableArea(radius,0.5);
      maxCircularity=AcceptableCircularity(radius,1.5);
      maxArea=AcceptableArea(radius,1.5);
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
    /*for(SegmentList sl:comp)
    {
      stroke(pallette[i++]);
      for (Segment s:sl)
      {
        line(s.x0,s.y,s.x1,s.y);
      }
    }*/
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
      fill(color(255,0,0,50));
      for (Rectangle r:trackingBounds)
      {
        fill(color(random(255),random(255),random(255)));
        rect(ratioX*r.getX(),ratioY*r.getY(),ratioX*r.getWidth(),ratioY*r.getHeight());
      }
    }
}

void DrawDebugInfo()
{
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
