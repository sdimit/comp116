#line 1 "Tweak.xm"





#import <SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <pthread.h>
    
    
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


+ (NSDictionary *)settings {
	return [[settings copy] autorelease];
}


- (NSDictionary *)getValueForMessage:(NSString *)message userInfo:(NSDictionary *)userInfo {
	id result = [settings objectForKey:[userInfo objectForKey:@"key"]];
	return result ? [NSDictionary dictionaryWithObject:result forKey:@"value"] : [NSDictionary dictionary];
}


- (void)setValueForMessage:(NSString *)message userInfo:(NSDictionary *)userInfo {
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

static __attribute__((constructor)) void _logosLocalCtor_99ca4bba() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    center = (CPDistributedMessagingCenter*) [[objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.comp116.CameraSentry.springboard"] retain];
        
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



















































#include <logos/logos.h>
#include <objc/message.h>
@class AVCapture; @class AVRecorder; @class UIImagePickerController; @class AVCaptureOutput; @class PLCameraController; 
static Class _logos_superclass$_ungrouped$PLCameraController; static BOOL (*_logos_orig$_ungrouped$PLCameraController$_setupCamera)(PLCameraController*, SEL);static void (*_logos_orig$_ungrouped$PLCameraController$_previewStarted$)(PLCameraController*, SEL, id);static void (*_logos_orig$_ungrouped$PLCameraController$autofocus)(PLCameraController*, SEL);static Class _logos_superclass$_ungrouped$AVCapture; static id (*_logos_orig$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$)(AVCapture*, SEL, id, id);static BOOL (*_logos_orig$_ungrouped$AVCapture$capturePhoto$)(AVCapture*, SEL, id);static BOOL (*_logos_orig$_ungrouped$AVCapture$capturePhoto)(AVCapture*, SEL);static void (*_logos_orig$_ungrouped$AVCapture$setSourceCamera$)(AVCapture*, SEL, id);static Class _logos_superclass$_ungrouped$UIImagePickerController; static void (*_logos_orig$_ungrouped$UIImagePickerController$takePicture)(UIImagePickerController*, SEL);static Class _logos_superclass$_ungrouped$AVRecorder; static BOOL (*_logos_orig$_ungrouped$AVRecorder$takePhoto)(AVRecorder*, SEL);static Class _logos_superclass$_ungrouped$AVCaptureOutput; static AVCaptureConnection * (*_logos_orig$_ungrouped$AVCaptureOutput$connectionWithMediaType$)(AVCaptureOutput*, SEL, NSString *);

#line 171 "Tweak.xm"


static BOOL _logos_super$_ungrouped$PLCameraController$_setupCamera(PLCameraController* self, SEL _cmd) {return ((BOOL (*)(PLCameraController*, SEL))class_getMethodImplementation(_logos_superclass$_ungrouped$PLCameraController, @selector(_setupCamera)))(self, _cmd);}static BOOL _logos_method$_ungrouped$PLCameraController$_setupCamera(PLCameraController* self, SEL _cmd) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return _logos_orig$_ungrouped$PLCameraController$_setupCamera(self, _cmd);
            break;
        default:
            break;
    }
    return NO;
}






static void _logos_super$_ungrouped$PLCameraController$_previewStarted$(PLCameraController* self, SEL _cmd, id started) {return ((void (*)(PLCameraController*, SEL, id))class_getMethodImplementation(_logos_superclass$_ungrouped$PLCameraController, @selector(_previewStarted:)))(self, _cmd, started);}static void _logos_method$_ungrouped$PLCameraController$_previewStarted$(PLCameraController* self, SEL _cmd, id started) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            _logos_orig$_ungrouped$PLCameraController$_previewStarted$(self, _cmd, started);
            break;
        default:
            break;
    }
}





static void _logos_super$_ungrouped$PLCameraController$autofocus(PLCameraController* self, SEL _cmd) {return ((void (*)(PLCameraController*, SEL))class_getMethodImplementation(_logos_superclass$_ungrouped$PLCameraController, @selector(autofocus)))(self, _cmd);}static void _logos_method$_ungrouped$PLCameraController$autofocus(PLCameraController* self, SEL _cmd) {

    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            _logos_orig$_ungrouped$PLCameraController$autofocus(self, _cmd);
            break;
        default:
            break;
    }
    

}







static id _logos_super$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$(AVCapture* self, SEL _cmd, id arg1, id arg2) {return ((id (*)(AVCapture*, SEL, id, id))class_getMethodImplementation(_logos_superclass$_ungrouped$AVCapture, @selector(initWithCaptureMode:qualityPreset:)))(self, _cmd, arg1, arg2);}static id _logos_method$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$(AVCapture* self, SEL _cmd, id arg1, id arg2) {


    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            return _logos_orig$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$(self, _cmd, arg1, arg2);
            break;
        default:
            break;
    }

    return nil;

        
}







static void _logos_super$_ungrouped$UIImagePickerController$takePicture(UIImagePickerController* self, SEL _cmd) {return ((void (*)(UIImagePickerController*, SEL))class_getMethodImplementation(_logos_superclass$_ungrouped$UIImagePickerController, @selector(takePicture)))(self, _cmd);}static void _logos_method$_ungrouped$UIImagePickerController$takePicture(UIImagePickerController* self, SEL _cmd) {

    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            _logos_orig$_ungrouped$UIImagePickerController$takePicture(self, _cmd);
            break;
        default:
            break;
    }
    

}








static BOOL _logos_super$_ungrouped$AVRecorder$takePhoto(AVRecorder* self, SEL _cmd) {return ((BOOL (*)(AVRecorder*, SEL))class_getMethodImplementation(_logos_superclass$_ungrouped$AVRecorder, @selector(takePhoto)))(self, _cmd);}static BOOL _logos_method$_ungrouped$AVRecorder$takePhoto(AVRecorder* self, SEL _cmd) {

    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return _logos_orig$_ungrouped$AVRecorder$takePhoto(self, _cmd);
            break;
        default:
            break;
    }

    return NO;

}




static BOOL _logos_super$_ungrouped$AVCapture$capturePhoto$(AVCapture* self, SEL _cmd, id arg1) {return ((BOOL (*)(AVCapture*, SEL, id))class_getMethodImplementation(_logos_superclass$_ungrouped$AVCapture, @selector(capturePhoto:)))(self, _cmd, arg1);}static BOOL _logos_method$_ungrouped$AVCapture$capturePhoto$(AVCapture* self, SEL _cmd, id arg1) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return _logos_orig$_ungrouped$AVCapture$capturePhoto$(self, _cmd, arg1);
            break;
        default:
            break;
    }

    return NO;
}




static BOOL _logos_super$_ungrouped$AVCapture$capturePhoto(AVCapture* self, SEL _cmd) {return ((BOOL (*)(AVCapture*, SEL))class_getMethodImplementation(_logos_superclass$_ungrouped$AVCapture, @selector(capturePhoto)))(self, _cmd);}static BOOL _logos_method$_ungrouped$AVCapture$capturePhoto(AVCapture* self, SEL _cmd) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return NO;
            break;
        case kCFUserNotificationDefaultResponse:
            return _logos_orig$_ungrouped$AVCapture$capturePhoto(self, _cmd);
            break;
        default:
            break;
    }

    return NO;
}




static void _logos_super$_ungrouped$AVCapture$setSourceCamera$(AVCapture* self, SEL _cmd, id arg1) {return ((void (*)(AVCapture*, SEL, id))class_getMethodImplementation(_logos_superclass$_ungrouped$AVCapture, @selector(setSourceCamera:)))(self, _cmd, arg1);}static void _logos_method$_ungrouped$AVCapture$setSourceCamera$(AVCapture* self, SEL _cmd, id arg1) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            break;
        case kCFUserNotificationDefaultResponse:
            _logos_orig$_ungrouped$AVCapture$setSourceCamera$(self, _cmd, arg1);
            break;
        default:
            break;
    }
}






static AVCaptureConnection * _logos_super$_ungrouped$AVCaptureOutput$connectionWithMediaType$(AVCaptureOutput* self, SEL _cmd, NSString * mediaType) {return ((AVCaptureConnection * (*)(AVCaptureOutput*, SEL, NSString *))class_getMethodImplementation(_logos_superclass$_ungrouped$AVCaptureOutput, @selector(connectionWithMediaType:)))(self, _cmd, mediaType);}static AVCaptureConnection * _logos_method$_ungrouped$AVCaptureOutput$connectionWithMediaType$(AVCaptureOutput* self, SEL _cmd, NSString * mediaType) {
    switch (didUserAllow(self)) {
        case kCFUserNotificationAlternateResponse:
            return nil;
            break;
        case kCFUserNotificationDefaultResponse:
                
            break;
        default:
            break;
    }

    return nil;
}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$PLCameraController = objc_getClass("PLCameraController"); _logos_superclass$_ungrouped$PLCameraController = class_getSuperclass(_logos_class$_ungrouped$PLCameraController); { Class _class = _logos_class$_ungrouped$PLCameraController;Method _method = class_getInstanceMethod(_class, @selector(_setupCamera));if (_method) {_logos_orig$_ungrouped$PLCameraController$_setupCamera = _logos_super$_ungrouped$PLCameraController$_setupCamera;if (!class_addMethod(_class, @selector(_setupCamera), (IMP)&_logos_method$_ungrouped$PLCameraController$_setupCamera, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$PLCameraController$_setupCamera = (BOOL (*)(PLCameraController*, SEL))method_getImplementation(_method);_logos_orig$_ungrouped$PLCameraController$_setupCamera = (BOOL (*)(PLCameraController*, SEL))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$PLCameraController$_setupCamera);}}}{ Class _class = _logos_class$_ungrouped$PLCameraController;Method _method = class_getInstanceMethod(_class, @selector(_previewStarted:));if (_method) {_logos_orig$_ungrouped$PLCameraController$_previewStarted$ = _logos_super$_ungrouped$PLCameraController$_previewStarted$;if (!class_addMethod(_class, @selector(_previewStarted:), (IMP)&_logos_method$_ungrouped$PLCameraController$_previewStarted$, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$PLCameraController$_previewStarted$ = (void (*)(PLCameraController*, SEL, id))method_getImplementation(_method);_logos_orig$_ungrouped$PLCameraController$_previewStarted$ = (void (*)(PLCameraController*, SEL, id))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$PLCameraController$_previewStarted$);}}}{ Class _class = _logos_class$_ungrouped$PLCameraController;Method _method = class_getInstanceMethod(_class, @selector(autofocus));if (_method) {_logos_orig$_ungrouped$PLCameraController$autofocus = _logos_super$_ungrouped$PLCameraController$autofocus;if (!class_addMethod(_class, @selector(autofocus), (IMP)&_logos_method$_ungrouped$PLCameraController$autofocus, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$PLCameraController$autofocus = (void (*)(PLCameraController*, SEL))method_getImplementation(_method);_logos_orig$_ungrouped$PLCameraController$autofocus = (void (*)(PLCameraController*, SEL))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$PLCameraController$autofocus);}}}Class _logos_class$_ungrouped$AVCapture = objc_getClass("AVCapture"); _logos_superclass$_ungrouped$AVCapture = class_getSuperclass(_logos_class$_ungrouped$AVCapture); { Class _class = _logos_class$_ungrouped$AVCapture;Method _method = class_getInstanceMethod(_class, @selector(initWithCaptureMode:qualityPreset:));if (_method) {_logos_orig$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$ = _logos_super$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$;if (!class_addMethod(_class, @selector(initWithCaptureMode:qualityPreset:), (IMP)&_logos_method$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$ = (id (*)(AVCapture*, SEL, id, id))method_getImplementation(_method);_logos_orig$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$ = (id (*)(AVCapture*, SEL, id, id))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVCapture$initWithCaptureMode$qualityPreset$);}}}{ Class _class = _logos_class$_ungrouped$AVCapture;Method _method = class_getInstanceMethod(_class, @selector(capturePhoto:));if (_method) {_logos_orig$_ungrouped$AVCapture$capturePhoto$ = _logos_super$_ungrouped$AVCapture$capturePhoto$;if (!class_addMethod(_class, @selector(capturePhoto:), (IMP)&_logos_method$_ungrouped$AVCapture$capturePhoto$, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVCapture$capturePhoto$ = (BOOL (*)(AVCapture*, SEL, id))method_getImplementation(_method);_logos_orig$_ungrouped$AVCapture$capturePhoto$ = (BOOL (*)(AVCapture*, SEL, id))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVCapture$capturePhoto$);}}}{ Class _class = _logos_class$_ungrouped$AVCapture;Method _method = class_getInstanceMethod(_class, @selector(capturePhoto));if (_method) {_logos_orig$_ungrouped$AVCapture$capturePhoto = _logos_super$_ungrouped$AVCapture$capturePhoto;if (!class_addMethod(_class, @selector(capturePhoto), (IMP)&_logos_method$_ungrouped$AVCapture$capturePhoto, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVCapture$capturePhoto = (BOOL (*)(AVCapture*, SEL))method_getImplementation(_method);_logos_orig$_ungrouped$AVCapture$capturePhoto = (BOOL (*)(AVCapture*, SEL))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVCapture$capturePhoto);}}}{ Class _class = _logos_class$_ungrouped$AVCapture;Method _method = class_getInstanceMethod(_class, @selector(setSourceCamera:));if (_method) {_logos_orig$_ungrouped$AVCapture$setSourceCamera$ = _logos_super$_ungrouped$AVCapture$setSourceCamera$;if (!class_addMethod(_class, @selector(setSourceCamera:), (IMP)&_logos_method$_ungrouped$AVCapture$setSourceCamera$, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVCapture$setSourceCamera$ = (void (*)(AVCapture*, SEL, id))method_getImplementation(_method);_logos_orig$_ungrouped$AVCapture$setSourceCamera$ = (void (*)(AVCapture*, SEL, id))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVCapture$setSourceCamera$);}}}Class _logos_class$_ungrouped$UIImagePickerController = objc_getClass("UIImagePickerController"); _logos_superclass$_ungrouped$UIImagePickerController = class_getSuperclass(_logos_class$_ungrouped$UIImagePickerController); { Class _class = _logos_class$_ungrouped$UIImagePickerController;Method _method = class_getInstanceMethod(_class, @selector(takePicture));if (_method) {_logos_orig$_ungrouped$UIImagePickerController$takePicture = _logos_super$_ungrouped$UIImagePickerController$takePicture;if (!class_addMethod(_class, @selector(takePicture), (IMP)&_logos_method$_ungrouped$UIImagePickerController$takePicture, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$UIImagePickerController$takePicture = (void (*)(UIImagePickerController*, SEL))method_getImplementation(_method);_logos_orig$_ungrouped$UIImagePickerController$takePicture = (void (*)(UIImagePickerController*, SEL))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$UIImagePickerController$takePicture);}}}Class _logos_class$_ungrouped$AVRecorder = objc_getClass("AVRecorder"); _logos_superclass$_ungrouped$AVRecorder = class_getSuperclass(_logos_class$_ungrouped$AVRecorder); { Class _class = _logos_class$_ungrouped$AVRecorder;Method _method = class_getInstanceMethod(_class, @selector(takePhoto));if (_method) {_logos_orig$_ungrouped$AVRecorder$takePhoto = _logos_super$_ungrouped$AVRecorder$takePhoto;if (!class_addMethod(_class, @selector(takePhoto), (IMP)&_logos_method$_ungrouped$AVRecorder$takePhoto, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVRecorder$takePhoto = (BOOL (*)(AVRecorder*, SEL))method_getImplementation(_method);_logos_orig$_ungrouped$AVRecorder$takePhoto = (BOOL (*)(AVRecorder*, SEL))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVRecorder$takePhoto);}}}Class _logos_class$_ungrouped$AVCaptureOutput = objc_getClass("AVCaptureOutput"); _logos_superclass$_ungrouped$AVCaptureOutput = class_getSuperclass(_logos_class$_ungrouped$AVCaptureOutput); { Class _class = _logos_class$_ungrouped$AVCaptureOutput;Method _method = class_getInstanceMethod(_class, @selector(connectionWithMediaType:));if (_method) {_logos_orig$_ungrouped$AVCaptureOutput$connectionWithMediaType$ = _logos_super$_ungrouped$AVCaptureOutput$connectionWithMediaType$;if (!class_addMethod(_class, @selector(connectionWithMediaType:), (IMP)&_logos_method$_ungrouped$AVCaptureOutput$connectionWithMediaType$, method_getTypeEncoding(_method))) {_logos_orig$_ungrouped$AVCaptureOutput$connectionWithMediaType$ = (AVCaptureConnection * (*)(AVCaptureOutput*, SEL, NSString *))method_getImplementation(_method);_logos_orig$_ungrouped$AVCaptureOutput$connectionWithMediaType$ = (AVCaptureConnection * (*)(AVCaptureOutput*, SEL, NSString *))method_setImplementation(_method, (IMP)&_logos_method$_ungrouped$AVCaptureOutput$connectionWithMediaType$);}}}} }
#line 365 "Tweak.xm"
