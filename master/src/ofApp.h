#pragma once

#include "ofMain.h"
#include "ControlApp.h"
#include "ofxSyphon.h"
#include "ofxBlackMagic.h"
#include "ofxGui.h"

//#define SHOW_MODE

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
        void windowResized(int w, int h);
    
    vector<float> liveTimes;
    
    int liveIndex;
    float lastNow;
        
    ofVideoPlayer player;
    ofVideoGrabber grabber;
    ofShader BWShader;
    
#ifdef SHOW_MODE
    ofxSyphonServer syphon;
    
    _BMDDisplayMode currentMode;
    
    shared_ptr<ControlApp> control;
    
    shared_ptr<ofxBlackmagic::Input> input;
#else
    bool camOn;
#endif
};
