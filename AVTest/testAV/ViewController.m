//
//  ViewController.m
//  testAV
//
//  Created by Ram on 14/04/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import "ViewController.h"
#import "AppViralityUI.h"
#import "MBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.updateUserDetails.layer.cornerRadius = 5;
    self.updateUserDetails.layer.borderWidth = 1;
    self.updateUserDetails.layer.borderColor = self.updateUserDetails.titleLabel.textColor.CGColor;
    
    self.signUp.layer.cornerRadius = 5;
    self.signUp.layer.borderWidth = 1;
    self.signUp.layer.borderColor = self.signUp.titleLabel.textColor.CGColor;
    
    self.showGrowthHack.layer.cornerRadius = 5;
    self.showGrowthHack.layer.borderWidth = 1;
    self.showGrowthHack.layer.borderColor = self.showGrowthHack.titleLabel.textColor.CGColor;
    
    self.transaction.layer.cornerRadius = 5;
    self.transaction.layer.borderWidth = 1;
    self.transaction.layer.borderColor = self.transaction.titleLabel.textColor.CGColor;
    
    
    self.miniNotification.layer.cornerRadius = 5;
    self.miniNotification.layer.borderWidth = 1;
    self.miniNotification.layer.borderColor = self.miniNotification.titleLabel.textColor.CGColor;
    
    self.userRewards.layer.cornerRadius = 5;
    self.userRewards.layer.borderWidth = 1;
    self.userRewards.layer.borderColor = self.userRewards.titleLabel.textColor.CGColor;
    
    self.getReferrerReward.layer.cornerRadius = 5;
    self.getReferrerReward.layer.borderWidth = 1;
    self.getReferrerReward.layer.borderColor = self.getReferrerReward.titleLabel.textColor.CGColor;
    
    self.getUserCoupons.layer.cornerRadius = 5;
    self.getUserCoupons.layer.borderWidth = 1;
    self.getUserCoupons.layer.borderColor = self.getUserCoupons.titleLabel.textColor.CGColor;
    
    
    //    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AVapiKey"]);
    //    NSLog(@"user key %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"]);
    
    //  [AppViralityUI showGrowthHack:GrowthHackTypeWordOfMouth FromController:self];
    //    [AppVirality getReferrerDetails:^(NSDictionary *referrerDetails,NSError*error) {
    //        NSLog(@"iski refferer %@",referrerDetails);
    //    }];
    
    //Show Welcome screen
    [AppViralityUI showWelcomeScreenFromController:self];
    
    // Add observer for Signup button click on Welcome page & Register Signup Conversion event
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SignUpClicked" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"Sign up clicked");
        [AppVirality saveConversionEvent:@{@"eventName":@"Signup"} completion:^(NSDictionary *conversionResult,NSError* error) {
            if (conversionResult&&[conversionResult objectForKey:@"success"]&&![[conversionResult valueForKeyPath:@"friend.rewardid"] isEqual:[NSNull null]]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[conversionResult valueForKey:@"success"] boolValue]?@"Hurray..! you will receive your reward shortly":@"Reward is on for first time users, but you can still earn by referring your friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }];
    }];
    
    //App-level Reward notifications (or) Add Observer to get notified on any Successful conversion
    [[NSNotificationCenter defaultCenter] addObserverForName:@"conversionResult" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"conversion Event result %@",[note valueForKeyPath:@"userInfo.result"]);
    }];
    [self registerForRemoteNotifications];
}


-(IBAction)userDetails:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[av textFieldAtIndex:1] setSecureTextEntry:NO];
    [[av textFieldAtIndex:0] setPlaceholder:@"Email"];
    
    [[av textFieldAtIndex:1] setPlaceholder:@"Name"];
    av.tag = 53;
    [av show];
}


-(IBAction)signup:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
}


-(IBAction)transaction:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.tag =52;
    [av show];
}

- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Register Transaction conversion event
    if (actionSheet.tag==52) {
        if (buttonIndex!=0&&(![[actionSheet textFieldAtIndex:0].text isEqualToString:@""])) {
            [AppVirality saveConversionEvent:@{@"eventName":@"Transaction",@"transactionValue":[actionSheet textFieldAtIndex:0].text,@"transactionUnit":@"$"} completion:^(NSDictionary *conversionResult,NSError* error) {
                if (conversionResult&&[conversionResult objectForKey:@"success"]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[conversionResult valueForKey:@"success"] boolValue]?@"Recorded":@"Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
            }];
        }
    }
    //Update UserDetails
    if (actionSheet.tag==53) {
        if (buttonIndex!=0&&(![[actionSheet textFieldAtIndex:0].text isEqualToString:@""]&&(![[actionSheet textFieldAtIndex:1].text isEqualToString:@""]))) {
            NSDictionary * userDetails = @{@"EmailId":[actionSheet textFieldAtIndex:0].text,@"AppUserName":[actionSheet textFieldAtIndex:1].text,@"ProfileImage":@"https://growth.appvirality.com/Images/no_profileimage.jpg",@"UserIdInstore":@"av1",@"city":@"Pune",@"state":@"Maharashtra",@"country":@"India",@"Phone":@"9876543210"};

            [AppVirality setUserDetails:userDetails Oncompletion:^(BOOL success, NSError *error) {
                NSLog(@"User Details update Status %d", success);
            }];
            
        }
    }
    
}

// Show Growthhack
-(IBAction)showGrowthHack:(id)sender
{
    [AppViralityUI showGrowthHack:GrowthHackTypeWordOfMouth FromController:self];
}
// Show mini notification
-(IBAction)showLaunchBar:(id)sender
{
    [AppViralityUI showLaunchBar:GrowthHackTypeWordOfMouth FromController:self];

}
// Get user Rewards & the detailed break up
-(IBAction)getUserRewards:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AppVirality getUserRewards:^(NSDictionary *rewards, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        NSLog(@"User Rewards Breakup %@", rewards);
    }];
    
}

// List pending rewards earned as Referrer
-(IBAction)getReferrerReward:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AppVirality checkReferrerRewards:^(NSDictionary *rewards, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        NSLog(@"List pending rewards earned as Referrer %@", rewards);
    }];
    
}

// Get aggriaged user Balance & Friends List
-(IBAction)getUserBalance:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AppVirality getUserBalance:GrowthHackTypeWordOfMouth completion:^(NSDictionary *userInfo, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        NSLog(@"Aggregated user Balance & Friends List %@", userInfo);
    }];
    
}
// Get the list of user coupons
-(IBAction)getUserCoupons:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AppVirality getUserCoupons:^(NSDictionary *coupons, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        NSLog(@"User coupons list %@", coupons);
    }];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  [AppViralityUI showPopUp:GrowthHackTypeWordOfMouth FromController:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
