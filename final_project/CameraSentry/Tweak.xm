/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/
#import <SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <pthread.h>
#import <Foundation/Foundation.h>
#include <substrate.h>
    //this will show the prompt requesting permission from the user and will return the result (action permitted or not)
CFOptionFlags didUserAllow(id appInstance){

    CFBundleRef mainBundle = CFBundleGetMainBundle();

    CFStringRef displayName
        =  (CFStringRef) CFBundleGetValueForInfoDictionaryKey(mainBundle, CFSTR("CFBundleDisplayName"))
        ?: (CFStringRef) CFBundleGetValueForInfoDictionaryKey(mainBundle, CFSTR("CFBundleName"))
        ?: CFSTR("Unknown");

    CFStringRef title = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@ wants to access your camera"), displayName);
    CFOptionFlags alertResult = kCFUserNotificationDefaultResponse;

    CFUserNotificationDisplayAlert(0.0, kCFUserNotificationNoteAlertLevel, NULL, NULL, NULL, title, CFSTR("Do you want to allow this?"), CFSTR("OK"), CFSTR("Don't Allow"), NULL, &alertResult);
    CFRelease(title);

    return alertResult;
}


    //here we hook a method used for connecting to the camera
    //the macro %hook is part of the logos tweak framework that comes with THEOS

%hook AVCapture
- (id)initWithCaptureMode:(id)arg1 qualityPreset:(id)arg2
{


    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break; // if the user didnt allow this we simply return nothing as we dont want to run the method.
        case kCFUserNotificationDefaultResponse:
            return %orig; // orig is the original function that we want ot call in case the user permitted the action.
            break;
        default:
            break;
    }

    return nil;

}
%end

    // other methods that access the camera.

%hook UIImagePickerController

- (void)takePicture
{

    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            %orig;
            break;
        default:
            break;
    }
    

}

%end

%hook AVCapture
- (void)setSourceCamera:(id)arg1
{
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            %orig;
            break;
        default:
            break;
    }
}
%end



%hook AVCaptureOutput
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType
{
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            return %orig;
            break;
        default:
            break;
    }

    return nil;
}
%end


