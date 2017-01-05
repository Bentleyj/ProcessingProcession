#pragma once

#include "ofMain.h"
#include "ofxGui.h"
#include "ofxBlackMagic.h"

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
        void onBmdModeChanged(ofAbstractParameter & param);

    
    map<string, _BMDDisplayMode> bmdModes;
    _BMDDisplayMode selectedMode;
    
    ofImage title;
    
    ofxPanel gui;
    
    ofParameterGroup cameraSourceGroup;
    ofParameterGroup videoControlGroup;
    ofParameterGroup cameraSettingsGroup;
    ofParameterGroup cameraModesGroup;
    
    ofParameter<bool> camOn;
    ofParameter<bool> playing;
    ofParameter<bool> pause;
    ofParameter<bool> stop;
    ofParameter<bool> blackMagic;
    ofParameter<bool> fullscreen;
    
    ofParameter<float> contrast;
    ofParameter<float> brightness;
    ofParameter<float> x;
    
    ofParameter<bool> autoToggleVideo;
    ofParameter<bool> recording;
};
