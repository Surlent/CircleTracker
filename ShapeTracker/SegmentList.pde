// A list of pixel segments
class SegmentList extends ArrayList<Segment> {
  int maxY=0;
  // Fields 
  float centroidX=0;
  float centroidY=0;
  float perimeter=0;
  float area=0;
  
  public int getRadius(){
     return CircleRadiusFromPerimeter((int)(this.perimeter));
  }
  public float getCircularity()
  {
    float p=getPerimeter();
    float a=getArea();
    return (a)/(p*p);
  }
  public int getCentroidX()
  {
    return (int)centroidX;
  }
  public int getCentroidY()
  {
    return (int)centroidY;
  }
  public int getCentroidXBrute()
  {
    float sumX=0;
    for (Segment s:this)
    {
      sumX+=s.xcenter();
    }
    return (int)(sumX/this.size());
  }
  public int getCentroidYBrute()
  {
    float sumY=0;
    for (Segment s:this)
    {
      sumY+=s.y;
    }
    return (int)(sumY/this.size());
  }
  
  public int getPerimeter()
  {
    return (int)this.perimeter;
  }
  
  public int getArea()
  {
    return (int)this.area;
  }
  
  // Tests whether the segment list contains segments in non-decreasing
  // order of y
  boolean yMonotonic () {
    int prevY = 0;
    for (Segment s : this) {
      if (s.y < prevY) return false;
      if (s.y > prevY) prevY = s.y;
    }
    return true;
  }
  
  public boolean add(Segment e)
  {
    // Tracks centroid during addition of e
    updateCentroidOnAdd(e);
    updateDiscretePerimeterOnAdd(e);
    updateDiscreteAreaOnAdd(e);
    return super.add(e);
  }
  public boolean remove(Segment e)
  {
    return super.remove(e);
  }
  private void updateDiscretePerimeterOnAdd(Segment e)
  {
    perimeter+=2*e.getLength()+2; // Perimeter of segment for height of pixel equal to 1
    for (int i=this.size()-1;i>=0;i--)
    {
      // Since list is y-monotonic
      if (e.y-this.get(i).y>overlapDistanceY)
      {break;}
      // Subtract overlapping lengths
      if (this.get(i).overlap(e,overlapDistanceX,overlapDistanceY))
      {
        perimeter-=2*this.get(i).overlappingLength(e);        
      }
    }
  }
  
  private void updateDiscreteAreaOnAdd(Segment e)
  {
    this.area+=e.getLength();
  }
  
  private void updateCentroidOnAdd(Segment e)
  {
    int currentSize=this.size();
    int currentSizePlus=currentSize+1;
    centroidX=(float)(((centroidX*currentSize)+e.xcenter())/(currentSizePlus));
    centroidY=(float)(((centroidY*currentSize)+e.y)/(currentSizePlus));
  }

  // Merges the SegmentList other with this one maintaining the
  // y monotonous characteristic of the result
  SegmentList merge (SegmentList other) {
    int n = this.size();
    int m = other.size();
    SegmentList ret= new SegmentList();
    //assert (yMonotonic());
    //assert (other.yMonotonic());
    int i = 0, j = 0;
    while (i < size() && j < other.size()) {
      if (get(i).y < other.get(j).y) {
        ret.add(get(i++));
      }
      else {
        ret.add(other.get(j++));
      }
    }
    while (i < size()) ret.add(get(i++));
    while (j < other.size()) ret.add(other.get(j++));
    //assert (ret.size() == n+m);
    return ret;
  }
  
};