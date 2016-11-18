#pragma once

#include "ofMain.h"
#include "ofxGui.h"

class ControlApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
        void onRecordingChanged(bool & _r);
        void onPlayChanged(bool & _r);
        void onPauseChanged(bool & _r);
        void onStopChanged(bool & _r);


    
    ofxPanel gui;
    
    ofParameterGroup videoControlGroup;
    ofParameterGroup recordingControlGroup;
    
    ofParameter<bool> vidOn;
    ofParameter<bool> playing;
    ofParameter<bool> pause;
    ofParameter<bool> stop;
    
    ofParameter<bool> autoToggleVideo;
    ofParameter<bool> recording;
};
