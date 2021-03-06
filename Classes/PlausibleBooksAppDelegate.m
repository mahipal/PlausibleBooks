//
//  PlausibleBooksAppDelegate.m
//  PlausibleBooks
//
//  Created by Mahipal Raythattha on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// This is a sample database app that parallels Apple's CoreDataBooks
// and shows you how to use PlausibleDatabase.

#import "PlausibleBooksAppDelegate.h"
#import "RootViewController.h"
#import "LocalDataStore.h"

#define kDatabaseFileName @"Books.sqlite"

@implementation PlausibleBooksAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set up the window to account for not having a MainWindow.xib
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    
    // now set up the database layer
    
    NSString *dbPath = [self createEditableCopyOfDatabaseIfNeededAndReturnPath];
    LocalDataStore *lds = [[LocalDataStore alloc] initWithPathToDatabase:dbPath];
    
    // now set up the view controllers, add to window, and show
    // note that all of our view controllers use class composition to inject a dependency to the LocalDataStore
    
    RootViewController *rvc = [[RootViewController alloc] init];
    rvc.dataStore = lds;
    
    nvc = [[UINavigationController alloc] initWithRootViewController:rvc];
    [rvc release];
        
    [self.window addSubview:nvc.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSString *) createEditableCopyOfDatabaseIfNeededAndReturnPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseFileName];
	
	BOOL success = [fileManager fileExistsAtPath:writableDBPath];
	
	if (success)
		return writableDBPath;
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseFileName];
	NSError *error;
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success)
        DebugLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    
    return writableDBPath;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc
{
    [nvc release];
    [window release];
    [super dealloc];
}


@end
