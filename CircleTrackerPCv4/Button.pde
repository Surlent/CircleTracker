class Button
{
  float swidth, sheight;    // width and height of button
  float xpos, ypos;       // x and y position of button
  float textX,textY; // positions for text to be displayed
  boolean pressed=false; // whether mouse is pressed
  boolean locked=false; // whether button state can be changed
  String text; // text shown on button
  color normalColor; // the color for unpressed button
  color highlightColor; // the color for pressed button
  color textColor; // the color for text
  Button(float xpos,float ypos,float swidth,float sheight,String text,color normalColor,color highlightColor,color textColor)
  {
    this.xpos=xpos;
    this.ypos=ypos;
    this.swidth=swidth;
    this.sheight=sheight;
    this.text=text;
    this.textX=xpos+swidth/2-textWidth(text)/2;
    this.textY=ypos+sheight*0.75;
    this.normalColor=normalColor;
    this.highlightColor=highlightColor;
    
  }
  void setText(String text)
  {
    this.text=text;
    this.textX=xpos+swidth/2-textWidth(text)/2;
    this.textY=ypos+sheight*0.75;
  }
  void display() {
//    update(mouseX, mouseY);
    if (overEvent()) {
      fill(highlightColor);
    } else {
      fill(normalColor);
    }
    stroke(255);
    rect(xpos, ypos, swidth, sheight);
    fill(textColor);
    text(text,textX,textY);
  }
  
  void update()
  {
    if (mousePressed && overEvent() &&!locked)
    {
      pressed=!pressed;
      locked=true;
    }
    if(!mousePressed&&locked)
    {
      locked=false;
    }
  }
  
  boolean overEvent()
  {
     if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }
  boolean isPressed()
  {
    return pressed;
  }
};
