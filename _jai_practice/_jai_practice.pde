/* jason stephens
Making Things See - practice and examples
1 jan 2012  WHAT?

TODO
_____figure out branching with git

Here we go
*/

import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
 size (640*2, 480);
kinect = new SimpleOpenNI(this);

kinect.enableDepth(); // dot enableDepth
kinect.enableRGB(); // dot syntax enableRGB 
}

void draw () {
 kinect.update();

image(kinect.depthImage(),0,0); // .depthImage
image(kinect.rgbImage(),640,0);  // .rgbImage
  
}
