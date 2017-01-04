class Tracker{
  boolean tracking=false;
  
  float x,y,z;
  float rotX,rotY,rotZ;
  
  void beginTracking(){
     SegmentList closestObject=foundObjects.get(LargestRadiusObjectIndex(foundObjects));
     int largestRadius=closestObject.getRadius();
  }  
  
  void pauseTracking(){
  
  }
  
  void toggleTracking(){
    if (tracking)
    {
      pauseTracking();
    }
    else{
      beginTracking();
    }
  }
};