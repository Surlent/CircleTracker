// Represents an object suitable for tracking by an external class
class Trackable extends Components{
  boolean tracked=false;
  
  PVector centroid=new PVector(0,0,0);
  PVector direction=new PVector(0,0,0);
  
  public ArrayList<PVector> componentCentroids=new ArrayList<PVector>(); // Stores component centroids 
  ArrayList<Integer> componentAreas=new ArrayList<Integer>(); // Stores radius of each component
  
  // Sa version, but with extra information st
  boolean add(SegmentList other){    
    boolean success=super.add(other);
    
    // updates position vector
    updatePosition(other);
    
    // updates centroid value       
    componentAreas.add(other.getArea());   
    
    // Three points define a plane, which indicates a direction
    if(componentCentroids.size()==3){
      updateDirection();
    }
    return success;
  }
  
  void updatePosition(SegmentList newComponent){
    PVector otherCentroid=newComponent.getCentroid();
    
    // z goes from outside to inside screen, which means a negative value outside
    otherCentroid.z=1-cameraArea/newComponent.getArea();
    componentCentroids.add(otherCentroid);           
    this.centroid.mult(componentCentroids.size()-1);    
    this.centroid.add(otherCentroid);    
    this.centroid.div(componentCentroids.size()); 
  }
  
  // Update direction vector based on new element
  void updateDirection(){    
    direction=PVector.sub(componentCentroids.get(1),componentCentroids.get(0)).cross(PVector.sub(componentCentroids.get(2),componentCentroids.get(0)));    
    if(direction.z<0){
      direction.mult(-1);
    }
    direction.normalize();
  }
  
  PVector getCentroid(){
    return this.centroid;
  }
  
  PVector getDirection(){
    return this.direction;
  }      
};