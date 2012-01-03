/* jason stephens  - 3 Jan 2012
 Making Things See - practice and examples
 This Branch = LookingAtPixels

 
 TODO:
 DONE_____figure out branching with git
 ____change the subtitle of this app here in comments with each branching
       
 
 

 */

import SimpleOpenNI.*;  //importing the SimpleOpenNI library, which is a wrapper for the OpenNI toolkit provided by PrimeSense
SimpleOpenNI kinect;  // declares the SimpleOpenNI object and names it "kinect."  this object is used to access of the Kinect's data
// we use dot syntax to call functions on this object to get depth, color, skeleton etc.
//I've declared it here, but don't instantiate it until setup function

void setup() {
  size (640*2, 480); // declare the size of our application.  width set to doube the width of both Depth and RGB
  kinect = new SimpleOpenNI(this); //instantiate the previously declared instance of the SimpleOpenNI object

  /* call two methods on our 'kinect' instance of the SimpleOpenNI object
   these two methods are the way of telling the library that we we are going to want access (in draw) to the kinect's depth and RGB.
   Depending on the application, I may use 1 or neither of these.  By telling the library in advance, we give it extra time.  the library
   only has to ask the Kinect for the data we actually use.  Setup allows the request to be staged without being used unless it's 
   needed.  Everything runs smoother and faster this way.*/
  kinect.enableDepth(); // enableDepth() method using dot syntax to attach this function to the specific instance of the SimpleOpenNI object
  kinect.enableRGB(); // enableRGB() method using dot syntax to associate function with the specific instance of the SimpleOpenNI object 'kinect'
}

void draw () {
  kinect.update();  //call the update function on the 'kinect' object.  why is this a function and not a method?
  // the update funtion tells the SimpleOpenNI library to get fresh data from the Kinect so we can work with it.
  // this fucntion will pull different data depending on which enable funcitons were pulled in setup.  

  // rather than pass the return values of these kinect image-accessing funcitons directly to image functions, 
  // we can store the return type in a local PImage variable, and then pass the entire PImage to the image functions.
  PImage depthImage = kinect.depthImage();  // this makes the return type of the image-accessing function explicit
  PImage rgbImage = kinect.rgbImage();
  //storing the return type in a PImage serves to make explicit the return type of our two image-accessing functions.

  /*PImage class provides all kinds of useful functionso for working with images such as the ability to access and alter individual pixels
   Having the Kinect data in the form of a PImage is an advantage because it means we can use the kinect data with other libraries
   that themselves don't know anything about the kinect, but do know how to process PImages. */

  //image(kinect.depthImage(), 0, 0); // by calling kinect.depthImage inline within the arguments for image, we never see the return value
  image(depthImage, 0, 0);  // the kinect.depth is already called; its return type is stored in a PImage which is passed to this image function
  //image(kinect.rgbImage(),640,0); //by calling the kinect.rgbImage within the argument for image, we never see the return value from kinect.rgbImage
  image(rgbImage, 640, 0);  // PImage rgbImage stores the return value from kinect.rgbImage and passes it to the image function.
}

