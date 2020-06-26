# SimpleIKPosenet
Just a quite simple initial experiment with posenet and IK.

The current Sketch allow to modify the target's position (red sphere) with the nose that a Kinematic chain must reach. 
To do so an adaptation of [this p5 sketch](https://editor.p5js.org/kylemcdonald/sketches/H1OoUd9h7) is used to send the skeleton data to a Processing sketch.
The Processing sketch uses a experimental distribution of the [nub](https://github.com/VisualComputing/nub) library to generate the Kinematic chain and handle the IK behavior.  

## Example
![Example](https://github.com/sechaparroc/SimpleIKPosenet/blob/master/posenet.gif)

## Installation

 ```sh
 $ git clone https://github.com/sechaparroc/SimpleIKPosenet.git
 $ cd SimpleIKPosenet
 ```
## Setup

1. Install [Node.js](http://nodejs.org/)

2. Download (nub with IK)[https://github.com/VisualComputing/nub/blob/ik/distribution/nub-7/download/nub.zip] and put it in the Processing libraries folder.

3. Install npm dependencies

 ```sh
 $ npm install
 ```

4. Run index.js to create a local HTTP server that listens at port 3000

 ```sh
 $ node index.js
 ```

5. Open <http://localhost:3000> to interact with the p5.js posenet example.

6. Run the posenetSketch in Processing.

7. Have fun.
