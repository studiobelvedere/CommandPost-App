//
//  HSAppleScript.m
//  Hammerspoon
//
//  Created by Chris Hocking on 5/4/17.
//  Copyright © 2017 Hammerspoon. All rights reserved.
//

#import "HSAppleScript.h"
#import "MJLua.h"
#import "variables.h"
#import "MJConsoleWindowController.h"

//
// Enable & Disable AppleScript Support:
//
BOOL HSAppleScriptEnabled(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HSAppleScriptEnabledKey];
}
void HSAppleScriptSetEnabled(BOOL enabled) {
    [[NSUserDefaults standardUserDefaults] setBool:enabled
                                            forKey:HSAppleScriptEnabledKey];
}

//
// Execute Lua Code:
//
@implementation executeLua

-(id)performDefaultImplementation {
    
    // Get the arguments:
    NSDictionary *args = [self evaluatedArguments];
    NSString *stringToExecute = @"";
    if(args.count) {
        stringToExecute = [args valueForKey:@""];    // Get the direct argument
    } else {
        // Raise Error:
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"A Parameter is expected for the verb 'execute'. You need to tell Hammerspoon what Lua code you want to execute."];
        return @"Error";
    }
    
    if (HSAppleScriptEnabled()) {
        // Execute Lua Code:
        return MJLuaRunString(stringToExecute);
    } else {
        // Raise Error:
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"Hammerspoon's AppleScript support is currently disabled. Please enable it in Hammerspoon by using the hs.appleScript(true) command."];
        return @"Error";
    }
}

@end


//
// Open Hammerspoon Console:
//
@implementation openHammerspoonConsole
-(id)performDefaultImplementation {
    
    NSDictionary * theArguments = [self evaluatedArguments];
    
    if (HSAppleScriptEnabled()) {
        if ([theArguments objectForKey:@"openHammerspoonConsoleBringToFront"]) {
            if ([[theArguments objectForKey:@"openHammerspoonConsoleBringToFront"]  isEqual: @YES]) {
                [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
                [[MJConsoleWindowController singleton] showWindow: nil];
            }
            else {
                [[MJConsoleWindowController singleton] showWindow: nil];
            }
        } else {
            [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
            [[MJConsoleWindowController singleton] showWindow: nil];
        }
    }
    else {
        // Raise Error:
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"Hammerspoon's AppleScript support is currently disabled. Please enable it in Hammerspoon by using the hs.appleScript(true) command."];
    }
    return @"Done";
}
@end
