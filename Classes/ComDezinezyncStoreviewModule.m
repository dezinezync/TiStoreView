/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComDezinezyncStoreviewModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation ComDezinezyncStoreviewModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"1784b77a-5dd1-4dc0-8844-a18fdd1e56ee";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.dezinezync.storeview";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	//NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
    if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)showStore:(id)app {
    ENSURE_SINGLE_ARG(app, NSString);
    
    appID = [[TiUtils stringValue:app] mutableCopy];
    
    ENSURE_UI_THREAD(showSKModal, nil);
}

#pragma mark - Private Method

-(void)showSKModal:(id)appid {
    
    if(!appID) {
        NSLog(@"StoreView: No AppID specified. Exiting.");
        return;
    }
    
    NSString *_appID = [NSString stringWithString:appID];
    
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    // Configure View Controller
    [storeProductViewController setDelegate:self];
    
    [self fireEvent:@"loading" withObject:nil];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : _appID} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            [self fireEvent:@"error" withObject:[error userInfo]];
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
            
        } else {
            // Present Store Product View Controller
            [self fireEvent:@"willshow" withObject:nil];
            [[TiApp app] showModalController:storeProductViewController animated:YES];
        }
    }];

}

#pragma mark - SKStoreProductViewController Delegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self fireEvent:@"willdimiss" withObject:nil];
    [[TiApp app] hideModalController:viewController animated:YES];
}

@end
