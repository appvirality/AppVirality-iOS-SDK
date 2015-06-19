//
//  AppViralityUI.h
//  testAV
//
//  Created by Ram on 08/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppVirality.h"
#import "AppViralityGrowthHackViewController.h"

@interface AppViralityUI : NSObject
+ (void)showGrowthHack:(GrowthHackType)growthHack  FromController:(UIViewController*)viewController;
+ (void)showLaunchBar:(GrowthHackType)growthHack  FromController:(UIViewController*)viewController;
+ (void)showPopUp:(GrowthHackType)growthHack  FromController:(UIViewController*)viewController;
+ (void)showWelcomeScreenFromController:(UIViewController*)viewController;
@end


