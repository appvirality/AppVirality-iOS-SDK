//
//  AppViralityWelcomeViewController.m
//  testAV
//
//  Created by Ram on 07/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import "AppViralityWelcomeViewController.h"
#import "AppVirality.h"
#import "AppViralityUIUtility.h"
#import "MBProgressHUD.h"

@interface AppViralityWelcomeViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong) UIImageView * ProfileImageView;
@property (strong) UIButton * closeButton;
@property (strong) UITextField * textField;
@property (strong) UITextField * txtReferrerCode;

@end


@implementation AppViralityWelcomeViewController

NSDictionary * referrerInfo;

-(id)initWithReferrerDetails:(NSDictionary *)referrerDetails
{
    if (!referrerDetails) {
        return nil;
    }
    if ([[referrerDetails valueForKey:@"isExistingUser"] isEqualToString:@"True"]) {
        return nil;
    }
    self = [self init];
    if (self) {
        
        referrerInfo = referrerDetails;

        unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"CampaignBGColor" InDictionary:referrerDetails];
        self.view.backgroundColor =(color==0)?self.view.backgroundColor:UIColorFromRGB(color);
        
        
        self.greetingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/5, SCREEN_WIDTH, 40)];
        self.greetingLabel.text = [NSString stringWithFormat:@"You've been invited!"];
        self.greetingLabel.textAlignment = NSTextAlignmentCenter;
        self.greetingLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.view addSubview:self.greetingLabel];
        color = [AppViralityUIUtility checkAndGetColorAtKey:@"OfferTitleColor" InDictionary:referrerDetails];
        self.greetingLabel.textColor =color==0?self.greetingLabel.textColor:UIColorFromRGB(color);
        
        self.ProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.greetingLabel.frame), 100, 100)];
        self.ProfileImageView.layer.cornerRadius = CGRectGetWidth(self.ProfileImageView.frame)/2;
        self.ProfileImageView.clipsToBounds = YES;
        [self.view addSubview:self.ProfileImageView];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.ProfileImageView.frame)+20, SCREEN_WIDTH-40, 120)];
        self.messageLabel.text = [NSString stringWithFormat:@"$10 from Francis\ncreate an account\nand claim credit..."];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines=0;
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:self.messageLabel];
        if ([referrerDetails objectForKey:@"WelcomeMessage"]) {
            NSString * descriptionText= [referrerDetails valueForKey:@"WelcomeMessage"];
            descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
            unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"OfferDescriptionColor" InDictionary:referrerDetails];
            self.messageLabel.textColor =color==0?self.messageLabel.textColor:UIColorFromRGB(color);
            
            self.messageLabel.text = descriptionText;
            [AppViralityUIUtility resetLabelHeight:self.messageLabel];
//            NSError *err = nil;
//            NSString * string =     [NSString stringWithFormat:@"<div style='color:#%d;'>%@</div>",color,descriptionText];

//            self.messageLabel.attributedText =
//            [[NSAttributedString alloc]
//             initWithData: [string dataUsingEncoding:NSUTF8StringEncoding]
//             options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorFromRGB(color) }
//             documentAttributes: nil
//             error: &err];
        }
        
        
        self.claimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.claimButton.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+30, 100, 50);
        [self.claimButton setTitle:@"Signup" forState:UIControlStateNormal];
        self.claimButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.claimButton addTarget:self action:@selector(signUpButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [self.claimButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.claimButton.layer.borderWidth=1;
        [self.view addSubview:self.claimButton];

        if ([referrerDetails objectForKey:@"FriendRewardEvent"]) {
            if ([[referrerDetails valueForKey:@"FriendRewardEvent"] isEqualToString:@"Install"]) {
                self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+20, 240, 40)];
                self.textField.delegate = self;
                self.textField.borderStyle = UITextBorderStyleRoundedRect;
                self.textField.center = CGPointMake(SCREEN_WIDTH/2, self.textField.center.y);
                self.textField.placeholder = @"Email";
                [self.view addSubview:self.textField];
                
                self.txtReferrerCode = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textField.frame)+15, 240, 40)];
                self.txtReferrerCode.delegate = self;
                self.txtReferrerCode.borderStyle = UITextBorderStyleRoundedRect;
                self.txtReferrerCode.center = CGPointMake(SCREEN_WIDTH/2, self.txtReferrerCode.center.y);
                self.txtReferrerCode.placeholder = @"Enter Referral Code";
                [self.view addSubview:self.txtReferrerCode];
                
                if ([referrerDetails objectForKey:@"ReferrerCode"]) {
                    self.txtReferrerCode.text = [referrerDetails objectForKey:@"ReferrerCode"];
                }
                
                if(([referrerInfo objectForKey:@"attributionSetting"] && [[referrerInfo objectForKey:@"attributionSetting"] integerValue] == 0) ||
                   ([referrerInfo objectForKey:@"isReferrerConfirmed"] && [[referrerInfo objectForKey:@"isReferrerConfirmed"] boolValue])){
                    [self.txtReferrerCode setHidden:YES];
                    
                }

                
                self.claimButton.frame = CGRectMake(0, CGRectGetMaxY(self.txtReferrerCode.frame)+10, 100, 50);
                [self.claimButton setTitle:@"Claim" forState:UIControlStateNormal];
                [self.claimButton removeTarget:self action:@selector(signUpButtonClicked:) forControlEvents:UIControlEventTouchDown];
                [self.claimButton addTarget:self action:@selector(claimButtonClicked:) forControlEvents:UIControlEventTouchDown];
                [self.claimButton setTitleColor:self.greetingLabel.textColor forState:UIControlStateNormal];
                
                
            }else if([[referrerDetails valueForKey:@"FriendRewardEvent"] isEqualToString:@"Signup"]){
                
                
                if(([referrerInfo objectForKey:@"attributionSetting"] && [[referrerInfo objectForKey:@"attributionSetting"] integerValue] != 0) &&
                   ([referrerInfo objectForKey:@"isReferrerConfirmed"] && ![[referrerInfo objectForKey:@"isReferrerConfirmed"] boolValue])){

                self.txtReferrerCode = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+15, 240, 40)];
                self.txtReferrerCode.delegate = self;
                self.txtReferrerCode.borderStyle = UITextBorderStyleRoundedRect;
                self.txtReferrerCode.center = CGPointMake(SCREEN_WIDTH/2, self.txtReferrerCode.center.y);
                self.txtReferrerCode.placeholder = @"Enter Referral Code";
                [self.view addSubview:self.txtReferrerCode];
                
                if ([referrerDetails objectForKey:@"ReferrerCode"]) {
                    self.txtReferrerCode.text = [referrerDetails objectForKey:@"ReferrerCode"];
                }
                
                self.claimButton.frame = CGRectMake(0, CGRectGetMaxY(self.txtReferrerCode.frame)+10, 100, 50);
                [self.claimButton setTitleColor:self.greetingLabel.textColor forState:UIControlStateNormal];
                }
                
            }
            else if (![[referrerDetails valueForKey:@"FriendRewardEvent"] isEqualToString:@"Signup"]) {
                
                [self.claimButton setTitle:@"Skip" forState:UIControlStateNormal];
                [self.claimButton removeTarget:self action:@selector(signUpButtonClicked:) forControlEvents:UIControlEventTouchDown];
                [self.claimButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchDown];
            }

        }
        self.claimButton.center = CGPointMake(SCREEN_WIDTH/2, self.claimButton.center.y);
        self.claimButton.layer.cornerRadius = 5;
        self.claimButton.layer.masksToBounds = YES;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(0, CGRectGetMaxY(self.claimButton.frame)+30, 100, 50);
        self.closeButton.center = CGPointMake(self.view.center.x, self.closeButton.center.y);
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        self.closeButton.layer.borderColor = [UIColor blackColor].CGColor;
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchDown];

        self.closeButton.layer.borderWidth=1;
        
        if ([referrerDetails objectForKey:@"ProfileImage"]) {
            [AppViralityUIUtility downloadImageWithURL:[NSURL  URLWithString:[referrerDetails objectForKey:@"ProfileImage"]] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded&&image) {
                    self.ProfileImageView.image = image;
                    self.ProfileImageView.center = CGPointMake(self.view.center.x, self.ProfileImageView.center.y);
                }
            }];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStyleDone target:self action:@selector(closeButtonClicked:)];

    }
    return self;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)signUpButtonClicked:(id)sender
{
    
    if (([referrerInfo objectForKey:@"attributionSetting"] && [[referrerInfo objectForKey:@"attributionSetting"] integerValue] == 2 ) &&
        ([referrerInfo objectForKey:@"isReferrerConfirmed"] && ![[referrerInfo objectForKey:@"isReferrerConfirmed"] boolValue]) &&
        [self.txtReferrerCode.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the Referralcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=1;
        [alert show];
        return;
    }
    
    //check for referralcode and check if attribution setting is not only through link and attribution status
    if ((![[self.txtReferrerCode.text stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        && ([referrerInfo objectForKey:@"attributionSetting"] && [[referrerInfo objectForKey:@"attributionSetting"] integerValue] != 0 )
        && ([referrerInfo objectForKey:@"isReferrerConfirmed"] && ![[referrerInfo objectForKey:@"isReferrerConfirmed"] boolValue])){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [AppVirality submitReferralCode:self.txtReferrerCode.text completion:^(BOOL success, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (success) {
                NSLog(@"Referral Code applied Successfully");
            }
            else{
                NSLog(@"Invalid Referral Code");
            }
            
            [self closeButtonClicked:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
        }];
        
    }
    else
    {
        [self closeButtonClicked:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUpClicked" object:nil];
    }
    
    
}
-(void)claimButtonClicked:(id)sender
{
    if ([self.textField.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //check for referralcode and check if attribution setting is not only through link and attribution status
    if ((![[self.txtReferrerCode.text stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        && ([referrerInfo objectForKey:@"attributionSetting"] && [referrerInfo objectForKey:@"attributionSetting"] != 0 )
        && ([referrerInfo objectForKey:@"isReferrerConfirmed"] && ![[referrerInfo objectForKey:@"isReferrerConfirmed"] boolValue])){
        
        [AppVirality submitReferralCode:self.txtReferrerCode.text completion:^(BOOL success, NSError *error) {
            
            if (success) {
                NSLog(@"Referral Code applied Successfully");
            }
            else{
                NSLog(@"Invalid Referral Code");
            }
            
            [self processClaimButtonClick:nil];
        }];
        
    }
    else
    {
        [self processClaimButtonClick:nil];
    }
   
}

-(void)processClaimButtonClick:(id)sender
{
    // update user Email before sending the conversion event
    [AppVirality setUserDetails:@{@"EmailId":self.textField.text} Oncompletion:^(BOOL success, NSError *error) {
        // Send install conversion event
        [AppVirality saveConversionEvent:@{@"eventName":@"Install"} completion:^(NSDictionary *conversionResult,NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (conversionResult&&[conversionResult objectForKey:@"success"]&&(![[conversionResult valueForKeyPath:@"friend.rewarddtlid"] isEqual:[NSNull null]] || ![[conversionResult valueForKeyPath:@"friend.rewardid"] isEqual:[NSNull null]])) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[conversionResult valueForKey:@"success"] boolValue]?@"Hurray..! you will receive your reward shortly":@"Reward is on for first time users, but you can still earn by referring your friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 1) {
        [self closeButtonClicked:nil];
    }
}

-(void)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self.txtReferrerCode resignFirstResponder];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.textField.frame = CGRectMake(self.textField.frame.origin.x, (self.textField.frame.origin.y - 100.0), self.textField.frame.size.width, self.textField.frame.size.height);
        self.txtReferrerCode.frame = CGRectMake(self.txtReferrerCode.frame.origin.x, (self.txtReferrerCode.frame.origin.y - 100.0), self.txtReferrerCode.frame.size.width, self.txtReferrerCode.frame.size.height);
        [UIView commitAnimations];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.textField.frame = CGRectMake(self.textField.frame.origin.x, (self.textField.frame.origin.y + 100.0), self.textField.frame.size.width, self.textField.frame.size.height);
        self.txtReferrerCode.frame = CGRectMake(self.txtReferrerCode.frame.origin.x, (self.txtReferrerCode.frame.origin.y + 100.0), self.txtReferrerCode.frame.size.width, self.txtReferrerCode.frame.size.height);
        [UIView commitAnimations];
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
