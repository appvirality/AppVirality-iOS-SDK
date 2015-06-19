//
//  AppViralityWelcomeViewController.h
//  testAV
//
//  Created by Ram on 07/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppViralityWelcomeViewController : UIViewController
@property (nonatomic,strong) UILabel * greetingLabel,*messageLabel;
@property (nonatomic,strong) UIButton* claimButton;
-(id)initWithReferrerDetails:(NSDictionary *)referrerDetails;
@end