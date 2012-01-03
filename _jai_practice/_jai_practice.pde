/* jason stephens
Making Things See - practice and examples
1 jan 2012  WHAT?

TODO
_____figure out branching with git

Here we go
*/

import SimpleOpenNI.*;  //importing the SimpleOpenNI library, which is a wrapper for the OpenNI toolkit provided by PrimeSense
SimpleOpenNI kinect;  // declares the SimpleOpenNI object and names it "kinect."  this object is used to access of the Kinect's data
// we use dot syntax to call functions on this object to get depth, color, skeleton etc.
//I've declared it here, but don't instantiate it until setup function

void setup() {
 size (640*2, 480); // declare the size of our application.  width set to doube the width of both Depth and RGB
kinect = new SimpleOpenNI(this); //initialize this previously declared object

kinect.enableDepth(); // dot enableDepth
kinect.enableRGB(); // dot syntax enableRGB 
}

void draw () {
 kinect.update();

image(kinect.depthImage(),0,0); // .depthImage
image(kinect.rgbImage(),640,0);  // .rgbImage
  
}
