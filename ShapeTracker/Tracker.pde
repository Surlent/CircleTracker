class Tracker {
  boolean tracking=false;  

  PVector x; // Stores position of composite object (initial and current)
  PVector dx; // Stores direction of composite object (initial and current)

  // Rectangular areas to be scanned for tracking
  ConnectedRectangles trackingBounds;

  Trackable trackedObject;

  boolean isTracking() {
    return tracking;
  }
  void setTrackingBounds(ConnectedRectangles value) {
    this.trackingBounds=value;
  }
  ConnectedRectangles getTrackingBounds() {
    return trackingBounds;
  }
  void setTracking(boolean isTracking) {
    this.tracking=isTracking;
    if(isTracking){
      this.trackingBounds=new ConnectedRectangles();
    }
    else{
      this.trackingBounds=null;
      this.trackedObject=null;
    }
  }
  void setTrackedObject(Trackable trackableObject) {
    trackedObject=trackableObject;
  }

  void toggleTracking() {
    setTracking(!tracking);
    trackedObject.tracked=tracking;
  }

  void update() {
    if (tracking) {
      //SegmentList closestObject=foundObjects.get(LargestRadiusObjectIndex(foundObjects));
      //int largestRadius=closestObject.getRadius();      
      updatePosition();
      updateDirection();      
    } else {
    }
  }

  private void updatePosition() {
    x=trackedObject.getCentroid();    
  }

  private void updateDirection() {
    dx=trackedObject.getDirection();    
  }

  PVector getPosition() {
    return x;
  }

  PVector getDirection() {
    return dx;
  }

  void setCircleTrackingBounds()
  {
    if (tracking)
    {      
      int left=0;
      int top=(trackedObject.size()>0)?(trackedObject.get(0).get(0).y):(0);
      int w=img.width, h=0;
      for (SegmentList sl : trackedObject)
      {
        int radius=(int)CircleRadiusFromPerimeter(sl.getPerimeter());
        int estimatedRadius=(int)(radius*1.3);     
        h=min(img.height, max(h, sl.getCentroidY()+estimatedRadius-top));
      } 
      Rectangle trackingRectangle=new Rectangle(left, top, w, h);
      this.trackingBounds.add(trackingRectangle);      
    }
  }
};