/* jason stephens  - 3 Jan 2012
 Making Things See - practice and examples
 This Branch = DepthPixels
 
 
 TODO:
 DONE_____figure out branching with git :  I'm loving this github action!!
 DONE____change the subtitle of this app here in comments with each branching
 DONE____Get INFO for each pixel:  when mouse click on a pixel, print out information on that pixel
 DONE____Translate a brightness(); value to a real world distance.  where brightness is the distance between white and black. 0-255 mapped to 0-2047
 ____access an array of higher resolution values from the kinect.
 ____Use higher resolution depthImage values to turn Kinect into tape measure by converting high res depth values to accurate measurements.
 ____Translate between a 1-D array of pixels and the 2-D image that it represents
 ____Access an entry in an array that corresponds to any location in an image
 ____uh oh, usb extension cord issues with the Kinect....  email greg bornestein:  awaiting response
 
 NOTES:
 ->Kinect; // depth resolution = 11bits per pixel (0-2047).  range: 20inches - 25feet (0-8000 millimeters). brightness() values of 0-255.  
 relationship between distance and brightness is not a simple linear ratio.
 !Kinect's depth readings have millimeter precision. If millimeter units, then how many millimeters in 25 feet?  nearly 8000 millimeters. 
 8000 millimeters is far more than can fit in the bit depth of the depth image pixels (0-255).  How do we map these 2?  use the map() function?
 Using map() function would be like pulling stretchy cloth to cover a large area: more cloth isn't created, just space added between threads.
 Mapping brightness() to 8000millimeters would stretch 255 without enough information to cover intermediate values.  
 In order to cover all 8000 distance values without holes, we need to access the depth data from the Kinect in some higher resolution form.
 Asking brightness() of a depth pixel reduces the 11bit resolution (0-2047) to 8bits (0-255).
 
 
 ->PImage(); // class provides all kinds of useful functionso for working with images such as the ability to access and alter individual pixels
 Having the Kinect data in the form of a PImage is an advantage because it means we can use the kinect data with other libraries
 that themselves don't know anything about the kinect, but do know how to process PImages.  PImages force the use of 8bit pixel depth. 
 Using PImage to store and draw depthImage requires a compression of depthImage's 11bit pixel depth to 8bit.  0-2047 vs 0-255.
 Advantage of using PImage reduction of depthImage is conservation of CPU.  no need for that many shades of gray.  
 
 ->frameRate(); //Kinect delivers 30fps.  Processing tries for 60Hertz.  If we loop more or less than 30cycles/sec, then we get either 
 too few or too many images per loop.  Keeping Processing looping at same rate of Kinect framerate is ideal.  
 Cannot simply set frameRate in the sketch to (30), since we do not know the load placed on the app while running, especially if interactive.
 
 ->depthImage(); // the color of each pixel in the depth image represents the distance in that part of the scene (0-255) GREYSCALE;
 r()g()b() extracted values from color variable passed by return from get() at mouseX mouseY reveals 3 equal values.  sine color is difference
 between rgb values, greyscale will always have 3 equal values.  BRIGHTNESS is the DISTANCE between white and black.
 But what of the pixels ACTUAL DEPTH?  How far away is a greyscale brightness() extracted value of 142 or 19?
 To access depthImage:  compress and store 11bit into 8bit PImage, draw PImage, get() brightness() of drawn pixel. But this is impratical when
 we want to access the depthImage at its full 11bit resolution, or when we want to access more than a single pixel's worth of depth value
 How do I access the depth data without having to first display the pixels?  Ans: access the array of pixels directly (while they are offstage)
 In Processing and most Graphics Programming Environments, image data is stored as arrays of pixels behind the scenes.  Accessing these arrays
 directly will let our programs run fast enough to do some really interesting things (eg. working with the higher resolution data 
 and processing more than one pixel at a time)
 
 ->rgbImage(); //  each pixel of the color image has 3 components (0-255) for R, G, and B.
 
 ->get(); // a function provided by Processing to let me access the value of any pixel ALREADY drawn on the screen. In this program
 pixels are drawn from Kinect depth and rgb image.  the function takes two arguments X and Y coordinates.
 
 ->color(); // color is a variable type used to store color.  since get() returns a color value, we store get() info into color variable c.
 
 ->red(), green(), blue() // Processing functions used to extract each of these component values from the color variable type.
 color comes from a difference between indicudual color compenents (128,10,10)=red, (128,128,128)=grey (250,128,128)=red
 overall brightness is determined by the sum total between the levels of all 3 components
 
 ->brightness(); // Processing function used to extract the value of a pixels distance between white and black. (like red(),green()blue().
 clicking around in the black areas of the depth image reveals different brightness values even though the image is definitely BLACK.
 Why is there detailed depth information even in parts of the image where the eye can't see different shades of grey?
 Looking for gaps in pixels brightness = edge detection.  Looking for brightest pixel = closest point to kinect. 
 How do we translate from brightness() value to real world distance? 
 
 1-D Arrays of 2-D images; //  TRANSLATIONS!!  how do we figure out which pixel is clicked on (TRANSLATE from image to array)?  how do we draw something on the screen
 where we found a particular depth value (TRANSLATE from array to image)?  How do I convert between array in which pixel is stored and pixel's position
 
 
 */

import SimpleOpenNI.*;  //importing the SimpleOpenNI library, which is a wrapper for the OpenNI toolkit provided by PrimeSense
SimpleOpenNI kinect;  // declares the SimpleOpenNI object and names it "kinect."  this object is used to access of the Kinect's data
// we use dot syntax to call functions on this object to get depth, color, skeleton etc.
//I've declared it here, but don't instantiate it until setup function

void setup() {
  size (640, 480); // declare the size of our application.  width set to doube the width of both Depth and RGB
  kinect = new SimpleOpenNI(this); //instantiate the previously declared instance of the SimpleOpenNI object

  //TURN ON ACCESS DEPTH IMAGES FROM KINECT
  /* call the enableDepth() methods on our 'kinect' instance of the SimpleOpenNI object
 this method tells the library that we we are going to want access (in draw) to the kinect's depth.
   Depending on the application, I may use 1 or neither of these.  By telling the library in advance, we give it extra time.  the library
   only has to ask the Kinect for the data we actually use.  Setup allows the request to be staged without being used unless it's 
   needed.  Everything runs smoother and faster this way.*/
  kinect.enableDepth(); // enableDepth() method using dot syntax to attach this function to the specific instance of the SimpleOpenNI object
 // kinect.enableRGB(); // disable the enableRGB() method. strictly depthImage now.
}
void draw () {
  //UPDATE the DEPTH IMAGES FROM KINECT
  kinect.update();  //call the update function on the 'kinect' object.  why is this a function and not a method?
  // the update funtion tells the SimpleOpenNI library to get fresh data from the Kinect so we can work with it.
  // this fucntion will pull different data depending on which enable funcitons were pulled in setup.  

  // rather than pass the return values of these kinect image-accessing funcitons directly to image functions, 
  // we can store the return type in a local PImage variable, and then pass the entire PImage to the image functions.
  PImage depthImage = kinect.depthImage();  // this makes the return type of the image-accessing function explicit
  image(depthImage, 0, 0);  // the kinect.depth is already called; its return type is stored in a PImage which is passed to this image function
 
}

// Get INFO for each pixel:  when mouse click on a pixel, print out information on that pixel
void mousePressed () {  // this function gets called everytime whenever mousePressed inside the running app
int[] depthValues = kinect.depthMap(); //creat an array called depthValues from this instance of the kinect object's depthMap
int clickPosition = mouseX + (mouseY*640); //the clicked pixel's position in the 1-D array is its mouseX value + the total value of mouseY*screen.width
int clickedDepth = depthValues[clickPosition]; // go to clickPosition index on the 1-D array, get that value and store it in clickedDepth variable.

float inches = clickedDepth/25.4; // if clickedDepth is 0-8000? how would / by 25.4 work?  1inch * 12 is a foot.  1 foot * 25 = range of kinect
// 12inches * 25 feet = 400inches/25feet.  8000millimeters/25feet.  8000

println("inches: " + inches);
}
 
