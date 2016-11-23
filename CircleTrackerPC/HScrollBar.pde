class HScrollBar {
  float swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of the center of the selector
  float xposMin, xposMax; // max and min values of the center of the selector
  float hue,saturation,brightness; // color properties
  color[] gradientColors; // colors of gradient 
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  int type; // whether this is a hue(0),saturation(1) or brightness(2) slider
  int countColors; // number of colors sampled for the slider gradient
  float confidenceInterval; // determines the portion of the bar around the position which is covered by the cursor, from 0 to 1
  float selectorWidth; // selector width
  HScrollBar (float xp, float yp, float sw, float sh, int l,int type,float hue, float saturation,float brightness,int countColors,float confidenceInterval) {
    swidth = sw;
    sheight = sh;
    ratio = sw / (sw-sh);
    xpos = xp;
    ypos = yp-sheight/2;
    xposMin=xpos;
    xposMax=xpos+swidth;
    loose = l;
    gradientColors=new color[countColors];
    this.countColors=countColors;
    this.type=type;
    
    selectorWidth=swidth*confidenceInterval;
    sposMin = xposMin + (selectorWidth/2);
    sposMax = xposMax - (selectorWidth/2);
    this.hue=constrain(hue,360*confidenceInterval/2,360*(1-confidenceInterval/2));
    this.saturation=constrain(saturation,100*confidenceInterval/2,100*(1-confidenceInterval/2));
    this.brightness=constrain(brightness,100*confidenceInterval/2,100*(1-confidenceInterval/2));
    this.confidenceInterval=confidenceInterval;
    switch(type) 
    { 
      case 0:
      {
        spos=map(this.hue,0,360,xposMin,xposMax);
        break;
      }
      case 1:
      {
        spos=map(this.saturation,0,100,xposMin,xposMax);
        break;
      }
      case 2:
      {
        spos=map(this.brightness,0,100,xposMin,xposMax);
        break;
      }
    }
    newspos = spos;
    
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (keyPressed&&over)
    {
      if (keyCode==LEFT||keyCode==RIGHT)
      {
        int sign=(keyCode==LEFT)?(-1):(1);
        spos=constrain(spos+sign*swidth/50,sposMin,sposMax);
        switch(type)
        {
          case 0:
          {
            hue=map(spos,xposMin,xposMax,0,360);
            break;
          }
          case 1:
          {
            saturation=map(spos,xposMin,xposMax,0,100);
            break;
          }
          case 2:
          {
            brightness=map(spos,xposMin,xposMax,0,100);
            break;
          }
        }
      }
      if (keyCode == UP||keyCode==DOWN) 
      {
        int sign=(keyCode == DOWN)?(-1):(1);
        confidenceInterval=constrain(confidenceInterval+sign*0.05,0,1);
        selectorWidth=swidth*confidenceInterval;
        sposMin = xposMin + (selectorWidth/2);
        sposMax = xposMax - (selectorWidth/2);
        this.hue=constrain(hue,360*confidenceInterval/2,360*(1-confidenceInterval/2));
        this.saturation=constrain(saturation,100*confidenceInterval/2,100*(1-confidenceInterval/2));
        this.brightness=constrain(brightness,100*confidenceInterval/2,100*(1-confidenceInterval/2));
        this.confidenceInterval=confidenceInterval;
        switch(type) 
        { 
          case 0:
          {
            spos=map(this.hue,0,360,xposMin,xposMax);
            break;
          }
          case 1:
          {
            spos=map(this.saturation,0,100,xposMin,xposMax);
            break;
          }
          case 2:
          {
            spos=map(this.brightness,0,100,xposMin,xposMax);
            break;
          }
        }
        newspos = spos;
      }
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX,sposMin,sposMax);  
      if (abs(newspos - spos) > 1) {
        spos = spos + (newspos-spos)/loose;
      
        switch(type)
        {
          case 0:
          {
            hue=map(spos,xposMin,xposMax,0,360);
            break;
          }
          case 1:
          {
            saturation=map(spos,xposMin,xposMax,0,100);
            break;
          }
          case 2:
          {
            brightness=map(spos,xposMin,xposMax,0,100);
            break;
          }
        }
      }
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    colorMode(HSB,360,100,100);
    switch(type) // Hue
    { 
      case 0:
      {
        for (int i=0;i<countColors;i++)
        {
          gradientColors[i]=color(360*i/(countColors-1),saturation,brightness);
        }
        break;
      }
      case 1:
      {
        for (int i=0;i<countColors;i++)
        {
          gradientColors[i]=color(hue,100*i/(countColors-1),brightness);
        }
        break;
      }
      case 2:
      {
        for (int i=0;i<countColors;i++)
        {
          gradientColors[i]=color(hue,saturation,100*i/(countColors-1));
        }
        break;
      }
    }
    gradientRectangle(xpos, ypos, swidth, sheight, gradientColors, 2);
    colorMode(RGB,255);
    //rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(255, 255, 255);
    } else {
      fill(100, 102, 102);
    }
    rect(spos-selectorWidth/2, ypos, selectorWidth, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  void setHue(float hue)
  {
    this.hue=hue;
  }
  float getHue()
  {
    return hue;
  }
  
  void setSaturation(float saturation)
  {
    this.saturation=saturation;
  }
  float getSaturation()
  {
    return saturation;
  }
  
  void setBrightness(float brightness)
  {
    this.brightness=brightness;
  }
  float getBrightness()
  {
    return brightness;
  }
  
  // Gets the lower limit of the value of this slider
  float getLowerValue()
  {
    float upperLimit;
    switch(type)
    {
      case 0:
      {
        upperLimit=360;
        break;
      }
      case 1:
      {
        upperLimit=100;
        break;     
      }
      case 2:
      {
        upperLimit=100;
        break;
      }
      default:
      {
        return -1;
      }
    }
    return floor(map(spos,xposMin,xposMax,0,upperLimit)-upperLimit*(confidenceInterval/2));
  }
  
  // Gets the upper limit of the value of this slider
  float getUpperValue()
  {
    float upperLimit;
    switch(type)
    {
      case 0:
      {
        upperLimit=360;
        break;
      }
      case 1:
      {
        upperLimit=100;
        break;     
      }
      case 2:
      {
        upperLimit=100;
        break;
      }
      default:
      {
        return -1;
      }
    }
    return ceil(map(spos,xposMin,xposMax,0,upperLimit)+upperLimit*(confidenceInterval/2));
  }
  
  // Draws a gradient rectangle
  void gradientRectangle(float x, float y, float w, float h, color[] colors, int axis ) {
  noFill();
  int colorsSize=colors.length;
  float deltaH=h/(colorsSize-1);
  float deltaW=w/(colorsSize-1);
  // CORRECT THIS
  if (axis == 1) {  // Top to bottom gradient
    float currentY=y;
    for (int k=0;k<colorsSize-1;k++)
    {
      float nextY=currentY+deltaH;
      for (float i = currentY; i <= nextY; i++) 
      {
        float inter = map(i, currentY, nextY, 0, 1);
        color c = lerpColor(colors[k], colors[k+1], inter);
        stroke(c);
        line(x, i, x+w, i);
      }
      currentY=nextY;
    }
  }  
  else if (axis == 2) {  // Left to right gradient
    float currentX=x;
    for (int k=0;k<colorsSize-1;k++)
    {
      float nextX=currentX+deltaW;
      for (float i = currentX; i <= nextX; i++) 
      {
          float inter = map(i, currentX, nextX, 0, 1);
          color c = lerpColor(colors[k], colors[k+1], inter);
          stroke(c);
          line(i, y, i, y+h);
      }
      currentX=nextX;
    }
  }
}
};
