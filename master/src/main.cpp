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
    
    shared_ptr<ofApp> mainApp(new ofApp);

#ifdef SHOW_MODE
    settings.width = 800;
    settings.height = 1080;
    settings.setPosition(ofVec2f(0,0));
    settings.resizable = true;
    shared_ptr<ofAppBaseWindow> guiWindow = ofCreateWindow(settings);
    
    shared_ptr<ControlApp> controlApp(new ControlApp);
    mainApp->control = controlApp;
    ofRunApp(guiWindow, controlApp);
#endif
    
    ofRunApp(mainWindow, mainApp);
    ofRunMainLoop();
    
}
