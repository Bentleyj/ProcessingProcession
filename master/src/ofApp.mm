#include "ofApp.h"
#import <Cocoa/Cocoa.h>
#define CAMERA_RATIO 0.5729 // 1100 / 1920 Measured from the video
// Video frame rate is 29.97 FPS

//--------------------------------------------------------------
void ofApp::setup(){
#ifdef SHOW_MODE
    ofSetWindowPosition(ofGetScreenWidth(), 0);
#endif
    ofSetDataPathRoot("../Resources/data/");
    player.load("videos/Processing_Procession.mov");
    player.play();
    
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
    
    //CGCaptureAllDisplays();
    NSWindow * appWindow = (NSWindow *)ofGetCocoaWindow();
    if(appWindow) {
        NSMenu* bar = [[NSApplication sharedApplication] mainMenu];
        NSMenuItem* InfoItem = [bar itemAtIndex:0];
        //[bar removeAllItems];
        
    }
    
    ofHideCursor();
    
    ofBackground(0);
    
#ifdef SHOW_MODE
    auto deviceList = ofxBlackmagic::Iterator::getDeviceList();
    if(deviceList.size() > 0) {
        input = shared_ptr<ofxBlackmagic::Input>(new ofxBlackmagic::Input());
        cout<<"Setting Up Input in Display App using mode: " << control->selectedMode << endl;
        input->startCapture(deviceList[0], control->selectedMode);
        currentMode = control->selectedMode;
    }
#else
    ofToggleFullscreen();
    camOn = false;
#endif
    float width;
    float height;
    float videoRatio = player.getHeight() / player.getWidth(); // Ratio of Width to height of the Video (fixed)
    float screenRatio = (float)ofGetHeight() / ofGetWidth(); // Ratio of Width to Height of the Screen currently
    if(screenRatio > videoRatio) { //  Fix x and width
        width = ofGetWidth();
        height = width * videoRatio;
    } else { //  fix y and height
        //y = 0;
        height = ofGetHeight();
        width = height / videoRatio;
        
       // x = (ofGetWidth() - width) / 2.0f;
    }
    grabber.initGrabber(1280, 720);


}

//--------------------------------------------------------------
void ofApp::update(){
    player.update();
#ifdef SHOW_MODE
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
#else
    if(camOn) {
        grabber.update();
    }
    float now = player.getPosition() * player.getDuration();
    if(liveIndex < liveTimes.size()) {
        if(now > liveTimes[liveIndex]) {
            camOn = !camOn;
            liveIndex++;
        }
    } else {
        if(now < lastNow) {
            liveIndex = 0;
            camOn = false;
        }
    }
    lastNow = now;
#endif
    cout<<ofGetWindowHeight()<<endl;
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
#ifdef SHOW_MODE
    if(control->camOn) {
        BWShader.begin();
        BWShader.setUniform1f("u_Brightness", control->brightness);
        BWShader.setUniform1f("u_Contrast", control->contrast);
        if(control->blackMagic && input != nullptr) {
            //ofScale(1, ratio);
            //float o_x = ofMap(control->x, 0, 1, 0, input->getWidth() - width * CAMERA_RATIO);
            BWShader.setUniform2f("u_Offset", x, y);
            BWShader.setUniform2f("u_CamResolution", input->getWidth(), input->getHeight());
            BWShader.setUniform2f("u_WindowResolution", width * CAMERA_RATIO, height);            BWShader.setUniformTexture("u_Tex", *input, 0);
            //input->draw(x, y, width * CAMERA_RATIO, height);
            ofDrawRectangle(x, y, width * CAMERA_RATIO, height);
            //input->getTexture().drawSubsection(0, 0, ofGetWidth() * CAMERA_RATIO, input->getHeight(), 0, 0);
        } else {
            //ofScale(1, ratio);
            //float o_x = ofMap(control->x, 0, 1, 0, grabber.getWidth() - width * CAMERA_RATIO);
            BWShader.setUniform2f("u_Offset", x, y);
            BWShader.setUniform2f("u_CamResolution", grabber.getWidth(), grabber.getHeight());
            BWShader.setUniform2f("u_WindowResolution", width * CAMERA_RATIO, height);
            BWShader.setUniform2f("u_ScreenResolution", ofGetWidth(), ofGetHeight());
            BWShader.setUniformTexture("u_Tex", grabber, 0);
            ofDrawRectangle(x, y, width * CAMERA_RATIO, height);
            //grabber.draw(x, y, width * CAMERA_RATIO, height);
            //grabber.getTexture().drawSubsection(x, y, width * CAMERA_RATIO, height , 0, 0);
        }
        BWShader.end();
    }
    ofPopMatrix();
    
    //input->draw(0, 0);
    
    syphon.publishScreen();
#else
    if(camOn) {
        BWShader.begin();
        BWShader.setUniform1f("u_Brightness", 0.0);
        BWShader.setUniform1f("u_Contrast", 1.0);
        BWShader.setUniform2f("u_Offset", x, y);
        BWShader.setUniform2f("u_CamResolution", grabber.getWidth(), grabber.getHeight());
        BWShader.setUniform2f("u_WindowResolution", width * CAMERA_RATIO, height);
        BWShader.setUniform2f("u_ScreenResolution", ofGetWidth(), ofGetHeight());
        BWShader.setUniformTexture("u_Tex", grabber, 0);
        ofDrawRectangle(x, y, width * CAMERA_RATIO, height);
        BWShader.end();
        
        //grabber.draw(0, 0);
        //grabber.draw(0, 0);
    }

#endif
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
