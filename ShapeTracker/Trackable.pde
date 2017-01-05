// Represents an object suitable for tracking by an external class
class Trackable extends Components{
  boolean tracked=false;
  public ArrayList<PVector> componentCentroids=new ArrayList<PVector>(); // Stores component centroids 
  ArrayList<Integer> componentRadii=new ArrayList<Integer>();; // Stores radius of each component
  PVector centroid=new PVector(0,0);
  PVector direction=new PVector(0,0); 
  
  // Sames as superclass version, but with extra information stored  
  @Override
  boolean add(SegmentList other){    
    boolean success=super.add(other);
    componentCentroids.add(other.getCentroid());
    centroid=centroid.mult(componentCentroids.size()-1).add(other.getCentroid()).div(componentCentroids.size()); // updates centroid value    
    componentRadii.add(other.getRadius());    
    updateDirection(other);
    return success;
  }
  
  // Update direction vector based on new element
  void updateDirection(SegmentList other){
    direction.add(centroid.sub(other.getCentroid()));
  }
  PVector getCentroid(){
    return this.centroid;
  }
  
  PVector getDirection(){
    return this.direction;
  }
};