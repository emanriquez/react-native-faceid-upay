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

RCT_EXPORT_METHOD(getDeviceName:(RCTResponseSenderBlock)callback){
 @try{
   NSString *deviceName = [[UIDevice currentDevice] name];
   callback(@[[NSNull null], deviceName]);
 }
 @catch(NSException *exception){
   callback(@[exception.reason, [NSNull null]]);
 }
}

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
            //NSLog(BioCaller.getFaceIdResultData);

            //PARSIN DATA
            NSData* datareturn = [BioCaller.getFaceIdResultData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *e = nil;
            NSDictionary *jsonOutput = [NSJSONSerialization JSONObjectWithData:datareturn options: NSJSONReadingMutableContainers error: &e];

           // NSLog(@"%@",[jsonOutput objectForKey:@"scanDocumentData"]);


            @try {
                NSLog(@"RESULTADO@");
                NSLog(@"resultado%@", [jsonOutput objectForKey:@"resultado"]);
                NSLog(@"error%@", [jsonOutput objectForKey:@"error"]);
                NSLog(@"rut%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"rut"]);
                NSLog(@"nombre%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"nombre"]);
                NSLog(@"apellido%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"apellido"]);
                NSLog(@"documentNumber%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"documentNumber"]);
                NSLog(@"sexo%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"sexo"]);
                NSLog(@"profesion%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"profesion"]);
                NSLog(@"NACIONALIDAD%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"nationality"]);
                NSLog(@"dateOfBirth:%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"dateOfBirth"]);
                NSLog(@"dateOfExpiry:%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"dateOfExpiry"]);




            } @catch (NSException *exception) {
                NSLog(exception.reason);
            }


            @try {

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSString *dateBirth = [NSString stringWithFormat:@"%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"dateOfBirth"]];
                NSString *dateOfExpiry =[NSString stringWithFormat:@"%@", [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"dateOfExpiry"]];


                NSDictionary *dataResultData = [NSDictionary dictionaryWithObjectsAndKeys:
                dateBirth,@"dateOfBirth",
                dateOfExpiry,@"dateOfExpiry",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"apellido"],@"apellido",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"rut"],@"rut",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"nombre"],@"nombre",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"documentNumber"],@"documentNumber",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"sexo"],@"sexo",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"profesion"],@"profesion",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"nacionalidad"],@"nacionalidad",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"nationality"],@"nationality",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"pais"],@"pais",
                [[jsonOutput objectForKey:@"scanDocumentData"] objectForKey:@"tipoDocumento"],@"tipoDocumento",

                nil];

              //  NSLog(@"scanDocumentData %@",dataResultData);

                NSDictionary *o1 = [NSDictionary dictionaryWithObjectsAndKeys:
                [jsonOutput objectForKey:@"resultado"],@"resultado",
                [jsonOutput objectForKey:@"error"],@"error",
                dataResultData,@"scanDocumentData",
                nil];


                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:&error];

                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"JSON STRING%@",[NSString stringWithFormat:@"%@", jsonString]);
                requestPermissionsResolve(@[[NSNull null],jsonString]);

            } @catch (NSException *exception) {
                NSLog(exception.reason);
            }

            //resolve(BioCaller.getFaceIdResultData);
            //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: BioCaller.getFaceIdResultData];
            //[self.commandDelegate sendPluginResult:pluginResult callbackId:commandAux.callbackId];
        }
}

@end
