/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/
#import <SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

CFOptionFlags didUserAllow(){

    CFStringRef title = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("“%@” Would Like To Access Your Camera"), @"This App");
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
    CFStringRef title = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("“%@” Would Like To Access Your Camera"), @"This App");
    CFOptionFlags alertResult = kCFUserNotificationDefaultResponse;
    BOOL ret = NO;

    CFUserNotificationDisplayAlert(0.0, kCFUserNotificationNoteAlertLevel, NULL, NULL, NULL, title, CFSTR("Not all apps recover successfully from having their Camera access revoked."), CFSTR("OK"), CFSTR("Don't Allow"), NULL, &alertResult);
    CFRelease(title);
    switch (alertResult) {
        case kCFUserNotificationAlternateResponse:
            ret = NO;
            break;
        case kCFUserNotificationDefaultResponse:
            ret = %orig;
            break;
        default:
            break;
    }

    //BOOL ret = %orig;
    //  NSString *message = [NSString stringWithFormat:@"The app has requested to use _setupCamera", nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
 return ret;
}
%end



%hook PLCameraController
-(void)_previewStarted:(id)started
{
    switch (didUserAllow()) {
        case kCFUserNotificationAlternateResponse:
                //  ret = NO;
            break;
        case kCFUserNotificationDefaultResponse:
            //ret =
            %orig;
            break;
        default:
            break;
    }

        //BOOL ret = %orig;
        //  NSString *message = [NSString stringWithFormat:@"The app has requested to use _setupCamera", nil];
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //    [alert show];
        //    [alert release];
        //   return ret;
//
//    NSString *message = [NSString stringWithFormat:@"The app has requested to use _previewStarted", nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    %orig;
}
%end


%hook PLCameraController
-(void)autofocus
{
    NSString *message = [NSString stringWithFormat:@"The app has requested to use -(void)autofocus", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
%end




%hook AVCapture
- (id)initWithCaptureMode:(id)arg1 qualityPreset:(id)arg2
{
    NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The app %@ has requested to use - (id)initWithCaptureMode:(id)arg1 qualityPreset:(id)arg2", appName, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return %orig;
}
%end



%hook UIImagePickerController

- (void)takePicture
{
        //   NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The UIImagePickerController used takePicture", nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    %orig;
}

%end




%hook AVRecorder
- (BOOL)takePhoto
{
    NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The app %@ has requested to use - (BOOL)takePhoto", appName, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return %orig;
}
%end

%hook AVCapture
- (BOOL)capturePhoto:(id)arg1
{
    NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The app %@ has requested to use - (BOOL)capturePhoto:(id)arg1", appName, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return NO;
}
%end

%hook AVCapture
- (BOOL)capturePhoto
{
    NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The app %@ has requested to use - (BOOL)capturePhoto", appName, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return NO;
}
%end

%hook AVCapture
- (void)setSourceCamera:(id)arg1
{
    NSString *appName = [self displayName];
    NSString *message = [NSString stringWithFormat:@"The app %@ has requested to use - (void)setSourceCamera:(id)arg1", appName, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appName message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
%end



%hook AVCaptureOutput
- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType
{
    NSString *message = [NSString stringWithFormat:@"The app has requested to use - (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType with argument: '%@'", mediaType, nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return %orig;
}
%end


