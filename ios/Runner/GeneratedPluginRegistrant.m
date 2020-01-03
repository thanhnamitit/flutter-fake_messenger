//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<firebase_core/FirebaseCorePlugin.h>)
#import <firebase_core/FirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<image_cropper/ImageCropperPlugin.h>)
#import <image_cropper/ImageCropperPlugin.h>
#else
@import image_cropper;
#endif

#if __has_include(<image_picker/ImagePickerPlugin.h>)
#import <image_picker/ImagePickerPlugin.h>
#else
@import image_picker;
#endif

#if __has_include(<keyboard_visibility/KeyboardVisibilityPlugin.h>)
#import <keyboard_visibility/KeyboardVisibilityPlugin.h>
#else
@import keyboard_visibility;
#endif

#if __has_include(<path_provider/PathProviderPlugin.h>)
#import <path_provider/PathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<shared_preferences/SharedPreferencesPlugin.h>)
#import <shared_preferences/SharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTImageCropperPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImageCropperPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTKeyboardVisibilityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTKeyboardVisibilityPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end
