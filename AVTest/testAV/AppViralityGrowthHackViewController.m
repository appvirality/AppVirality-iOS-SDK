//
//  AppViralityGrowthHackViewController.m
//  testAV
//
//  Created by Ram on 07/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import "AppViralityGrowthHackViewController.h"
#import "MBProgressHUD.h"


@interface AppViralityGrowthHackViewController ()
@property (strong) NSMutableArray *selectedSections;
@property (strong) NSArray * referredusers;
@property (strong) NSDictionary * userPoints,*urlSchemes,*campaginDetails;
@property (strong) NSMutableDictionary * shareUrls,*shareMesgs;
@property (strong) NSString * terms;
@property (strong) UIWebView * termsView;
@property NSInteger termsHeight;
@property GrowthHackType growthHack;
@end

@implementation AppViralityGrowthHackViewController


-(id)initWithCampaignDetails:(NSDictionary *)campaignDetails ForGrowthHack:(GrowthHackType)growthHack
{
    if (!campaignDetails) {
        return nil;
    }
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.growthHack = growthHack;
        self.campaginDetails = campaignDetails;
        self.referredusers = [NSArray array];
        self.shareUrls = [NSMutableDictionary dictionary];
        self.shareMesgs = [NSMutableDictionary dictionary];
        self.urlSchemes = @{@"Facebook":@"fb://publish/?text=",@"Twitter":@"twitter://post?message=",@"WhatsApp":@"whatsapp://send?text=",@"Messaging":@"",@"Mail":@"",@"Instagram":@"",@"WeChat":@"",@"GooglePlus":@"",@"GMail":@"",@"Pinterest":@"",@"HangOuts":@"",@"Messenger":@"",@"Line":@"",@"CustomLink":@"",@"InviteContacts":@"",@"AppInvite":@""};
        self.termsHeight=0;
        // Do any additional setup after loading the view.
        self.selectedSections = [NSMutableArray array];
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
        
      //  headerView.backgroundColor = [UIColor redColor];
        self.greetingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/10, SCREEN_WIDTH, 120)];
        self.greetingLabel.text = [NSString stringWithFormat:@"Love the app?\n Refer your friends and help us\ngrow!"];
        self.greetingLabel.textAlignment = NSTextAlignmentCenter;
        self.greetingLabel.numberOfLines =0;
        self.greetingLabel.font = [UIFont boldSystemFontOfSize:16];
        [headerView addSubview:self.greetingLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.greetingLabel.frame), SCREEN_WIDTH-20, 120)];
        self.messageLabel.text = [NSString stringWithFormat:@"Offer Description"];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines=0;
        [headerView addSubview:self.messageLabel];
        
        
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+10, SCREEN_WIDTH, 120)];
        self.shareLabel.text = [NSString stringWithFormat:@"Your personal ref link"];
        self.shareLabel.textAlignment = NSTextAlignmentCenter;
        self.shareLabel.numberOfLines=0;
        [headerView addSubview:self.shareLabel];
        
        
        CGFloat space;
        NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=hello"]];
        if (![[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            space= (SCREEN_WIDTH-135)/4;
        }else
            space= (SCREEN_WIDTH-180)/5;

        self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.facebookButton.frame = CGRectMake(space, SCREEN_HEIGHT-250, 45, 45);
        [self.facebookButton setImage:[[UIImage imageNamed:@"facebook.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.facebookButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.facebookButton addTarget:self action:@selector(faceBookButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [headerView addSubview:self.facebookButton];
        
        self.twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.twitterButton.frame = CGRectMake(CGRectGetMaxX(self.facebookButton.frame)+space, SCREEN_HEIGHT-250, 45, 45);
        [self.twitterButton setImage:[[UIImage imageNamed:@"twitter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.twitterButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.twitterButton addTarget:self action:@selector(twitterButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [headerView addSubview:self.twitterButton];
       
        self.mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mailButton.frame = CGRectMake(CGRectGetMaxX(self.twitterButton.frame)+space, SCREEN_HEIGHT-250, 45, 45);
        [self.mailButton setImage:[[UIImage imageNamed:@"mail.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.mailButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.mailButton addTarget:self action:@selector(mailButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [headerView addSubview:self.mailButton];
        
        
        self.whatsappButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.whatsappButton.frame = CGRectMake(CGRectGetMaxX(self.mailButton.frame)+space, SCREEN_HEIGHT-250, 45, 45);
        [self.whatsappButton setImage:[[UIImage imageNamed:@"whatsapp.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.whatsappButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.whatsappButton addTarget:self action:@selector(whatsappButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [headerView addSubview:self.whatsappButton];
        }
        
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.frame = CGRectMake(130,CGRectGetMaxY(self.facebookButton.frame)+10, 45, 27);
        self.moreButton.layer.borderWidth =1;
        self.moreButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.moreButton setImage:[[UIImage imageNamed:@"more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [headerView addSubview:self.moreButton];
        [self.moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        if (![[campaignDetails valueForKey:@"whitelabel"] boolValue]) {
            self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appviralityIcon.png"]];
            self.logoView.frame = CGRectMake(SCREEN_WIDTH-80, CGRectGetMinY(self.moreButton.frame), CGRectGetWidth(self.logoView.frame), CGRectGetHeight(self.logoView.frame));
            [headerView addSubview:self.logoView];
            UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClicked:)];
            tapgesture.numberOfTapsRequired =1;
            self.logoView.userInteractionEnabled = YES;
            [self.logoView addGestureRecognizer:tapgesture];
        }
     
        
        self.tableView.tableHeaderView = headerView;

        if ([campaignDetails objectForKey:@"OfferTitle"]) {
            NSString * titleText= [campaignDetails valueForKey:@"OfferTitle"];
            titleText = [titleText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            titleText = [titleText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
            unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"OfferTitleColor" InDictionary:campaignDetails];
            self.greetingLabel.textColor =UIColorFromRGB(color);
            
            self.greetingLabel.text = titleText;
            [AppViralityUIUtility resetLabelHeight:self.greetingLabel];
        }
        
        if ([campaignDetails objectForKey:@"OfferDescription"]) {
            NSString * descriptionText= [campaignDetails valueForKey:@"OfferDescription"];
            descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
            unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"OfferDescriptionColor" InDictionary:campaignDetails];
            self.messageLabel.textColor =UIColorFromRGB(color);
            
            self.messageLabel.text = descriptionText;
            [AppViralityUIUtility resetLabelHeight:self.messageLabel];
        }
        
        unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"CampaignBGColor" InDictionary:campaignDetails];
        headerView.backgroundColor =UIColorFromRGB(color);
        self.view.backgroundColor = UIColorFromRGB(color);
        
        if ([campaignDetails objectForKey:@"socialactions"]) {
            NSArray * socialActions = [campaignDetails objectForKey:@"socialactions"];
            self.shareUrls = [NSMutableDictionary dictionary];
            for (NSDictionary * socialAction in socialActions) {
                [self.shareUrls setValue:[socialAction valueForKey:@"shareUrl"] forKey:[socialAction valueForKey:@"socialActionName"]];
                NSString * message = [socialAction valueForKey:@"shareMessage"];
                message = [message stringByReplacingOccurrencesOfString:@"SHARE_URL" withString:[socialAction valueForKey:@"shareUrl"]];
                [self.shareMesgs setValue:message forKey:[socialAction valueForKey:@"socialActionName"]];
            }
            
            if (socialActions.count!=0) {
                NSString *shareUrl =[[socialActions valueForKey:@"shareUrl"] firstObject];
                NSURL *myURL = [NSURL URLWithString:shareUrl];
                myURL = [myURL URLByDeletingLastPathComponent];
                shareUrl = [myURL absoluteString];

                self.shareLabel.text = [@"Your personal ref link\n" stringByAppendingString:shareUrl];
                self.shareLabel.text = [self.shareLabel.text substringToIndex:self.shareLabel.text.length-1];
            }
            [AppViralityUIUtility resetLabelHeight:self.shareLabel];
            self.shareLabel.textColor = self.greetingLabel.textColor;
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareLabelSelected:)];
            tapGesture.numberOfTapsRequired =1;
            self.shareLabel.userInteractionEnabled = YES;
            [self.shareLabel addGestureRecognizer:tapGesture];
            
            [self.moreButton setTitleColor:self.greetingLabel.textColor forState:UIControlStateNormal];
            self.moreButton.layer.borderColor = self.greetingLabel.textColor.CGColor;
            headerView.tintColor = self.greetingLabel.textColor;

        }
        
        if ([campaignDetails objectForKey:@"CampaignBGImage"]) {
            [AppViralityUIUtility downloadImageWithURL:[NSURL  URLWithString:[campaignDetails objectForKey:@"CampaignBGImage"]] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded&&image) {
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                    self.tableView.backgroundView = imageView;
                    headerView.backgroundColor = [UIColor clearColor];
                }
            }];
        }
        
        [AppVirality recordImpressionsForGrowthHack:self.growthHack WithParams:@{@"click":@"true",@"impression":@"false"} completion:^(NSDictionary *response, NSError* error) {
            
        }];
        [self.view setNeedsDisplay];
        self.tableView.separatorColor = [UIColor grayColor];

    }
    return self;
}

-(void)shareLabelSelected:(id)sender
{
    [self recordSocialActionForActionType:@"CustomLink"];
    NSString *copyStringverse = [[self.shareLabel.text componentsSeparatedByString:@"\n"] lastObject];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/2-40, SCREEN_WIDTH/2, 30)];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    label.text = @"Copied";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.alpha =0;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:1 animations:^{
        [self.tableView addSubview:label];
        label.alpha =1;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked:)];
}

-(void)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)recordSocialActionForActionType:(NSString*)socialActionName
{
    if ([self.campaginDetails objectForKey:@"socialactions"]) {
        for (NSDictionary * socialAction in [self.campaginDetails valueForKey:@"socialactions"]) {
            if ([[socialAction valueForKey:@"socialActionName"] isEqualToString:socialActionName]) {
           
                [AppVirality recordSocialActionForGrowthHack:self.growthHack WithParams:@{@"shareMessage":[socialAction valueForKey:@"shareMessage"],@"shortcode":[[[socialAction valueForKey:@"shareUrl"] stringByDeletingLastPathComponent] lastPathComponent],@"socialActionId":[socialAction valueForKey:@"socialActionId"]} completion:^(BOOL success,NSError*error) {
                    
                }];
            }
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [AppVirality registerAsDebugDevice:^(BOOL success,NSError*error) {
            NSLog(@" debug mode %d",success);
        }];
        
    }
}

-(void)logoClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appvirality.com"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)faceBookButtonClicked:(id)sender
{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://publish/profile/me?text=%@",[self.shareMesgs objectForKey:@"Facebook"]?[[self.shareMesgs valueForKey:@"Facebook"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [self recordSocialActionForActionType:@"Facebook"];
//        [[UIApplication sharedApplication] openURL:url];
//    }
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookcomposer =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookcomposer addURL:[NSURL URLWithString:[self.shareUrls objectForKey:@"Facebook"]?[self.shareUrls valueForKey:@"Facebook"]:@""]];
        [self presentViewController:facebookcomposer animated:YES completion:nil];
        [facebookcomposer setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultDone:
                    [self recordSocialActionForActionType:@"Facebook"];
                     break;
                 case SLComposeViewControllerResultCancelled:
                     NSLog(@"cancelled");
                     break;
                 default:
                     break;
             }
         }];
    }
}

-(void)twitterButtonClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@",[self.shareMesgs objectForKey:@"Twitter"]?[[self.shareMesgs valueForKey:@"Twitter"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [self recordSocialActionForActionType:@"Twitter"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)whatsappButtonClicked:(id)sender
{
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",[self.shareMesgs objectForKey:@"WhatsApp"]?[[self.shareMesgs valueForKey:@"WhatsApp"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [self recordSocialActionForActionType:@"WhatsApp"];
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

-(void)mailButtonClicked:(id)sender
{
    NSURL *mailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?body=%@",[self.shareMesgs objectForKey:@"Mail"]?[[self.shareMesgs valueForKey:@"Mail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:@""]];
    if ([[UIApplication sharedApplication] canOpenURL: mailURL]) {
        [self recordSocialActionForActionType:@"Mail"];
        [[UIApplication sharedApplication] openURL: mailURL];

    }
}


-(void)moreButtonClicked:(id)sender
{
    NSURL *myWebsite = [NSURL URLWithString:[[self.shareLabel.text componentsSeparatedByString:@"\n"] lastObject]];
    NSString * message = [[self.shareMesgs allValues] firstObject];
    NSArray *objectsToShare = @[myWebsite,message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            if([activityType isEqualToString: UIActivityTypeMail]){
                [self recordSocialActionForActionType:@"Mail"];
            }else if([activityType isEqualToString: UIActivityTypePostToFacebook]){
                [self recordSocialActionForActionType:@"Facebook"];
            }else if([activityType isEqualToString: UIActivityTypePostToTwitter]){
                [self recordSocialActionForActionType:@"Twitter"];
            }else
            {
                [self recordSocialActionForActionType:@"CustomLink"];
            }
        }
        
    }];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Table View Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.selectedSections containsObject:[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    if (section==2) {
        return 1;
    }
    if (section==1) {
        return self.referredusers.count;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2&&indexPath.row==0) {
        return self.termsHeight==0?45:self.termsHeight;
    }
    return 45;
}

-(void)viewWillLayoutSubviews
{
    self.greetingLabel.frame = CGRectMake(CGRectGetMinX(self.greetingLabel.frame),CGRectGetMinY(self.greetingLabel.frame), CGRectGetWidth(self.greetingLabel.frame), CGRectGetHeight(self.greetingLabel.frame));
    
    self.messageLabel.frame = CGRectMake(CGRectGetMinX(self.messageLabel.frame),CGRectGetMaxY(self.greetingLabel.frame)+20, CGRectGetWidth(self.messageLabel.frame), CGRectGetHeight(self.messageLabel.frame));
    
    self.shareLabel.frame = CGRectMake(CGRectGetMinX(self.shareLabel.frame),CGRectGetMaxY(self.messageLabel.frame)+10, CGRectGetWidth(self.shareLabel.frame), CGRectGetHeight(self.shareLabel.frame));
    
    
    self.facebookButton.frame = CGRectMake(CGRectGetMinX(self.facebookButton.frame),CGRectGetMaxY(self.shareLabel.frame)+10, CGRectGetWidth(self.facebookButton.frame), CGRectGetHeight(self.facebookButton.frame));
    self.twitterButton.frame = CGRectMake(CGRectGetMinX(self.twitterButton.frame),CGRectGetMaxY(self.shareLabel.frame)+10, CGRectGetWidth(self.twitterButton.frame), CGRectGetHeight(self.twitterButton.frame));
    self.whatsappButton.frame = CGRectMake(CGRectGetMinX(self.whatsappButton.frame),CGRectGetMaxY(self.shareLabel.frame)+10, CGRectGetWidth(self.whatsappButton.frame), CGRectGetHeight(self.whatsappButton.frame));
    self.mailButton.frame = CGRectMake(CGRectGetMinX(self.mailButton.frame),CGRectGetMaxY(self.shareLabel.frame)+10, CGRectGetWidth(self.mailButton.frame), CGRectGetHeight(self.mailButton.frame));

    self.moreButton.frame = CGRectMake(CGRectGetMinX(self.moreButton.frame),CGRectGetMaxY(self.facebookButton.frame)+30, CGRectGetWidth(self.moreButton.frame), CGRectGetHeight(self.moreButton.frame));
    
    if (self.logoView) {
    self.logoView.frame = CGRectMake(CGRectGetMinX(self.logoView.frame),CGRectGetMaxY(self.facebookButton.frame)+30, CGRectGetWidth(self.logoView.frame), CGRectGetHeight(self.logoView.frame));
    }

}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * headerArray = @[@"Earnings",@"Successful Referrals",@"How it works?"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, SCREEN_WIDTH-42, 35)];
    headerLabel.text = [headerArray objectAtIndex:section];
    headerLabel.textColor = self.greetingLabel.textColor;
    [headerView addSubview:headerLabel];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.tintColor = self.greetingLabel.textColor;
    imageView.transform = CGAffineTransformMakeRotation([self.selectedSections containsObject:[NSNumber numberWithInteger:section]]?-M_PI_2:M_PI_2);
    imageView.frame = CGRectOffset(imageView.frame, SCREEN_WIDTH-60, 15);
    [headerView addSubview:imageView];
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(0.0, 0.0, SCREEN_WIDTH, 45)];
    button.alpha = 0.7;
    button.tag = section;
    /* Prepare target-action */
    [button addTarget: self action: @selector(headerSelected:)
     forControlEvents: UIControlEventTouchUpInside];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(headerView.frame)-1, SCREEN_WIDTH-10, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:lineView];
    [headerView addSubview: button];

    return headerView;
}

-(void)headerSelected:(UIButton*)sender
{
    NSInteger tag = [sender tag];
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:tag]]) {
        [self.selectedSections removeObject:[NSNumber numberWithInteger:tag]];
    }else
        [self.selectedSections addObject:[NSNumber numberWithInteger:tag]];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (tag<2) {
        if (!self.userPoints) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [AppVirality getUserBalance:self.growthHack completion:^(NSDictionary *userInfo,NSError*error) {
                self.userPoints = [(NSArray*)[userInfo valueForKey:@"userpoints"] firstObject];
                self.referredusers = [userInfo valueForKey:@"referredusers"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                });
            }];        }
       
    }
    
    if (tag==2) {
        if (!self.terms) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [AppVirality getTerms:self.growthHack completion:^(NSDictionary *userTerms,NSError*error) {
                NSLog(@"user terms%@",userTerms);
                if ([userTerms objectForKey:@"message"]) {
                    self.terms = [userTerms valueForKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView beginUpdates];
                        [self.tableView endUpdates];
                    });
                    
                  }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }];
        }
    }
 
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:tag]])
    {
        if (tag==1&&self.referredusers.count==0) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:tag]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        });
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = [@"reuseIdentifier" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    //NSLog(@"%ld %ld %@",(long)indexPath.section,(long)indexPath.row,reuseIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    

    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    if (indexPath.section==0) {
        NSArray * titleArray = @[@"total",@"claimed",@"pending"];
        cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = self.greetingLabel.textColor;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.text =@"0";
        if (self.userPoints&&[self.userPoints objectForKey:[titleArray objectAtIndex:indexPath.row]]) {
            label.text = [self.userPoints valueForKey:[titleArray objectAtIndex:indexPath.row]];
        }
        label.textColor = self.greetingLabel.textColor;

        cell.accessoryView = label;
        return cell;
    }
    
    if (indexPath.section==2) {
        if (self.terms) {
            cell.textLabel.text = self.terms;
            NSString * htmlString = [self.terms stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
         //   NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
           // cell.textLabel.attributedText = attributedString;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines=0;

            if (self.termsHeight==0) {
                [AppViralityUIUtility resetLabelHeight:cell.textLabel];
                self.termsHeight = CGRectGetHeight(cell.textLabel.frame)+30;

                [self.tableView reloadData];
                
            }else
            {
                cell.textLabel.text = @"";

                if (!self.termsView) {
                    self.termsView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.termsHeight)];
                    self.termsView.alpha=0.5f;
                    [self.termsView setBackgroundColor:[UIColor clearColor]];
                    [self.termsView setOpaque:NO];
                }
                [self.termsView loadHTMLString:htmlString baseURL:nil];
                [cell.contentView addSubview:self.termsView];
            }
           
        }
    }
    
    if (indexPath.section==1) {
        cell.textLabel.text = @"no name";
        cell.imageView.image  = [UIImage imageNamed:@"profileIcon.png"];
        if ([[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"emailid"]&&![[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"emailid"] isEqual:[NSNull null]]) {
            cell.textLabel.text =[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"emailid"];
        }
        if ([[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"name"]&&![[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"name"] isEqual:[NSNull null]]) {
            cell.textLabel.text =[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"name"];
        }
        if ([[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"regdate"]&&![[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"regdate"] isEqual:[NSNull null]]) {
            cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"\n%@",[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"regdate"]];
            cell.textLabel.numberOfLines = 0;
        }
        if ([[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"profileimage"]&&![[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"profileimage"] isEqual:[NSNull null]]) {
            [AppViralityUIUtility downloadImageWithURL:[NSURL  URLWithString:[[self.referredusers objectAtIndex:indexPath.row] objectForKey:@"profileimage"]] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded&&image) {
                    cell.imageView.image = image;
                    cell.imageView.layer.cornerRadius = CGRectGetWidth(cell.imageView.frame)/2;
                    cell.imageView.layer.masksToBounds = YES;
                }
            }];
        }
        
        cell.textLabel.textColor = self.greetingLabel.textColor;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
