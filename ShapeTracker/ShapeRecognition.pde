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
    foundObjects=new Components();
    
    for (SegmentList sl : connectedComponents) {
      circularity=sl.getCircularity();
      area=sl.getArea();
      
      perimeter=sl.getPerimeter();
      radius=(int)CircleRadiusFromPerimeter(perimeter);
      minCircularity=AcceptableCircleCircularity(radius,0.9);
      maxCircularity=AcceptableCircleCircularity(radius,1.1);
      minArea=AcceptableCircleArea(radius,0.9);      
      maxArea=AcceptableCircleArea(radius,1.1);
      
      if ((perimeter<=maxPerimeter)&&(perimeter>=minPerimeter)&&(area<=maxArea)&&(area>=minArea)&&(circularity<=maxCircularity)&&(circularity>=minCircularity))
      {
        foundObjects.add(sl);
      }
    }
    if(foundObjects.size()!=3)
    {
      tracking=false;
    }
}

void FindSquares()
{  
    int side;
    float minArea;
    float minPerimeter=minSquarePerimeter;
    float maxArea;
    float maxPerimeter=maxSquarePerimeter;
    int perimeter;
    int area;
    float circularity,minCircularity,maxCircularity;
    foundObjects=new Components();
    
    for (SegmentList sl : connectedComponents) {
      circularity=sl.getCircularity();
      area=sl.getArea();      
      perimeter=sl.getPerimeter();
      side=(int)SquareSideFromPerimeter(perimeter);
      minCircularity=AcceptableSquareCircularity(side,0.8);
      minArea=AcceptableSquareArea(side,0.8);
      maxCircularity=AcceptableSquareCircularity(side,1.2);
      maxArea=AcceptableSquareArea(side,1.2);
      
      if ((perimeter<=maxPerimeter)&&(perimeter>=minPerimeter)&&(area<=maxArea)&&(area>=minArea)&&(circularity<=maxCircularity)&&(circularity>=minCircularity))
      {
        foundObjects.add(sl);
      }
    }
    if(foundObjects.size()!=3)
    {
      tracking=false;
    }
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

// Calculates area of a square based on SegmentList's own method
int DiscreteSquareArea(int side)
{
  SegmentList square=new SegmentList();
  for (int y=-side/2;y<=side/2;y++)
  {
    int x1=side/2;
    int x0=-x1;
    Segment strip=new Segment(y,x0,x1);
    square.add(strip);
  }
  return square.getArea();
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

// Returns perimeter of a square with given side
int DiscreteSquarePerimeter(int side)
{
  return 4*side;
}

// Calculates circularity of a circle based on SegmentList's own method
float DiscreteCircleIdealCircularity(int radius)
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

// Calculates circularity of a square based on SegmentList's own method
float DiscreteSquareIdealCircularity(int side)
{
  SegmentList square=new SegmentList();
  for (int y=-side/2;y<=side/2;y++)
  {
    int x1=side/2;
    int x0=-x1;
    Segment strip=new Segment(y,x0,x1);
    square.add(strip);
  }
  return square.getCircularity();
}

float AcceptableCircleArea(int radius,float ratio)
{
  return ratio*DiscreteCircleArea(radius);
}

float AcceptableSquareArea(int side,float ratio)
{
  return ratio*DiscreteSquareArea(side);
}

float AcceptableCircleCircularity(int radius,float ratio)
{
  return ratio*DiscreteCircleIdealCircularity(radius);
}

float AcceptableSquareCircularity(int side,float ratio)
{
  return ratio*DiscreteSquareIdealCircularity(side);
}

// An approximation which allows the extraction of a radius
float CircleRadiusFromPerimeter(int perimeter)
{
  return perimeter/8;
}

// An approximation which allows the extraction of a square's side
float SquareSideFromPerimeter(int perimeter)
{
  return perimeter/4;
}

void SetCircleTrackingBounds()
{
  if (tracking)
  {
    int left=0,top=connectedComponents.get(0).get(0).y,w=img.width,h=0;
    trackingBounds=new ConnectedRectangles();
    for (SegmentList sl:foundObjects)
    {
     int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
     int estimatedRadius=(int)(radius*1.3);     
     h=min(img.height,max(h,sl.getCentroidY()+estimatedRadius-top));
    } 
    Rectangle trackingRectangle=new Rectangle(left,top,w,h);
    trackingBounds.add(trackingRectangle);
  }
}

void DrawCircleMarkers()
{
    PFont f=createFont("Arial",16,true);
    //textFont(f,36);
    int j=0;
    int i=0;
    FillPallette(connectedComponents.size());
    for(SegmentList sl:connectedComponents)
    {
      stroke(pallette[i++]);
      for (Segment s:sl)
      {
        line(s.x0,s.y,s.x1,s.y);
      }
    }
    if(foundObjects!=null)
    {
      FillPallette(foundObjects.size());
      for (SegmentList sl:foundObjects)
      {
          int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
          fill(color(255,0,0,100));
          rect(ratioX*sl.getCentroidX()-ratioX*radius, ratioY*sl.getCentroidY()-ratioY*radius, ratioX*radius*2, ratioY*radius*2);
          text(radius,ratioX*sl.getCentroidX(),ratioY*sl.getCentroidY());
          j++; 
      }  
      if (foundObjects.size()==3)
      {
        SegmentList leftEye,rightEye;
        if (foundObjects.get(0).getCentroidX()<foundObjects.get(1).getCentroidX())
        {
          rightEye=foundObjects.get(0);
          leftEye=foundObjects.get(1);
        }
        else
        {
          rightEye=foundObjects.get(1);
          leftEye=foundObjects.get(0);
        }
        SegmentList axisPoint=foundObjects.get(2);
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

void DrawSquareMarkers()
{
    PFont f=createFont("Arial",18,true);
    //textFont(f,18);
    int j=0;
    int i=0;
    FillPallette(connectedComponents.size());
    for(SegmentList sl:connectedComponents)
    {
      stroke(pallette[i++]);
      for (Segment s:sl)
      {
        line(s.x0,s.y,s.x1,s.y);
      }
    }
    if(foundObjects!=null)
    {
      FillPallette(foundObjects.size());
      for (SegmentList sl:connectedComponents)
      {
          int side=(int)SquareSideFromPerimeter(sl.getPerimeter());
          fill(color(255,0,0,100));
          rect(ratioX*sl.getCentroidX()-ratioX*(side/2), ratioY*sl.getCentroidY()-ratioY*(side/2), ratioX*side, ratioY*side);
          text(side+", "+sl.getPerimeter()+", "+sl.getArea()+", "+sl.getCircularity(),ratioX*sl.getCentroidX()+side*1.1/2,ratioY*sl.getCentroidY());
          text(side+", "+DiscreteSquarePerimeter(side)+", "+DiscreteSquareArea(side)+", "+DiscreteSquareIdealCircularity(side),ratioX*sl.getCentroidX()+side*1.1/2,ratioY*sl.getCentroidY()+15);
          j++; 
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