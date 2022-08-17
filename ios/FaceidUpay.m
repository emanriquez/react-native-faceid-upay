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
    requestPermissionsResolve = callback;
    NSData *datos = [Data dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *jsonOutput = [NSJSONSerialization JSONObjectWithData: datos options: NSJSONReadingMutableContainers error: &e];
    @try {
        NSString *apikey = [jsonOutput objectForKey:@"apikey"];
        NSString *url = [jsonOutput objectForKey:@"url"];
        bool *onboarding = [jsonOutput objectForKey:@"onboarding"];
        bool *gov = [jsonOutput objectForKey:@"gov"];
        [BioCaller CreateSessionWithAppDelegate:[[UIApplication sharedApplication] delegate] apiKey:apikey url:url tour:true function:"nul"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBackApp) name:@"FIDNotification" object:nil];
        hasPendingOperation = YES;
    } @catch (NSException *exception) {
        callback(@[exception.reason, [NSNull null]]);
        
    }
}


- (void)callBackApp{
        if (BioCaller.getReturnapp()  != nil){
            hasPendingOperation = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            requestPermissionsResolve(@[[NSNull null],BioCaller.getReturnapp()]);
          
        }
}

@end
