//
//  AppViralityUIUtility.m
//  testAV
//
//  Created by Ram on 13/05/15.
//  Copyright (c) 2015 AppVirality. All rights reserved.
//

#import "AppViralityUIUtility.h"

@implementation UIButton(ImageTitleCentering)

-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
    // the space between the image and text
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                            - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

-(void) centerHorizontallyButtonAndImageWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}


@end


@implementation AppViralityUIUtility

+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
+(unsigned)checkAndGetColorAtKey:(NSString*)key InDictionary:(NSDictionary*)dictionary
{
    unsigned result = 0;
    
    if ([dictionary objectForKey:key]) {
        NSString * color = [dictionary valueForKey:key];
        NSScanner *scanner = [NSScanner scannerWithString:color];
        
        [scanner setScanLocation:[color hasPrefix:@"#"]?1:0]; // bypass '#' character
        [scanner scanHexInt:&result];
    }
    return result;
}


+(void)resetLabelHeight:(UILabel*)yourLabel
{
    CGRect frame = yourLabel.frame;
    
    float height = [self getHeightForText:yourLabel.text
                                 withFont:yourLabel.font
                                 andWidth:yourLabel.frame.size.width];
    
    yourLabel.frame = CGRectMake(frame.origin.x,
                                 frame.origin.y,
                                 frame.size.width,
                                 height);
}

+(float) getHeightForText:(NSString*) text withFont:(UIFont*) font andWidth:(float) width{
    CGSize constraint = CGSizeMake(width , 2000.0f);
    CGSize title_size;
    float totalHeight;
    
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = title_size.height ;
    }
    
    CGFloat height = MAX(totalHeight, 40.0f);
    return height;
}



@end