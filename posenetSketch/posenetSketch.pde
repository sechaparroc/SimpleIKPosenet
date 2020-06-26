import http.requests.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;
//this packages are required for ik behavior
import nub.ik.animation.*;
import nub.ik.solver.*;

JSONObject lastPoseJSON; //Keeps the last keypoints from posenet
HashMap<String, Vector> keyPointsMap = new HashMap<String, Vector>();

//Nub variables
Scene scene; 
Node target; //Here we are just tracking 1 target, modify this to track more than a target
Skeleton skeleton; //Setup the skeleton to interact with


public void setup() 
{
  size(800,600, P3D);
  //Setup the scene
  scene = new Scene(this);
  scene.setRadius(200);
  scene.fit(1);
  //Setup the skeleton
  setupSkeleton();
  
}

public void draw(){
  //Render the scene
  background(0);
  if(scene.is3D()) lights();
  scene.drawAxes();
  scene.render();

  //Read the last pose at each frame
  
  lastPoseJSON = getPosenet();
  //Keep the info of the keypoints
  if(lastPoseJSON != null){
    JSONToInfo();
    updateTargetFromKeyPoint("nose", target);
  }
}

//Parse the JSON object to keep just with the information that we are interested in
public void JSONToInfo(){
  if(lastPoseJSON == null || lastPoseJSON.getJSONObject("pose") == null) return;
  JSONArray keyPoints = lastPoseJSON.getJSONObject("pose").getJSONArray("keypoints");
  //Update the info of the scene based on this keypoints
  keyPointsMap.clear();
  for(int i = 0; i < keyPoints.size(); i++){
    JSONObject keyPoint = keyPoints.getJSONObject(i);
    //Check if its accurate, if not do not add the keypoint
    if(keyPoint.getFloat("score") < 0.6) continue;    
    //Note that the info is flipped horizontally and its based on a 600 X 800 resolution
    Vector screenPosition = new Vector();
    screenPosition.setX(800 - keyPoint.getJSONObject("position").getFloat("x"));
    screenPosition.setY(keyPoint.getJSONObject("position").getFloat("y"));
    keyPointsMap.put(keyPoint.getString("part"), screenPosition);
  }
}

//Do a Get request to the simple http server to obtain the info of the last pose
public JSONObject getPosenet(){
  GetRequest get = new GetRequest("http://127.0.0.1:3000/posenet");
  get.send(); // program will wait untill the request is completed
  //Print the response object to see its structure
  //println("response: " + get.getContent());
  if(get.getContent() != null){
    return parseJSONObject(get.getContent());
  }
  return null;
}

//Nub stuff

//Create the skeleton enable IK and keep the references of the targets to interact with 
public void setupSkeleton(){
  //You are encouraged to modify the skeleton structure
  Skeleton skeleton = new Skeleton(scene);
  Joint initial = skeleton.addJoint("Joint 0");
  for(int i = 0; i < 8; i++){
    Joint next = skeleton.addJoint("Joint " + (i + 1), "Joint " + i);
    next.translate(new Vector(0,40));
  }
  
  //Keep in mind that last joint is Joint 8
  //Execute an IK task each time the target is modified
  skeleton.enableIK();
  //Add the targets and keep its reference to update them with the info readed from the pose
  target = skeleton.addTarget("Joint 8");
  //Do a similar procedure with for other targets ...
}

//Use the vector in screen space to relocate the target position
//Modify this function to allow the translation of more targets
void updateTargetFromKeyPoint(String keyPoint, Node target){
  if(!keyPointsMap.containsKey(keyPoint)) return;
  //This is the new desired pos in screen from the target
  Vector screenDesired = keyPointsMap.get(keyPoint);
  //Find the current target position with respect to the screen space
  Vector screenCurrent = scene.screenLocation(target);
  //Calculate the displacement
  Vector displacement = Vector.subtract(screenDesired, screenCurrent);
  displacement.setZ(0);
  //As we want the node keep in the same depth Z displacement must be Zero
  //Apply this displacement to the Target
  scene.translateNode(target, displacement.x(), displacement.y(), 0);
}



void mouseMoved() {
    scene.mouseTag();
}

void mouseDragged() {
    if (mouseButton == LEFT){
        scene.mouseSpin();
    } else if (mouseButton == RIGHT) {
        scene.mouseTranslate();
    } else {
        scene.scale(mouseX - pmouseX);
    }
}

void mouseWheel(MouseEvent event) {
    scene.scale(event.getCount() * 20);
}

void mouseClicked(MouseEvent event) {
    if (event.getCount() == 2)
        if (event.getButton() == LEFT)
            scene.focus();
        else
            scene.align();
}
