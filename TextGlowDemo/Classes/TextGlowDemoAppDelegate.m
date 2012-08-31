//
//  TextGlowDemoAppDelegate.m
//  TextGlowDemo
//
//  Created by Andrew on 28/04/2010.
//  Red Robot Studios 2010.
//

#import "TextGlowDemoAppDelegate.h"
#import "TextGlowDemoViewController.h"

#import "ViewController.h"
@implementation TextGlowDemoAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize viewController1;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.viewController1 = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController1;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
