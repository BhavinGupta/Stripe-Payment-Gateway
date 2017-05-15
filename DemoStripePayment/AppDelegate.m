//
//  AppDelegate.m
//  DemoStripePayment
//
//  Created by Bhavin Gupta on 27/01/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <Stripe/Stripe.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (StripePublishableKey) {
        [Stripe setDefaultPublishableKey:StripePublishableKey];
    }
    return YES;
}

@end
