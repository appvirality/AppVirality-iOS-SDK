//
//  AppViralityAlertViewController.h
//  testAV
//
//  Created by Ram on 08/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppViralityAlertViewController : UIViewController
+(void) CurrentView:(UIView *)viewtoShow errorString:(NSDictionary *)campaignDetails isPopup:(BOOL)isPopUp;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size ;
+(void) Remove;
@end
