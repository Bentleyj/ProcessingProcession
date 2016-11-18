#pragma once

#include "ofMain.h"
#include "ControlApp.h"
#include "ofxSyphon.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
    
    vector<float> liveTimes;
    
    int liveIndex;
    float lastNow;
        
    ofVideoPlayer player;
    ofVideoGrabber grabber;
        
    ofxSyphonServer syphon;
    
    shared_ptr<ControlApp> control;
};
