#include "ControlApp.h"

//--------------------------------------------------------------
void ControlApp::setup(){
    vidOn = true;
    
    gui.setup("Controls", "settings/controls/xml");
    videoControlGroup.setName("Video Controls");
    videoControlGroup.add(vidOn.set("Video Playing", true));
    videoControlGroup.add(playing.set("Play", true));
    videoControlGroup.add(pause.set("Pause", false));
    videoControlGroup.add(stop.set("Stop", false));
    gui.add(recording.set("Recording", false));
    gui.add(autoToggleVideo.set("Auto Camera Activation", true));
    
    gui.add(videoControlGroup);
    
    recording.addListener(this, &ControlApp::onRecordingChanged);
}

//--------------------------------------------------------------
void ControlApp::update(){

}

//--------------------------------------------------------------
void ControlApp::draw(){
    gui.draw();
}

//--------------------------------------------------------------
void ControlApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ControlApp::keyReleased(int key){
    if(key == 'r') {
        recording = !recording;
    } else if(key == ' ') {
        vidOn = !vidOn;
    }
}

//--------------------------------------------------------------
void ControlApp::onRecordingChanged(bool & _r) {
    //Send the info the the recorder
    string myScript;
    
    myScript += "osascript ";
    myScript += "-e 'tell application \"System Events\"' ";
    myScript += "-e 'key code 15 using {command down, option down}' ";
    myScript += "-e 'end tell' ";
    
    ofLog()<<"myScript "<<myScript;
    
    system(myScript.c_str());
    
    //link to key codes
    //http://web.archive.org/web/20100501161453/http://www.classicteck.com/rbarticles/mackeyboard.php
}

