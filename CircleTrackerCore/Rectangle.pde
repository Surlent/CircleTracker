class Rectangle
{
  int x,y,w,h;
  Rectangle(int x,int y,int w,int h)
  {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;  
  }
  void setX(int value)
  {
    x=value;
  }
  void setY(int value)
  {
    y=value;
  }
  void setWidth(int value)
  {
    w=value;
  }
  void setHeight(int value)
  {
    h=value;
  }
  int getX()
  {
    return x;
  }
  int getY()
  {
    return y;
  }
  int getWidth()
  {
    return w;
  }
  int getHeight()
  {
    return h;
  }
  int getLeft()
  {
    return x;
  }
  int getTop()
  {
    return y;
  }
  int getRight()
  {
    return x+w;
  }
  int getBottom()
  {
    return y+h;
  }
  int getCenterX()
  {
    return (int)(x+(w/2));
  }
  int getCenterY()
  {
    return (int)(y+(h/2));
  }
  // Returns whether the rectangle is one dimensional
  boolean isLine()
  {
    if ((this.getLeft()==this.getRight())||(this.getTop()==this.getBottom()))
      return true;
    else return false;
  }
  
  // Returns whether r intersects this rectangle
  boolean intersects(Rectangle r)
  {
    if ((this.getRight()<r.getLeft())||(r.getRight()<this.getLeft())||(this.getBottom()<r.getTop())||(r.getBottom()<this.getTop()))
    return false;
    else return true;
  }
  
  // Returns the intersection between this rectangle and r
  Rectangle intersection(Rectangle r)
  {
    if (this.intersects(r))
    {
      int left=max(this.getLeft(),r.getLeft());
      int right=min(this.getRight(),r.getRight());
      int top=max(this.getTop(),r.getTop());
      int bottom=min(this.getBottom(),r.getBottom());
      int w=max(0,right-left);
      int h=max(0,bottom-top);
      return new Rectangle(left,top,w,h);
    }
    else
    {
      return null;
    }
  }
  // Returns the first rectangle minus the intersection with the second
  ArrayList<Rectangle> difference(Rectangle r)
  {
    ArrayList<Rectangle> difference=new ArrayList<Rectangle>();
    Rectangle intersection=this.intersection(r);
    if (intersection!=null)
    {
      int topLeftX=this.getX();
      int topLeftY=this.getY();
      int bottomRightX=intersection.getX();
      int bottomRightY=intersection.getY(); int i=0;
      //println("intersection:"+intersection.getX()+","+intersection.getY()+","+intersection.getRight()+","+intersection.getBottom());
      // Scans this rectangle
      while ((bottomRightX<=this.getRight())&&(bottomRightY<=this.getBottom()))
      {
        //println(i++);
        //println("topLeftX:"+topLeftX+",topLeftY:"+topLeftY+",bottomRightX:"+bottomRightX+",bottomRightY:"+bottomRightY);
        if (i>100) // Avoids a memory leak
        {break; };
        // Avoids counting the main rectangles as pieces
        if ((!(topLeftX==this.getX()&&topLeftY==this.getY()&&bottomRightX==this.getRight()&&bottomRightY==this.getBottom()))&&(!(topLeftX==intersection.getX()&&topLeftY==intersection.getY()&&bottomRightX==intersection.getRight()&&bottomRightY==intersection.getBottom())))
        {
          int w=bottomRightX-topLeftX; 
          int h=bottomRightY-topLeftY; 
          if ((w>0)&&(h>0))
          {
            Rectangle newRect=new Rectangle(topLeftX+1,topLeftY+1,w,h); // Excludes borders
            if (!difference.contains(newRect))
            {
              difference.add(newRect); // Excludes borders
            }
          }
        }
        if (bottomRightX==intersection.getX())
        {
             topLeftX=bottomRightX;
             bottomRightX=intersection.getRight();
        }
        else if (bottomRightX==intersection.getRight()&&intersection.getRight()!=this.getRight())
        {
             topLeftX=bottomRightX;
             bottomRightX=this.getRight();
        }   
        else if (bottomRightX==this.getRight()||intersection.getRight()==this.getRight())
        {
             topLeftX=this.getX();
             bottomRightX=intersection.getX();
             topLeftY=bottomRightY;
             
             if (bottomRightY==intersection.getY())
             {
               bottomRightY=intersection.getBottom();
             }
             else if (bottomRightY==intersection.getBottom()&&this.getBottom()!=intersection.getBottom())
             {
               bottomRightY=this.getBottom();
             }
             else if (bottomRightY==this.getBottom()||this.getBottom()==intersection.getBottom())
             {
               break;
             }
        }
      }
    }  
    else
    {
      difference.add(this);
    }
    return difference;
    
  }
  
  ArrayList<Rectangle> union(Rectangle r)
  {
    ArrayList<Rectangle> union=new ArrayList<Rectangle>();
    union.add(this);
    union.addAll(r.difference(this));
    return union;   
  }
};
