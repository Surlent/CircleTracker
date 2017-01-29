void DrawControls() {
  surface.setSize((int)(img.width*1.5), img.height);
  hueSlider = new HScrollBar((img.width*1.1), (img.height*0.2), (img.width*0.3), (img.height*0.03), 1, 0, baseHue, baseSaturation, baseBrightness, 4, hueConfidenceInterval); // Initializes slider
  saturationSlider = new HScrollBar((img.width*1.1), (img.height*0.4), (img.width*0.3), (img.height*0.03), 1, 1, hueSlider.getHue(), hueSlider.getSaturation(), hueSlider.getBrightness(), 4, saturationConfidenceInterval); // Initializes slider
  brightnessSlider = new HScrollBar((img.width*1.1), (img.height*0.6), (img.width*0.3), (img.height*0.03), 1, 2, hueSlider.getHue(), hueSlider.getSaturation(), hueSlider.getBrightness(), 4, brightnessConfidenceInterval); // Initializes slider
  float buttonWidth=img.width*0.11;
  detectionButton = new Button((img.width*1.1)+((img.width*0.3)/2-buttonWidth)/2, (img.height*0.8), buttonWidth, (img.height*0.05), "Detect", color(255, 255, 255), color(130, 130, 130), color(0, 0, 0));
  trackingButton = new Button((img.width*1.1)+(img.width*0.15)/2+((img.width*0.3)/2-(buttonWidth))/2, (img.height*0.8), buttonWidth, (img.height*0.05), "Track", color(255, 255, 255), color(130, 130, 130), color(0, 0, 0));
}

void UpdateSliders() {
  if (hueSlider!=null)
  { 
    hueSlider.setSaturation(saturationSlider.getSaturation());
    hueSlider.setBrightness(brightnessSlider.getBrightness());
    hueSlider.update();
    hueSlider.display();
    saturationSlider.setHue(hueSlider.getHue());
    saturationSlider.setBrightness(brightnessSlider.getBrightness());
    saturationSlider.update();
    saturationSlider.display();
    brightnessSlider.setSaturation(saturationSlider.getSaturation());
    brightnessSlider.setHue(hueSlider.getHue());
    brightnessSlider.update();
    brightnessSlider.display();
    rightHueLower=hueSlider.getLowerValue();
    rightSaturationLower=saturationSlider.getLowerValue();
    rightBrightnessLower=brightnessSlider.getLowerValue();
    rightHueUpper=hueSlider.getUpperValue();
    rightSaturationUpper=saturationSlider.getUpperValue();
    rightBrightnessUpper=brightnessSlider.getUpperValue();
    //println("lowerHue:"+rightHueLower+",upperHue:"+rightHueUpper+",lowerSaturation:"+rightSaturationLower+",upperSaturation:"+rightSaturationUpper+",lowerBrightness:"+rightBrightnessLower+",upperBrightness:"+rightBrightnessUpper);
  }
}

void UpdateButtons() {
  //if (detectionButton!=null)
  //{
  //  DetectOnButtonPressed();
  //}
  //if (trackingButton!=null)
  //{
  //  TrackOnButtonPressed();
  //}
  if(trackingButton!=null){
    DetectAndTrack();
  }
}

void DetectOnButtonPressed() {
  boolean detectionButtonPressed=detectionButton.isPressed();
  detectionButton.update();
  if (detectionButton.isPressed()!=detectionButtonPressed)
  {
    detectionButton.setText((detectionButton.isPressed())?("Undetect"):("Detect"));
    println("Detection "+((detectionButton.isPressed()==true)?("started"):("stopped")));
    if (!detectionButton.isPressed())
    {
      trackingButton.pressed=false;          
      connectedComponents=null;
    }
    detecting=detectionButton.isPressed();
  }
  detectionButton.display();
}

void TrackOnButtonPressed() {
  if (detectionButton.isPressed())
  {
    boolean trackingButtonPressed=trackingButton.isPressed();
    trackingButton.update();
    if (trackingButton.isPressed()!=trackingButtonPressed)
    {        
      println("Tracking "+((trackingButton.isPressed()==true)?("started"):("stopped")));
      if (!trackingButton.isPressed()) {
        foundObjects=null;          
        tracker.setTracking(false);
      }
    }
  }  
  trackingButton.setText((trackingButton.isPressed())?("Untrack"):("Track"));
  tracking=trackingButton.isPressed();
  trackingButton.display();
}

void DetectAndTrack(){
  detecting=true;
  tracking=true;
  boolean trackingButtonPressed=trackingButton.isPressed();
  trackingButton.update();
  if (trackingButton.isPressed()!=trackingButtonPressed)
  {        
    println("Tracking "+((trackingButton.isPressed()==true)?("started"):("stopped")));
    if (!trackingButton.isPressed()) {
      foundObjects=null;          
      tracker.setTracking(false);
    }
  }
  trackingButton.setText((trackingButton.isPressed())?("Untrack"):("Track"));
  tracking=trackingButton.isPressed();
  trackingButton.display();
}