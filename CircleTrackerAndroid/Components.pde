// Represents a list of connected components
class Components extends ArrayList<SegmentList> {
 
  Components () {
    super();
  }
  
  Components (PImage img) {
    super();
    for (int y = 0; y < img.height; y++) {
      SegmentList l = SegmentRow(img,y);
      this.merge(l);
    }
  }
  Components(PImage img,ArrayList<Rectangle> bounds)
  {
    super();
    for (Rectangle r:bounds)
    {
      for (int y = (int)r.getY(); y < (int)(r.getY()+r.getHeight()); y++) 
      {
        SegmentList l = SegmentRow(img,y,r);
        this.merge(l);
      }
    }
  }
  // Merges this collection of connected components with
  // a list of segments obtained by scanning another line
  void merge (SegmentList other) { 
    
    // Test each element of other against all connected
    // components
    for (int k = 0; k < other.size(); k++) {
      Segment o = other.get(k);
      // the other segment list contains only one y
      assert (k == 0 || o.y == other.get(k-1).y);
      
      // This is a list of indices of all components overlapped by o
      ArrayList<Integer> ilist = new ArrayList<Integer> ();
      
      // Test all current connected components
      for (int i = 0; i < this.size(); i++) {
       
        SegmentList sl = this.get(i);
        
        // Go backwards from the last to the first segment
        // because we trust the list is ordered monotonously
        // w.r.t. the y coordinate
        for (int j = sl.size()-1; j>=0; j--) {
          Segment s = sl.get(j);
          
          if (s.y+overlapDistanceY < o.y) {
            // No segments above this one can overlap o
            break;
          }
          
          if (s.overlap (o,overlapDistanceX,overlapDistanceY)) {
            //Segment overlaps component i
            if (!ilist.contains(i)) ilist.add(i);
          }
        }
      }
      if (ilist.size() == 0) { 
        // o does not overlap any connected component
        // thus, add it as an independent component
        SegmentList component = new SegmentList();
        this.add(component);
        component.add (o);
      }
      else {
        // o overlaps one or more components. 
        // Merge all of them and add o
        int i0 = ilist.get(0);
        SegmentList root = this.get(i0);
        for (int j = 1; j < ilist.size(); j++) {
          int i = ilist.get(j);
          root = root.merge(this.get(i));
          this.get(i).clear();
        }
        for (int j = ilist.size()-1; j >= 1; j--) {
          int i = ilist.get(j);
          this.remove(i);
        }
        root.add(o);
        this.set (i0, root);
      }    
    } // Ends foreach on others
  } // Ends merge
  
};
