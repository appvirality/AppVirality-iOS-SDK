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
static NSString *AppVirality_AppKey = @"YOUR-APP-KEY-HERE";

UITextField *textEmail,*textReferrerCode,*textExistingUser,*textCountry;

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
    
    self.btnInitWithEmail.layer.cornerRadius = 5;
    self.btnInitWithEmail.layer.borderWidth = 1;
    self.btnInitWithEmail.layer.borderColor = self.userRewards.titleLabel.textColor.CGColor;
    
    self.btnLogOut.layer.cornerRadius = 5;
    self.btnLogOut.layer.borderWidth = 1;
    self.btnLogOut.layer.borderColor = self.btnLogOut.titleLabel.textColor.CGColor;
    
    self.btnCheckAttribution.layer.cornerRadius = 5;
    self.btnCheckAttribution.layer.borderWidth = 1;
    self.btnCheckAttribution.layer.borderColor = self.btnCheckAttribution.titleLabel.textColor.CGColor;
    
    self.btnChangeReferralCode.layer.cornerRadius = 5;
    self.btnChangeReferralCode.layer.borderWidth = 1;
    self.btnChangeReferralCode.layer.borderColor = self.btnChangeReferralCode.titleLabel.textColor.CGColor;
    
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
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+300);

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
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter ReferralCode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[av textFieldAtIndex:0] setPlaceholder:@"Referral Code"];
    av.tag =54;
    [av show];
    
}
-(IBAction)checkAttribution:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter ReferrerCode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[av textFieldAtIndex:0] setPlaceholder:@"Referrer Code"];
    av.tag =56;
    [av show];
    
}

-(IBAction)changeReferralCode:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter New ReferralCode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[av textFieldAtIndex:0] setPlaceholder:@"Referral Code"];
    av.tag =57;
    [av show];
    
}

-(IBAction)transaction:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter value" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    av.tag =52;
    [av show];
}

-(IBAction)initWithEmail:(id)sender
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    
    textEmail = [[UITextField alloc] initWithFrame:CGRectMake(10,0,252,25)];
    textEmail.borderStyle = UITextBorderStyleRoundedRect;
    textEmail.placeholder = @"EmailId";
    textEmail.keyboardAppearance = UIKeyboardAppearanceAlert;
    [myView addSubview:textEmail];
    
    textReferrerCode = [[UITextField alloc] initWithFrame:CGRectMake(10,30,252,25)];
    textReferrerCode.placeholder = @"ReferralCode";
    textReferrerCode.borderStyle = UITextBorderStyleRoundedRect;
    textReferrerCode.keyboardAppearance = UIKeyboardAppearanceAlert;
    [myView addSubview:textReferrerCode];
    
    
    textExistingUser = [[UITextField alloc] initWithFrame:CGRectMake(10,60,252,25)];
    textExistingUser.placeholder = @"ExistingUser ture or false";
    textExistingUser.borderStyle = UITextBorderStyleRoundedRect;
    textExistingUser.keyboardAppearance = UIKeyboardAppearanceAlert;
    [myView addSubview:textExistingUser];
    
    textCountry = [[UITextField alloc] initWithFrame:CGRectMake(10,60,252,25)];
    textCountry.placeholder = @"Country";
    textCountry.borderStyle = UITextBorderStyleRoundedRect;
    textCountry.keyboardAppearance = UIKeyboardAppearanceAlert;
    [myView addSubview:textCountry];

    
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"INIT SDK" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [av setValue:myView forKey:@"accessoryView"];
    av.tag=55;
    [av show];
}

-(IBAction)logOut:(id)sender
{
    [AppVirality logout];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Success..!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
            NSDictionary * userDetails = @{@"EmailId":[actionSheet textFieldAtIndex:0].text,@"AppUserName":[actionSheet textFieldAtIndex:1].text,@"ProfileImage":@"https://growth.appvirality.com/Images/no_profileimage.jpg",@"UserIdInstore":@"av1",@"city":@"Pune",@"state":@"Maharashtra",@"country":@"India",@"Phone":@"987654321"};

            [AppVirality setUserDetails:userDetails Oncompletion:^(BOOL success, NSError *error) {
                NSLog(@"User Details update Status %d", success);
            }];
            
        }
    }
    
    //Update ReferralCode
    if (actionSheet.tag==54) {
        if (buttonIndex!=0&&(![[actionSheet textFieldAtIndex:0].text isEqualToString:@""])) {
            NSLog(@"entered referralcode  %@",[actionSheet textFieldAtIndex:0].text);
            [AppVirality submitReferralCode:[actionSheet textFieldAtIndex:0].text completion:^(BOOL success, NSError *error) {
                
                if (success) {
                    NSLog(@"Referral Code applied Successfully");
                }
                else{
                    NSLog(@"Invalid Referral Code");
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
            }];
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];

        }
    }
    
    //Init with Email
    if (actionSheet.tag==55) {
        if (buttonIndex!=0&&(![textEmail.text isEqualToString:@""])) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            NSLog(@"entered EmailID  %@",textEmail.text);
            NSDictionary * userDetails = [NSMutableDictionary dictionary];
            [userDetails setValue:textEmail.text forKey:@"EmailId"];
            if (![textReferrerCode.text isEqualToString:@""]) {
                [userDetails setValue:textReferrerCode.text forKey:@"ReferrerCode"];
            }
            if (![textExistingUser.text isEqualToString:@""]) {
                [userDetails setValue:textExistingUser.text forKey:@"isExistingUser"];
            }
            if (![textCountry.text isEqualToString:@""]) {
                [userDetails setValue:textCountry.text forKey:@"country"];
            }

            // Enable cookie based attribution to achieve 100% attribution accuracy
            [AppVirality attributeUserBasedonCookie:AppVirality_AppKey OnCompletion:^(BOOL success, NSError *error) {

                [AppVirality enableInitWithEmail];
                // Init AppVirality SDK
                [AppVirality initWithApiKey:AppVirality_AppKey WithParams:userDetails OnCompletion:^(NSDictionary *referrerDetails,NSError*error) {
                    NSLog(@"user key %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"]);
                    NSLog(@"User has Referrer %@", referrerDetails);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error? error.localizedDescription : @"Init Success..!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];


                }];
            }];
            
        }
    }
    //check Attribution
    if (actionSheet.tag==56) {
        if (buttonIndex!=0) {
            NSLog(@"entered referrercode  %@",[actionSheet textFieldAtIndex:0].text);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [AppVirality checkAttribution:AppVirality_AppKey withReferrerCode:[actionSheet textFieldAtIndex:0].text OnCompletion:^(NSDictionary *referrerDetails, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                if(!error && referrerDetails)
                {
                    NSLog(@"User has Referrer %@", referrerDetails);

                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"hasReferrer: %@ isexistingUser: %@  ReferrerCode: %@ ReferrerName: %@",[referrerDetails valueForKey:@"hasReferrer"],[referrerDetails valueForKey:@"isExistingUser"],[referrerDetails valueForKey:@"ReferrerCode"],[referrerDetails valueForKey:@"ReferrerName"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error? error.localizedDescription : @"Failed..!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];

                }
                
            }];
        }
    }
    //Change Referral Code
    if (actionSheet.tag==57) {
        if (buttonIndex!=0) {
            NSLog(@"entered referralcode  %@",[actionSheet textFieldAtIndex:0].text);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [AppVirality customizeReferralCode:[actionSheet textFieldAtIndex:0].text completion:^(BOOL success, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                if(!error && success)
                {
                    NSLog(@"Update Success..!");
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"update success..!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:error? error.localizedDescription : @"Update Failed..!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                
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
    [AppVirality getUserBalanceV2:GrowthHackTypeAll completion:^(NSDictionary *userInfo, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if(!error)
        {
            NSLog(@"Aggregated user Balance & Friends List %@", userInfo);
        }
        else{
            NSLog(@"%@",[error localizedDescription]);
        }
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
