#include "ControlApp.h"

//--------------------------------------------------------------
void ControlApp::setup(){
    camOn = true;
    
    ofSetDataPathRoot("../Resources/data");
    
    gui.setup("Controls", "settings/controls.xml");
    videoControlGroup.setName("Video Controls");
    videoControlGroup.add(playing.set("Play", true));
    videoControlGroup.add(pause.set("Pause", false));
    videoControlGroup.add(stop.set("Stop", false));
    gui.add(camOn.set("Camera On", false));
    gui.add(recording.set("Recording", false));
    gui.add(autoToggleVideo.set("Auto Camera Activation", true));
    gui.add(blackMagic.set("Black Magic On", true));
    gui.add(fullscreen.set("Toggle Fullscreen", false));
    
    cameraSettingsGroup.setName("Camera Settings");
    cameraSettingsGroup.add(contrast.set("Contrast", 1, 0, 2));
    cameraSettingsGroup.add(brightness.set("Brightness", 0, 0, 1));
    cameraSettingsGroup.add(x.set("Camera Offset", 0, 0, 1));

    gui.add(videoControlGroup);
    gui.add(cameraSettingsGroup);
    
    recording.addListener(this, &ControlApp::onRecordingChanged);
    
    bmdModes["bmdModeNTSC"] = bmdModeNTSC;
    bmdModes["bmdModeNTSC2398"] = bmdModeNTSC2398;
    bmdModes["bmdModePAL"] = bmdModePAL;
    bmdModes["bmdModeNTSCp"] = bmdModeNTSCp;
    bmdModes["bmdModePALp"] = bmdModePALp;
    bmdModes["bmdModeHD1080p2398"] = bmdModeHD1080p2398;
    bmdModes["bmdModeHD1080p24"] = bmdModeHD1080p24;
    bmdModes["bmdModeHD1080p25"] = bmdModeHD1080p25;
    bmdModes["bmdModeHD1080p2997"] = bmdModeHD1080p2997;
    bmdModes["bmdModeHD1080p30"] = bmdModeHD1080p30;
    bmdModes["bmdModeHD1080i50"] = bmdModeHD1080i50;
    bmdModes["bmdModeHD1080i5994"] = bmdModeHD1080i5994;
    bmdModes["bmdModeHD1080i6000"] = bmdModeHD1080i6000;
    bmdModes["bmdModeHD1080p50"] = bmdModeHD1080p50;
    bmdModes["bmdModeHD1080p5994"] = bmdModeHD1080p5994;
    bmdModes["bmdModeHD1080p6000"] = bmdModeHD1080p6000;
    bmdModes["bmdModeHD720p50"] = bmdModeHD720p50;
    bmdModes["bmdModeHD720p5994"] = bmdModeHD720p5994;
    bmdModes["bmdModeHD720p60"] = bmdModeHD720p60;
    bmdModes["bmdMode2k2398"] = bmdMode2k2398;
    bmdModes["bmdMode2k24"] = bmdMode2k24;
    bmdModes["bmdMode2k25"] = bmdMode2k25;
    bmdModes["bmdMode4K2160p2398"] = bmdMode4K2160p2398;
    bmdModes["bmdMode4K2160p24"] = bmdMode4K2160p24;
    bmdModes["bmdMode4K2160p25"] = bmdMode4K2160p25;
    bmdModes["bmdMode4K2160p2997"] = bmdMode4K2160p2997;
    bmdModes["bmdMode4K2160p30"] = bmdMode4K2160p30;
    bmdModes["bmdMode4K2160p50"] = bmdMode4K2160p50;
    bmdModes["bmdMode4K2160p5994"] = bmdMode4K2160p5994;
    bmdModes["bmdMode4K2160p60"] = bmdMode4K2160p60;
    bmdModes["bmdModeUnknown"] = bmdModeUnknown;
    
    cameraModes.setName("BMD Camera Modes");
    for(auto mode = bmdModes.begin(); mode != bmdModes.end(); mode++) {
        ofParameter<bool> modeToggle;
        cameraModes.add(modeToggle.set(mode->first, false));
    }
    
    selectedMode = bmdModes["bmdModeHD1080p2997"];
    cout<<"Set Selected Mode in Control App to: " << selectedMode << endl;
    gui.add(cameraModes);
    
    gui.loadFromFile("settings/controls.xml");
    
    for(auto mode = bmdModes.begin(); mode != bmdModes.end(); mode++) {
        ofParameter<bool> selectedParam = cameraModes.getBool(mode->first);
        if(selectedParam) {
            selectedMode = mode->second;
            break;
        }
    }
    
    auto deviceList = ofxBlackmagic::Iterator::getDeviceList();
    if(deviceList.size() == 0) {
        blackMagic = false;
    }
    
    ofAddListener(cameraModes.parameterChangedE(), this, &ControlApp::onBmdModeChanged);
    
}

//--------------------------------------------------------------
void ControlApp::update(){

}

//--------------------------------------------------------------
void ControlApp::draw(){
    gui.draw();
    
    float x, y;
    x = gui.getPosition().x + gui.getWidth() + 10;
    y = gui.getPosition().y + 10;
    
    ofSetColor(0);
    
    ofDrawBitmapString("Controls:", x, y);
    y += 15;
    ofDrawBitmapString("'r' Toggles recording if Syphon Recorder is open", x, y);
    y += 15;
    ofDrawBitmapString("http://syphon.v002.info/recorder/", x, y);
    y += 15;
    ofDrawBitmapString("'p' Toggles play/pause", x, y);
    y += 15;
    ofDrawBitmapString("'s' Stops video", x, y);
    y += 15;
    ofDrawBitmapString("'c' Toggles camera", x, y);
    y += 15;
    ofDrawBitmapString("Note: Toggling camera is only recommended if", x, y);
    y += 15;
    ofDrawBitmapString("Auto Camera Activation is toggled off", x, y);
    y += 15;
    
    x = gui.getPosition().x + 10;
    y = gui.getPosition().y + 10 + gui.getHeight() + 15;
    ofDrawBitmapString("Processing Procession\n Artist Filmographer: Bafic\n Software Development: Hellicar Studio", x, y);
    
}

//--------------------------------------------------------------
void ControlApp::keyPressed(int key){
    if(key == 'p') {
        playing = !playing;
    }
    if(key == 's') {
        stop = !stop;
    }
}

//--------------------------------------------------------------
void ControlApp::keyReleased(int key){
    if(key == 'r') {
        recording = !recording;
    } else if(key == 'c') {
        camOn = !camOn;
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


//--------------------------------------------------------------
void ControlApp::onBmdModeChanged(ofAbstractParameter & param) {
    cout<<"Selected mode changing!"<<endl;
    string clickedName = param.getName();
    selectedMode = bmdModes[clickedName];
    for(auto it = bmdModes.begin(); it != bmdModes.end(); it++) {
        string name = it->first;
        if(name == clickedName) {
            cameraModes.getBool(name).setWithoutEventNotifications(true);
        } else {
            cameraModes.getBool(name).setWithoutEventNotifications(false);
        }
    }
    
    gui.saveToFile("settings/controls.xml");
}
