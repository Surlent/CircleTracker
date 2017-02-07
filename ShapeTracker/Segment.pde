// Represents a horizontal interval of pixels, all
// of which are considered to be similar
class Segment {

  int y, x0, x1; // Coordinates

  // Constructor
  Segment (int y, int x0, int x1) {
    this.y = y;
    this.x0 = x0;
    this.x1 = x1;
  }
  int overlappingLength(Segment other) {
    return min(x1, other.x1)-max(x0, other.x0);
  }
  // Whether this segment overlaps segment other
  boolean overlap(Segment other, int maxDistanceX, int maxDistanceY) {
    return abs(y-other.y) <= maxDistanceY && 
      max(x0, other.x0) <= min (x1, other.x1)+maxDistanceX;
  }

  boolean overlap(Segment other, int maxDistance) {
    return overlap(other, maxDistance, maxDistance);
  }
  boolean overlap(Segment other) {
    return overlap(other, 1);
  }

  // The x center of this segment
  float xcenter () { 
    return (x0+x1)/2.0;
  }

  int getLength() {
    return x1-x0;
  }
};