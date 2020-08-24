//
//  CDVMarket.h
//
// Created by Miguel Revetria miguel@xmartlabs.com on 2014-03-17.
// License Apache 2.0

#include "CDVMarket.h"

@implementation CDVMarket

- (void)pluginInitialize
{
}

- (void)open:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
            dispatch_async(dispatch_get_main_queue(), ^(void){
        NSArray *args = command.arguments;
        NSString *appId = [args objectAtIndex:0];
        
        CDVPluginResult *pluginResult;
        if (appId) {
            #if TARGET_IPHONE_SIMULATOR
            NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/app/%@", appId];
            #else
            NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", appId];
            #endif
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:urlString];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Opening returned an error"];
                }
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid application id: null was found"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        
       });
    }];
}

@end
