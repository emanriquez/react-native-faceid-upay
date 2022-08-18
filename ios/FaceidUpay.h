#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>
#if __has_include("UBiometrics/UBiometrics-Swift.h")
#import <UBiometrics/UBiometrics-Swift.h>
#endif

@interface FaceidUpay : NSObject <RCTBridgeModule>

@end
