/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/
#import <SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <pthread.h>
    //#import <AppSupport/CPDistributedMessagingCenter.h>
    //#import <AppSupport/AppSupport.h>
#import <Foundation/Foundation.h>
#include <substrate.h>

@class CPDistributedMessagingCenter;
static CFErrorRef blockedError;
static CFArrayRef emptyArray;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static CPDistributedMessagingCenter *center;

#define kSettingsPath @"/var/mobile/Library/Preferences/com.comp116.CameraSentry"
static NSMutableDictionary *settings;

__attribute__((visibility("hidden")))
@interface ContactPrivacySpringBoardHandler : NSObject
@end

@implementation ContactPrivacySpringBoardHandler

+ (NSDictionary *)settings
{
	return [[settings copy] autorelease];
}

- (NSDictionary *)getValueForMessage:(NSString *)message userInfo:(NSDictionary *)userInfo
{
	id result = [settings objectForKey:[userInfo objectForKey:@"key"]];
	return result ? [NSDictionary dictionaryWithObject:result forKey:@"value"] : [NSDictionary dictionary];
}

- (void)setValueForMessage:(NSString *)message userInfo:(NSDictionary *)userInfo
{
	id key = [userInfo objectForKey:@"key"];
	if (key) {
		id value = [userInfo objectForKey:@"value"];
		if (value)
			[settings setObject:value forKey:key];
		else
			[settings removeObjectForKey:key];
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:settings format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
		[data writeToFile:kSettingsPath atomically:YES];
	}
}

@end

static void LoadSettings()
{
	[settings release];
	settings = [[NSMutableDictionary alloc] initWithContentsOfFile:kSettingsPath] ?: [[NSMutableDictionary alloc] init];
}

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    center = (CPDistributedMessagingCenter*) [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.comp116.CameraSentry.springboard"] retain];
        //	center = [[messagingCenter centerNamed:@"com.comp116.CameraSentry.springboard"] retain];
	if (dlopen("/System/Library/CoreServices/SpringBoard.app/SpringBoard", RTLD_NOLOAD)) {
		[center runServerOnCurrentThread];
		ContactPrivacySpringBoardHandler *sbh = [[ContactPrivacySpringBoardHandler alloc] init];
		[center registerForMessageName:@"get" target:sbh selector:@selector(getValueForMessage:userInfo:)];
		[center registerForMessageName:@"set" target:sbh selector:@selector(setValueForMessage:userInfo:)];
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LoadSettings, CFSTR("com.comp116.CameraSentry.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		LoadSettings();
	} else {
		if ([[[NSBundle mainBundle] bundlePath] hasPrefix:@"/var/mobile/Applications/"]) {
			blockedError = CFErrorCreate(kCFAllocatorDefault, CFSTR("com.comp116.CameraSentry"), 0, NULL);
			const void *value = NULL;
			emptyArray = CFArrayCreate(kCFAllocatorDefault, &value, 0, &kCFTypeArrayCallBacks);
		}
	}
	[pool drain];
}


CFOptionFlags didUserAllow(id appInstance){

        //  const char *appName = [[[NSBundle mainBundle] //objectForInfoDictionaryKey:@"CFBundleDisplayName"] UTF8String];
    pthread_mutex_lock(&mutex);
    CFBundleRef mainBundle = CFBundleGetMainBundle();

    CFStringRef identifier = CFBundleGetIdentifier(mainBundle);

    NSString *key = [NSString stringWithFormat:@"CPAllowed-%@", identifier];
    id value = [[center sendMessageAndReceiveReplyName:@"get" userInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]] objectForKey:@"value"];
    if (!value) {

    CFStringRef displayName
        =  (CFStringRef) CFBundleGetValueForInfoDictionaryKey(mainBundle, CFSTR("CFBundleDisplayName"))
        ?: (CFStringRef) CFBundleGetValueForInfoDictionaryKey(mainBundle, CFSTR("CFBundleName"))
        ?: CFSTR("Unknown");

    CFStringRef title = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%@ wants to access your camera"), displayName);
    CFOptionFlags alertResult = kCFUserNotificationDefaultResponse;
        //    BOOL ret = NO;


    CFUserNotificationDisplayAlert(0.0, kCFUserNotificationNoteAlertLevel, NULL, NULL, NULL, title, CFSTR("Do you want to allow this?"), CFSTR("OK"), CFSTR("Don't Allow"), NULL, &alertResult);
    CFRelease(title);


    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              key, @"key",
                              1
                              nil];
    [center sendMessageName:@"set" userInfo:userInfo];
    pthread_mutex_unlock(&mutex);
    }
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


