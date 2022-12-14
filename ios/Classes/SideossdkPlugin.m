#import "SideossdkPlugin.h"
#if __has_include(<sideossdk/sideossdk-Swift.h>)
#import <sideossdk/sideossdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sideossdk-Swift.h"
#endif

@implementation SideossdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSideossdkPlugin registerWithRegistrar:registrar];
}
@end
