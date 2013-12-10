/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/
#import <SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

CFOptionFlags didUserAllow(id appInstance){

        //    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    CFStringRef title = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@ Would Like To Access Your Camera"), @"appName");
    CFOptionFlags alertResult = kCFUserNotificationDefaultResponse;
        //    BOOL ret = NO;

    CFUserNotificationDisplayAlert(0.0, kCFUserNotificationNoteAlertLevel, NULL, NULL, NULL, title, CFSTR("Not all apps recover successfully from having their Camera access revoked."), CFSTR("OK"), CFSTR("Don't Allow"), NULL, &alertResult);
    CFRelease(title);

    return alertResult;
}

/**/
/*
%hook PLCameraController
-(void)_tookPhoto:(id)photo
{
    NSString *message = [NSString stringWithFormat:@"The app has requested to use _tookPhoto", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    %orig;
}
%end



%hook PLCameraController
-(void)_tookPicture:(CGImageRef)picture jpegData:(CFDataRef)data imageProperties:(CFDictionaryRef)properties
{
    NSString *message = [NSString stringWithFormat:@"The app took a picture with the camera", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    %orig;
}
%end

 %hook SBApplicationIcon
 -(void)launch
 {
 NSString *appName = [self displayName];
 NSString *message = [NSString stringWithFormat:@"The app %@ has been launched", appName, nil];
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alert show];
 [alert release];
 %orig;
 }
 %end

%hook PLCameraController
-(void)capturePhoto:(BOOL)photo
{
    NSString *message = [NSString stringWithFormat:@"The app tries to capture a photo", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return %orig;
}
%end
*/

%hook PLCameraController
-(BOOL)_setupCamera
{
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return %orig;
            break;
        default:
            break;
    }
    return NO;
}
%end



%hook PLCameraController
-(void)_previewStarted:(id)started
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


%hook PLCameraController
-(void)autofocus
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
- (id)initWithCaptureMode:(id)arg1 qualityPreset:(id)arg2
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

        //    NSString *appName = [self displayName];
}
%end



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




%hook AVRecorder
- (BOOL)takePhoto
{

    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return %orig;
            break;
        default:
            break;
    }

    return NO;

}
%end

%hook AVCapture
- (BOOL)capturePhoto:(id)arg1
{
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return %orig;
            break;
        default:
            break;
    }

    return NO;
}
%end

%hook AVCapture
- (BOOL)capturePhoto
{
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return %orig;
            break;
        default:
            break;
    }

    return NO;
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
            return nil;
            break;
        case kCFUserNotificationDefaultResponse:
                //    return %orig;
            break;
        default:
            break;
    }

    return nil;
}
%end


