#pragma once

#include "ofMain.h"
#include "ControlApp.h"
#include "ofxSyphon.h"
#include "ofxBlackMagic.h"
#include "ofxGui.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
        void windowResized(int w, int h);
    
    vector<float> liveTimes;
    
    _BMDDisplayMode currentMode;
    
    int liveIndex;
    float lastNow;
        
    ofVideoPlayer player;
    ofVideoGrabber grabber;
        
    ofxSyphonServer syphon;
    
    shared_ptr<ControlApp> control;
    
    shared_ptr<ofxBlackmagic::Input> input;
        
    ofShader BWShader;
};
