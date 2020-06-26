/*
    This code generates a simple Http server to send the posenet info from a p5.js sketch (public/ sketch)
    to a Procesing sketch (posenetSketch).

    This is based on the great Daniel Shiffman 's course Working with Data and APIs in JavaScript
    More info at https://www.youtube.com/playlist?list=PLRqwX-V7Uu6YxDKpFzf_2D84p0cyk4T7X
*/

const express = require('express');
const app = express();

app.listen(3000, () => console.log('Listening at port 3000'));
app.use(express.static('public'));
app.use(express.json());

let lastPose;

app.get("/posenet", (request, response) => {
    response.json(lastPose);
});

app.post("/posenet", (request, response) => {
    lastPose = request.body;
    response.end();
});

