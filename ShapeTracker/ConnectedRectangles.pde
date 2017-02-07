import java.util.HashSet;

// Records current intersections between rectangles through a graph
class ConnectedRectangles extends ArrayList<Rectangle> {


  // Overrides add in order to keep track of intersections
  boolean add(Rectangle other) {
    int currentSize=this.size();
    if (currentSize==0) {
      return super.add(other);
    } else {
      ArrayList<Rectangle> piecesList=new ArrayList<Rectangle>();
      for (int i=0; i<currentSize; i++) {
        Rectangle currentRectangle=this.get(i);
        piecesList.addAll(other.difference(currentRectangle)); // adds a rectangle without intersections with current rectangles
      }      

      // Adds remaining pieces to this object
      for (Rectangle piece : piecesList) {
        boolean result=super.add(piece);
        if (!result) return false;
      }
      return true;
    }
  }


  boolean remove(Rectangle other) {
    // Currently, no difference between overriden and original methods 
    return super.remove(other);
  }

  // Determines whether this collection of rectangles intersects another
  boolean intersects(Rectangle other) {
    for (Rectangle rect : this) {
      if (rect.intersects(other)) {
        return true;
      }
    }
    return false;
  }

  // Returns the intersection of this object with rectangle r
  ConnectedRectangles difference(Rectangle r) {
    int currentSize=this.size();
    ArrayList<Integer> removeList=new ArrayList<Integer>();
    ArrayList<Rectangle> addList=new ArrayList<Rectangle>(); 
    for (int i=0; i<currentSize; i++) {
      Rectangle currentRectangle=this.get(i);
      if (currentRectangle.intersects(r)) {
        removeList.add(i);
        addList.addAll(currentRectangle.difference(r));
      }
    }   
    ConnectedRectangles returnList=(ConnectedRectangles)this.clone();
    returnList.removeAll(removeList);
    returnList.addAll(addList); 
    return returnList;
  }

  // Removes intersection of this object with rectangle r
  void diff(Rectangle r) {
    int currentSize=this.size();
    ArrayList<Integer> removeList=new ArrayList<Integer>();
    ArrayList<Rectangle> addList=new ArrayList<Rectangle>(); 
    for (int i=0; i<currentSize; i++) {
      Rectangle currentRectangle=this.get(i);
      if (currentRectangle.intersects(r)) {
        removeList.add(i);
        addList.addAll(currentRectangle.difference(r));
      }
    }   
    this.removeAll(removeList);
    this.addAll(addList);
  }

  // Unites this object with the new rectangle
  void unite(Rectangle r) {
    int currentSize=this.size();
    ArrayList<Rectangle> addList=new ArrayList<Rectangle>();
    for (int i=0; i<currentSize; i++) {
      Rectangle currentRectangle=this.get(i);
      if (currentRectangle.intersects(r)) {
        addList.addAll(r.difference(currentRectangle));
      }
    }  
    this.addAll(addList);
  }

  // Sorts rectangles by y ascending then by x ascending and removes repeated rectangles 
  void sortYX() {
    int currentSize=this.size();
    for (int i=0; i<currentSize-1; i++) {
      for (int j=i+1; j<currentSize; j++) {
        Rectangle r1=this.get(i);
        Rectangle r2=this.get(j);
        if (r2.getY()<r1.getY()) {
          this.set(i, r2);
          this.set(j, r1);
        } else if (r2.getY()==r1.getY()) {
          if (r2.getX()<r1.getX()) {
            this.set(i, r2);
            this.set(j, r1);
          }
        }
      }
    }
  }

  // Removes repeated rectangles from the ordered list
  void removeRepeated() {
    ArrayList<Integer> removeList=new ArrayList<Integer>();
    int currentSize=this.size();
    Rectangle currentRect=this.get(0);
    for (int i=1; i<currentSize; i++)
    {
      Rectangle nextRect=this.get(i);
      if (nextRect.getX()==currentRect.getX()&&nextRect.getY()==currentRect.getY())
      {
        removeList.add(i);
      } else
      {
        currentRect=this.get(i);
      }
    }
    for (int i=removeList.size()-1; i>=0; i--)
    {
      int removeIndex=removeList.get(i);     
      this.remove(removeIndex);
    }
  }
};