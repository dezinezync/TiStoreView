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

-(id)moduleGUID
{
	return @"1784b77a-5dd1-4dc0-8844-a18fdd1e56ee";
}

-(NSString*)moduleId
{
	return @"com.dezinezync.storeview";
}

#pragma Public APIs

-(void)showStore:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    NSLog(@"[WARN] TiStoreView: showStore('%@') is deprecated in 1.1.0. Use showProductDialog({'id': '%@'}) instead.", value, value);
    
    [self showProductDialog:@[@{SKStoreProductParameterITunesItemIdentifier: [TiUtils stringValue:value]}]];
}

-(void)showProductDialog:(id)args
{
    ENSURE_UI_THREAD(showStore, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *appID = [args objectForKey:SKStoreProductParameterITunesItemIdentifier];
    NSDictionary *options = [args mutableCopy];
    
    if(!appID) {
        NSLog(@"[ERROR] Ti.StoreView: No AppID specified. Exiting ...");
        RELEASE_TO_NIL(options);
        return;
    }
    
    if (!options) {
        options = @{
            SKStoreProductParameterITunesItemIdentifier : appID
        };
    } else {
        NSArray *allowedOptions = @[
            SKStoreProductParameterITunesItemIdentifier,
            SKStoreProductParameterCampaignToken,
            SKStoreProductParameterProviderToken,
            SKStoreProductParameterAffiliateToken,
            SKStoreProductParameterAdvertisingPartnerToken
        ];
        
        for (id option in [options allKeys]) {
            if (![option isKindOfClass:[NSString class]]) {
                NSLog(@"[ERROR] Ti.StoreView: Invalid key provided, must be string: %@", option);
            } else if (![allowedOptions containsObject:[TiUtils stringValue:option]]) {
                NSLog(@"[ERROR] Ti.StoreView: Invalid key provided, must be a SKStoreProductParameter: %@", option);
            }
        }
    }
        
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];
    
    if ([self _hasListeners:@"loading"]) {
        [self fireEvent:@"loading" withObject:@{@"options": options}];
    }

    [storeProductViewController loadProductWithParameters:options completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            if ([self _hasListeners:@"error"]) {
                [self fireEvent:@"error" withObject:@{
                    @"userInfo":[error userInfo],
                    @"error": [error localizedDescription]
                }];
            }
            NSLog(@"[ERROR] Error %@ with User Info %@.", error, [error userInfo]);
        } else {
            if ([self _hasListeners:@"willshow"]) {
                [self fireEvent:@"willshow" withObject:@{@"options": options}];
            }
            
            // Present Store Product View Controller
            [[TiApp app] showModalController:storeProductViewController animated:YES];
        }
    }];
}

#pragma mark - SKStoreProductViewController Delegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if ([self _hasListeners:@"willdismiss"]) {
        [self fireEvent:@"willdismiss" withObject:nil];
    }

    [[TiApp app] hideModalController:viewController animated:YES];
}

@end
