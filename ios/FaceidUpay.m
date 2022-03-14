#import "FaceidUpay.h"
#import <FaceIDLib/FaceIDLib-Swift.h>


@implementation FaceidUpay



bool hasPendingOperation;

RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}


RCT_EXPORT_METHOD(docLivenessFlow:(NSString *)number:(NSString *)Data:  callback:(RCTResponseSenderBlock)callback resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"INIT CAPTURE AND LIVENESS");
    NSData *datos = [Data dataUsingEncoding:NSUTF8StringEncoding];
    id jsonOutput = [NSJSONSerialization JSONObjectWithData:datos options:0 error:nil];
    NSLog(@"%@",jsonOutput);


    @try {
        NSString *bioEndpoint = [jsonOutput objectAtIndex:0];
        NSString *deviceKey = [jsonOutput objectAtIndex:1];
        NSString *projectSecret = [jsonOutput objectAtIndex:2];
        NSString *keyText = [jsonOutput objectAtIndex:3];
        NSString *docLicense = [jsonOutput objectAtIndex:4];
        NSString *faceReportHost = [jsonOutput objectAtIndex:5];

        [BioCaller docLivenessFlowWithAppDelegate:[[UIApplication sharedApplication] delegate] dLicense:docLicense projectSecret:projectSecret bioEndPoint:bioEndpoint bioKey:deviceKey keyText:keyText reportsEndpoint:faceReportHost];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBack) name:@"FIDNotification" object:nil];
        hasPendingOperation = YES;
    } @catch (NSException *exception) {

        reject(@"event_failure", @"no event id returned", nil);
        //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: exception.name];
        //[self.commandDelegate sendPluginResult:pluginResult callbackId:commandAux.callbackId];
    }
}





- (void)callBack: resolver:(RCTPromiseResolveBlock)resolve
{
    if (BioCaller.getFaceIdResultData  != nil && hasPendingOperation == YES){
        hasPendingOperation = NO;
        //CDVPluginResult* pluginResult = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        callBack(BioCaller.getFaceIdResultData);
        resolve(BioCaller.getFaceIdResultData);
        //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: BioCaller.getFaceIdResultData];
        //[self.commandDelegate sendPluginResult:pluginResult callbackId:commandAux.callbackId];
    }
}

@end
