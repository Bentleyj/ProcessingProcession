#include "ofApp.h"
#define CAMERA_RATIO 0.6

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetWindowPosition(0, 0);
    ofToggleFullscreen();
    grabber.initGrabber(1280*CAMERA_RATIO, 720);
    player.load("videos/processing.procession.mp4");
    player.play();
    
    liveIndex = 0;
    lastNow = 0;
    
    liveTimes.push_back(61);
    liveTimes.push_back(66);
    liveTimes.push_back(79);
    liveTimes.push_back(88);
    liveTimes.push_back(92);
    liveTimes.push_back(98);
    liveTimes.push_back(114);
    liveTimes.push_back(126);
    liveTimes.push_back(130);
    liveTimes.push_back(154);

    //glfwWindowHint(GLFW_DECORATED, GL_FALSE);
}

//--------------------------------------------------------------
void ofApp::update(){
    player.update();
    if(!control->vidOn) {
        grabber.update();
    }
    
    if(control->autoToggleVideo) {
        float now = player.getPosition() * player.getDuration();
        if(liveIndex < liveTimes.size()) {
            if(now > liveTimes[liveIndex]) {
                control->vidOn = !control->vidOn;
                liveIndex++;
            }
        } else {
            if(now < lastNow)
                liveIndex = 0;
        }
        lastNow = now;
    }
    
    player.setPaused(!control->playing);
    
    if(control->stop) {
        control->stop = false;
        player.setPosition(0);
        player.setPaused(true);
        control->playing = false;
    }
    if(control->pause) {
        control->pause = false;
        control->playing = false;
        player.setPaused(true);
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    player.draw(0, 0, ofGetWidth(), ofGetHeight());

    if(!control->vidOn) {
        grabber.draw(0, 0, ofGetWidth() * CAMERA_RATIO, ofGetHeight());
    }
    
    
    syphon.publishScreen();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}
