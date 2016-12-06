#include "ofMain.h"
#include "ofApp.h"
#include "ControlApp.h"
#include "ofAppGLFWWindow.h"

//========================================================================
int main( ){
    ofGLFWWindowSettings settings;
    
    settings.width = 1920;
    settings.height = 1080;
    settings.setPosition(ofVec2f(0,0));
    settings.resizable = true;
    shared_ptr<ofAppBaseWindow> mainWindow = ofCreateWindow(settings);
    
    settings.width = 600;
    settings.height = 1080;
    settings.setPosition(ofVec2f(0,0));
    settings.resizable = false;
    shared_ptr<ofAppBaseWindow> guiWindow = ofCreateWindow(settings);
    
    shared_ptr<ofApp> mainApp(new ofApp);
    shared_ptr<ControlApp> controlApp(new ControlApp);
    mainApp->control = controlApp;
    
    ofRunApp(guiWindow, controlApp);
    ofRunApp(mainWindow, mainApp);
    ofRunMainLoop();
    
}
