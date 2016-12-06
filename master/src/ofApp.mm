#include "ofApp.h"
#define CAMERA_RATIO 0.5729 // 1100 / 1920 Measured from the video
// Video frame rate is 29.97 FPS

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetWindowPosition(ofGetScreenWidth(), 0);
    grabber.initGrabber(ofGetWidth(), ofGetHeight());
    ofSetDataPathRoot("../Resources/data/");
    player.load("videos/Processing_Procession.mov");
    player.play();
    
    //ofToggleFullscreen();
    
    BWShader.load("shaders/BWShader");
    
    liveIndex = 0;
    lastNow = 0;
    
    liveTimes.push_back(61.56);
    liveTimes.push_back(65.8);
    liveTimes.push_back(79.47);
    liveTimes.push_back(87.67);
    liveTimes.push_back(92.13);
    liveTimes.push_back(97.67);
    liveTimes.push_back(114.07);
    liveTimes.push_back(125.5);
    liveTimes.push_back(126.4);
    liveTimes.push_back(129.23);
    liveTimes.push_back(153.00);
    
        
    auto deviceList = ofxBlackmagic::Iterator::getDeviceList();
    if(deviceList.size() > 0) {
        input = shared_ptr<ofxBlackmagic::Input>(new ofxBlackmagic::Input());
        cout<<"Setting Up Input in Display App using mode: " << control->selectedMode << endl;
        input->startCapture(deviceList[0], control->selectedMode);
        currentMode = control->selectedMode;
    }
        
    ofHideCursor();
        
    ofBackground(0);
}

//--------------------------------------------------------------
void ofApp::update(){
    player.update();
    if(control->camOn) {
        if(control->blackMagic && input != nullptr) {
            input->update();
        } else {
            grabber.update();
        }
    }
    
    if(control->autoToggleVideo) {
        float now = player.getPosition() * player.getDuration();
        if(liveIndex < liveTimes.size()) {
            if(now > liveTimes[liveIndex]) {
                control->camOn = !control->camOn;
                liveIndex++;
            }
        } else {
            if(now < lastNow) {
                liveIndex = 0;
                control->camOn = false;
            }
        }
        lastNow = now;
    }
    
    player.setPaused(!control->playing);
    
    if(control->stop) {
        control->stop = false;
        player.setPosition(0);
        player.update();
        player.setPaused(true);
        control->playing = false;
    }
    if(control->pause) {
        control->pause = false;
        control->playing = false;
        player.setPaused(true);
    }
    if(control->fullscreen) {
        ofToggleFullscreen();
        control->fullscreen = false;
    }
    
    if(control->selectedMode != currentMode && input != nullptr) {
        input->stopCapture();
        auto deviceList = ofxBlackmagic::Iterator::getDeviceList();
        input = shared_ptr<ofxBlackmagic::Input>(new ofxBlackmagic::Input());
        cout<<"Setting Up Input in Display App using mode: " << control->selectedMode << endl;
        input->startCapture(deviceList[0], control->selectedMode);
        currentMode = control->selectedMode;
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofPushMatrix();
    float x = 0;
    float y = 0;//(ofGetHeight() - player.getHeight()) / 2;
    float width;
    float height;
    float videoRatio = player.getHeight() / player.getWidth(); // Ratio of Width to height of the Video (fixed)
    float screenRatio = (float)ofGetHeight() / ofGetWidth(); // Ratio of Width to Height of the Screen currently
    if(screenRatio > videoRatio) { //  Fix x and width
        x = 0;
        width = ofGetWidth();
        height = width * videoRatio;
        
        y = (ofGetHeight() - height) / 2.0f;
    } else { //  fix y and height
        y = 0;
        height = ofGetHeight();
        width = height / videoRatio;
        
        x = (ofGetWidth() - width) / 2.0f;
    }
    
    player.draw(x, y, width, height);
    if(control->camOn) {
        BWShader.begin();
        float o_x = ofMap(control->x, 0, 1, 0, width - width * CAMERA_RATIO);
        BWShader.setUniform1f("u_Offset", o_x);
        BWShader.setUniform1f("u_Brightness", control->brightness);
        BWShader.setUniform1f("u_Contrast", control->contrast);
        if(control->blackMagic && input != nullptr) {
            //ofScale(1, ratio);
            BWShader.setUniform2f("u_Resolution", input->getWidth(), input->getHeight());
            BWShader.setUniformTexture("u_Tex", *input, 0);
            ofDrawRectangle(x, y, width * CAMERA_RATIO, height);
            //input->getTexture().drawSubsection(0, 0, ofGetWidth() * CAMERA_RATIO, input->getHeight(), 0, 0);
        } else {
            //ofScale(1, ratio);
            BWShader.setUniform2f("u_Resolution", grabber.getWidth(), grabber.getHeight());
            BWShader.setUniformTexture("u_Tex", grabber, 0);
            grabber.getTexture().drawSubsection(x, y, width * CAMERA_RATIO, height , 0, 0);
        }
        BWShader.end();
    }
    ofPopMatrix();
    
    //input->draw(0, 0);
    
    syphon.publishScreen();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if(key == 'f') {
        ofToggleFullscreen();
    }
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h) {
    //grabber.initGrabber(w, h);
}
