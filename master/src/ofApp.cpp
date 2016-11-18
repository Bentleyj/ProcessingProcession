#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    grabber.initGrabber(1280, 720);
    player.load("videos/processing.procession.mp4");
    player.play();
    vidOn = true;
}

//--------------------------------------------------------------
void ofApp::update(){
    if(vidOn) {
        player.update();
    } else {
        grabber.update();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    if(vidOn) {
        player.draw(0, 0, ofGetWidth(), ofGetHeight());
    } else {
        grabber.draw(0, 0, ofGetWidth(), ofGetHeight());
    }
    
    syphon.publishScreen();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if(key == ' ') {
        vidOn = !vidOn;
        if(vidOn) {
            player.setPaused(false);
        } else {
            player.setPaused(true);
        }
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
