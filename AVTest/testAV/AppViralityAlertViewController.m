//
//  AppViralityAlertViewController.m
//  testAV
//
//  Created by Ram on 08/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import "AppViralityAlertViewController.h"
#import "AppVirality.h"
#import "AppViralityUIUtility.h"
UIView* AlertView;

@interface AppViralityAlertViewController ()
@end

@implementation AppViralityAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f,size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+(BOOL)shouldPresentNotification
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"campaignData"]) {
        NSDictionary * campaignData = [[[NSUserDefaults standardUserDefaults] valueForKey:@"campaignData"] objectAtIndex:0];
        if ([campaignData objectForKey:@"campaignusertargettingdetails"]) {
            NSArray * targettingDetails  = [campaignData valueForKey:@"campaignusertargettingdetails"];
            for (NSDictionary * targettingDetail in targettingDetails) {
                if ([[targettingDetail valueForKey:@"targetName"] isEqualToString:@"Days_After_launch"]) {
                    NSInteger numberOfDays = [[targettingDetail valueForKey:@"TargetValue"] integerValue];
                    if (numberOfDays>0 &&([self daysBetweenDate:[NSDate date] andDate:[[NSUserDefaults standardUserDefaults] valueForKey:@"firstLaunch"]]>numberOfDays)) {
                        return NO;
                    }
                }
                if ([[targettingDetail valueForKey:@"targetName"] isEqualToString:@"Number_of_Launches"]) {
                    NSInteger numberOfLaunches = [[targettingDetail valueForKey:@"TargetValue"] integerValue];
                    if (numberOfLaunches>0 &&([[[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfLaunches"] integerValue]<numberOfLaunches)) {
                        return NO;
                    }
                }
                if ([[targettingDetail valueForKey:@"targetName"] isEqualToString:@"Show_Campaign_For"]) {
                    NSInteger numberOfLaunches = [[targettingDetail valueForKey:@"TargetValue"] integerValue];
                    if (numberOfLaunches>0 &&([[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfImpressions"])&&([[[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfImpressions"] integerValue]<numberOfLaunches)) {
                        return NO;
                    }
                }
            }
        }else
            return NO;
    }else
        return NO;
    
    return YES;
}
+(void) CurrentView:(UIView *)viewtoShow errorString:(NSDictionary *)campaignDetails isPopup:(BOOL)isPopUp
{
    if (![self shouldPresentNotification]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastImpression"];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfImpressions"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"numberOfImpressions"];
    }else
    {
        NSInteger numberOfImpressions = [[[NSUserDefaults standardUserDefaults] valueForKey:@"numberOfImpressions"] integerValue]+1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:numberOfImpressions] forKey:@"numberOfImpressions"];
        
    }
    

    AlertView=[[UIView alloc]init];
    
    NSString * titleText = [campaignDetails valueForKey:@"LaunchMessage"];
    titleText = [titleText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    titleText = [titleText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    AlertView.frame=CGRectMake(isPopUp?20:0, 2000, SCREEN_WIDTH-(isPopUp?40:0), isPopUp?160:100);
    
    unsigned color = [AppViralityUIUtility checkAndGetColorAtKey:@"LaunchBGColor" InDictionary:campaignDetails];
    AlertView.backgroundColor = UIColorFromRGB(color);
    
    
    int Yaxis = isPopUp?((SCREEN_HEIGHT/2)+CGRectGetHeight(AlertView.frame)/2):CGRectGetHeight(AlertView.frame);
    
  
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[campaignDetails valueForKey:@"LaunchIconId"]]]];
    [AlertView addSubview:imageView];
    imageView.center = CGPointMake(isPopUp?SCREEN_WIDTH/2-20:(imageView.center.x+5), imageView.center.y+5);
    
    UILabel  *messageLabel = [[UILabel alloc]init];
    
    messageLabel.frame=CGRectMake(isPopUp?0:CGRectGetMaxX(imageView.frame)+5,isPopUp?CGRectGetMaxY(imageView.frame)+10:-1, CGRectGetWidth(AlertView.frame)-(isPopUp?0:CGRectGetMaxX(imageView.frame)+5), 50);
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textAlignment =NSTextAlignmentCenter;
    
    messageLabel.text = titleText;
    color = [AppViralityUIUtility checkAndGetColorAtKey:@"LaunchMsgColor" InDictionary:campaignDetails];
    messageLabel.textColor = UIColorFromRGB(color);
    messageLabel.backgroundColor =[UIColor clearColor];
    [messageLabel setNumberOfLines:0];
    [AlertView addSubview:messageLabel];

    
    UIButton * launchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [launchButton setTitle:[campaignDetails valueForKey:@"LaunchButtonText"] forState:UIControlStateNormal];
    launchButton.frame = CGRectMake( CGRectGetWidth(AlertView.frame)/2, CGRectGetHeight(AlertView.frame)-40, CGRectGetWidth(AlertView.frame)/2, 40);
    launchButton.tag =42;
    [launchButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [launchButton addTarget:self action:@selector(dismissButton:) forControlEvents:UIControlEventTouchDown];

    UIButton * remindLaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [remindLaterButton setTitle:[campaignDetails valueForKey:@"RemindButtonText"] forState:UIControlStateNormal];
    remindLaterButton.frame = CGRectMake(0, CGRectGetHeight(AlertView.frame)-40, CGRectGetWidth(AlertView.frame)/2, 40);
    [remindLaterButton addTarget:self action:@selector(dismissButton:) forControlEvents:UIControlEventTouchDown];
    [remindLaterButton.titleLabel setFont:[UIFont systemFontOfSize:14]];

    
    color = [AppViralityUIUtility checkAndGetColorAtKey:@"LaunchButtonBGColor" InDictionary:campaignDetails];
    [launchButton setBackgroundImage:[self imageWithColor:UIColorFromRGB(color) andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [remindLaterButton setBackgroundImage:[self imageWithColor:UIColorFromRGB(color) andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    color = [AppViralityUIUtility checkAndGetColorAtKey:@"LaunchButtonTextColor" InDictionary:campaignDetails];
    [launchButton setTitleColor:UIColorFromRGB(color) forState:UIControlStateNormal];
    [remindLaterButton setTitleColor:UIColorFromRGB(color) forState:UIControlStateNormal];

    launchButton.layer.borderColor = UIColorFromRGB(color).CGColor;
    remindLaterButton.layer.borderColor = UIColorFromRGB(color).CGColor;
    launchButton.layer.borderWidth = 0.5;
    remindLaterButton.layer.borderWidth = 0.5;
  
    [AlertView addSubview:launchButton];
    [AlertView addSubview:remindLaterButton];
    
    AlertView.tag =55;
    
    
    if (isPopUp) {
        UIView * popUp = AlertView;
        popUp.frame=CGRectMake(CGRectGetMinX(AlertView.frame), SCREEN_HEIGHT- Yaxis, CGRectGetWidth(AlertView.frame), CGRectGetHeight(AlertView.frame));
        [viewtoShow addSubview:AlertView];
        popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        
        
        [UIView animateWithDuration:0.3/1.5 animations:^{
            popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                popUp.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3/2 animations:^{
                    popUp.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
        return;
    }
    
    AlertView.frame=CGRectMake(CGRectGetMinX(AlertView.frame), SCREEN_HEIGHT+ 200, CGRectGetWidth(AlertView.frame), CGRectGetHeight(AlertView.frame));
    [UIView animateWithDuration:0.8f
                          delay:0.03f
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         AlertView.frame=CGRectMake(CGRectGetMinX(AlertView.frame), SCREEN_HEIGHT- Yaxis, CGRectGetWidth(AlertView.frame), CGRectGetHeight(AlertView.frame));
                         [viewtoShow addSubview:AlertView];
                     }
                     completion:^(BOOL finished){}];
    
}

+(void)dismissButton:(UIButton*)sender
{
    if (sender.tag==42) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showGrowthHack" object:nil];
    }
    
    BOOL isPopUP = CGRectGetMinX(sender.superview.frame)==20;
    
    if (isPopUP) {
        UIView * popUp = sender.superview;
        // instantaneously make the image view small (scaled to 1% of its actual size)
        popUp.transform = CGAffineTransformIdentity;

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            popUp.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
            [popUp removeFromSuperview];
        }];
        return;
    }
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.8f
                              delay:0.10f
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             
                             sender.superview.alpha = 0.0;
                             sender.superview.frame = CGRectMake(CGRectGetMinX(sender.superview.frame),isPopUP?-55:(SCREEN_HEIGHT+ 55), CGRectGetWidth(sender.superview.frame), CGRectGetHeight(sender.superview.frame));
                             
                         }
                         completion:^(BOOL finished){
                             [sender.superview removeFromSuperview];
                         }];
    });
    
    
}

+(void) Remove
{
    [AlertView removeFromSuperview];
}

@end
