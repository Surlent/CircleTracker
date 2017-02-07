// Represents an object suitable for tracking by an external class
class Trackable extends Components {
  boolean tracked=false;

  PVector centroid=new PVector(0, 0, 0);
  PVector direction=new PVector(0, 0, 0);

  public ArrayList<PVector> componentCentroids=new ArrayList<PVector>(); // Stores component centroids 
  ArrayList<Integer> componentAreas=new ArrayList<Integer>(); // Stores radius of each component

  // Sa version, but with extra information st
  boolean add(SegmentList other) {    
    boolean success=super.add(other);
    componentCentroids.add(other.getCentroid());
    componentAreas.add(other.getArea());
    // Three points define a plane, which indicates a direction
    if (this.size()==3) {      
      updatePosition();                                 
      updateDirection();
    }
    return success;
  }

  // Update position vector
  void updatePosition() {
    this.centroid=new PVector(0, 0, 0);
    for (int i=0; i<componentCentroids.size(); i++) {
      PVector componentCentroid=componentCentroids.get(i);
      float componentArea=componentAreas.get(i);
      componentCentroid.z=1-sqrt(componentArea/cameraArea); // Calculates depth based on lens equation      
      this.centroid.add(componentCentroid);
    }
    this.centroid.div(componentCentroids.size());
  }

  // Update direction vector based on new element
  void updateDirection() {    
    this.direction=PVector.sub(componentCentroids.get(1), componentCentroids.get(0)).cross(PVector.sub(componentCentroids.get(2), componentCentroids.get(0)));    
    if (this.direction.z<0) {
      this.direction.mult(-1);
    }
    this.direction.normalize();
  }

  PVector getCentroid() {
    return this.centroid;
  }

  PVector getDirection() {
    return this.direction;
  }
};