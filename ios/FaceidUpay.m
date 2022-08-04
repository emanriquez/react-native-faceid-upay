#import "FaceidUpay.h"
#import <FaceIDLib/FaceIDLib-Swift.h>
#import <React/RCTLog.h>
#import <UIKit/UIKit.h>

@implementation FaceidUpay


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


RCTResponseSenderBlock requestPermissionsResolve;
bool hasPendingOperation;

RCT_EXPORT_MODULE()



RCT_EXPORT_METHOD(docLivenessFlow
                  :(NSString *)number
                  :(NSString *)Data
                  :(RCTResponseSenderBlock)callback)
{
  RCTLogInfo(@"INIT NATIVE FACEID@");
    NSLog(@"INIT CAPTURE AND LIVENESS");
    requestPermissionsResolve = callback;
    NSData *datos = [Data dataUsingEncoding:NSUTF8StringEncoding];
    //NSArray jsonOutput = [NSJSONSerialization JSONObjectWithData:datos options:0 error:nil];
    NSError *e = nil;
    NSDictionary *jsonOutput = [NSJSONSerialization JSONObjectWithData: datos options: NSJSONReadingMutableContainers error: &e];

    NSLog(@"%@",jsonOutput);
    NSLog(@"%@",[jsonOutput objectForKey:@"BaseURL"]);

    @try {

        NSString *bioEndpoint = [jsonOutput objectForKey:@"BaseURL"];
        NSString *deviceKey = [jsonOutput objectForKey:@"deviceKeyIdentifier"];
        NSString *projectSecret = [jsonOutput objectForKey:@"projectSecret"];
        NSString *keyText = [jsonOutput objectForKey:@"licenceKey"];
        NSString *docLicense = [jsonOutput objectForKey:@"dLicense"];
        NSString *faceReportHost = [jsonOutput objectForKey:@"ReportHost"];

        [BioCaller docLivenessFlowWithAppDelegate:[[UIApplication sharedApplication] delegate] dLicense:docLicense projectSecret:projectSecret bioEndPoint:bioEndpoint bioKey:deviceKey keyText:keyText reportsEndpoint:faceReportHost];
        //callback(@[[NSNull null], @"data"]);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackApp) name:@"FIDNotification" object:nil];
        hasPendingOperation = YES;
    } @catch (NSException *exception) {
        callback(@[exception.reason, [NSNull null]]);
        //callback(@[ @"TASK_DUMPED", @"{\"success\": false}" ]);
        //reject(@"event_failure", @"no event id returned", nil);
        //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: exception.name];
        //[self.commandDelegate sendPluginResult:pluginResult callbackId:commandAux.callbackId];
    }
}



- (void)callBackApp{
        if (BioCaller.getFaceIdResultData  != nil && hasPendingOperation == YES){
            hasPendingOperation = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            NSLog(@"Got a notification");
            NSLog(BioCaller.getFaceIdResultData);
            requestPermissionsResolve(@[[NSNull null],BioCaller.getFaceIdResultData]);
            //resolve(BioCaller.getFaceIdResultData);
            //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: BioCaller.getFaceIdResultData];
            //[self.commandDelegate sendPluginResult:pluginResult callbackId:commandAux.callbackId];
        }
}

@end
