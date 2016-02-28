//
//  AppViralityGrowthHackViewController.h
//  testAV
//
//  Created by Ram on 07/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppVirality.h"
#import "AppViralityUIUtility.h"
#import <Social/Social.h>

@interface AppViralityGrowthHackViewController : UITableViewController
@property (nonatomic,strong) UILabel * greetingLabel,*messageLabel,*shareLabel;
@property (nonatomic,strong) UIButton* facebookButton,*twitterButton,*whatsappButton,*mailButton,*moreButton;
@property (nonatomic,strong) UIImageView * logoView;
-(id)initWithCampaignDetails:(NSDictionary*)campaignDetails ForGrowthHack:(GrowthHackType)growthHack;
@end

