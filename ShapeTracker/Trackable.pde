// Represents an object suitable for tracking by an external class
class Trackable extends Components{
  boolean tracked=false;
  public ArrayList<PVector> componentCentroids=new ArrayList<PVector>(); // Stores component centroids 
  ArrayList<Integer> componentRadii=new ArrayList<Integer>();; // Stores radius of each component
  PVector centroid=new PVector(0,0,0);
  PVector direction=new PVector(0,0,0); 
  
  // Sames as superclass version, but with extra information stored  
  @Override
  boolean add(SegmentList other){    
    boolean success=super.add(other);
    componentCentroids.add(other.getCentroid());
    //println(centroid.mult(componentCentroids.size()-1).add(other.getCentroid()));    
    this.centroid.mult(componentCentroids.size()-1);    
    this.centroid.add(other.getCentroid());    
    this.centroid.div(componentCentroids.size()); // updates centroid value       
    componentRadii.add(other.getRadius());    
    updateDirection();
    return success;
  }
  
  // Update direction vector based on new element
  void updateDirection(){
    direction=new PVector(0,0,0);
    for(int i=0;i<componentCentroids.size();i++){
      PVector componentCentroid=componentCentroids.get(i);
      Integer radius=componentRadii.get(i);
      direction.add(PVector.mult(PVector.sub(centroid,componentCentroid),IncreasingFunction(radius)));
    }
    direction.z=sqrt(1-(pow(direction.x,2)+pow(direction.y,2)));    
    direction.mult(10);
  }
  PVector getCentroid(){
    return this.centroid;
  }
  
  PVector getDirection(){
    return this.direction;
  }   
};