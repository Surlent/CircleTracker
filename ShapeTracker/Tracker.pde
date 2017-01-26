class Tracker {
  boolean tracking=false; // Whether tracking is turned on  
  boolean hasCoordinates=false; // Whether there are enough objects to establish a plane

  PVector position=new PVector(0, 0, 0); // Stores position of composite object (initial and current)
  PVector direction=new PVector(0, 0, 0); // Stores direction of composite object (initial and current)

  // Moving averages parameter for direction
  float alphaEWMA=0.01;

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
    if (isTracking) {
      this.trackingBounds=new ConnectedRectangles();
    } else {
      this.trackingBounds=null;
      this.trackedObject=null;
    }
  }
  void setTrackedObject(Trackable trackableObject) {
    trackedObject=trackableObject;
    if (trackedObject.size()==3) {
      this.hasCoordinates=true;
    } else {
      this.hasCoordinates=false;
    }
  }

  void toggleTracking() {
    setTracking(!tracking);
    trackedObject.tracked=tracking;
  }

  void update() {
    if (tracking) {
      //SegmentList closestObject=foundObjects.get(LargestRadiusObjectIndex(foundObjects));
      //int largestRadius=closestObject.getRadius();    
      if (trackedObject.size()==3) {
        updatePosition();
        updateDirection();
      }
    } else {
    }
  }

  // Updates position based on EWMA technique
  private void updatePosition() {    
    this.position=trackedObject.centroid;
    //this.position=EWMA(this.position,trackedObject.centroid,alphaEWMA);    
  }
  private void updateDirection() {
    this.direction=trackedObject.direction;
  }

  PVector getPosition() {
    return this.position;
  }

  PVector getDirection() {
    return this.direction;
  }

  boolean HasCoordinates() {
    return this.hasCoordinates;
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