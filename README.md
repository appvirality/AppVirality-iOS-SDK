### AppVirality iOS SDK Integration steps

Register your iOS Application at AppVirality.com and copy the AppKey from Dashboard.

<i>NOTE</i>: <b>Don't Register Again,</b> If you have already registered your Android Application and want to run the same referral campaign on iOS App. You have to use the same Android AppKey for iOS App as well.

![Alt text](https://github.com/appvirality/appvirality-sdk-android/blob/master/images/App-key-obtaining.jpg?raw=true)

AppVirality iOS SDK supports iOS V6.0 and above.  Please contact support if you need support for lower versions.

##### STEP : 1

Download the latest iOS SDK from [here] (https://github.com/appvirality/AppVirality-iOS-SDK) and drop the “includes” folder and “libAppVirality.a” file into your project root. 

##### STEP : 2

Import “AppVirality.h” the header file

```objc
#import "AppVirality.h"
```
##### STEP : 3

Initializing the AppVirality SDK.This has to be done in very begining of your App i.e at -application:didFinishLaunchingWithOptions: method in AppDelegate file.

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AppVirality initWithApiKey:@"YOUR_APP_KEY"];
    return YES;
}
```
Replace “YOUR_APP_KEY” with your App key from Dashboard. You can get your App key from AppVirality Dashboard → AppDetails page.

##### STEP : 4

Getting Referrer Details

This is required if you want to show the welcome screen on first App launch. You can get the referrer details by calling the below code block

```objc
[AppVirality getReferrerDetails:^(NSDictionary *referrerDetails) {
            NSLog(@"ref details %@",referrerDetails);
        }];
```
##### STEP : 5

Show GrowthHack

The following callback method will return the referral campaign details. Use the campaign details to show the referral screen to the App users.

```objc
[AppVirality showGrowthHack:GrowthHackTypeWordOfMouth completion:^(NSDictionary *campaignDetails) {
            NSLog(@"growth hack details %@",campaignDetails);
        }];
```
campaignDetails includes list of social actions configured on AppVirality Dashboard. Please use the array with name "socialactions" to get the social share messages and unique share links for each social action.


##### STEP : 6

Record Social Action

Call the below method after successful completion of the social action. i.e after sharing on social media. This records the user social action.

```objc
[AppVirality recordSocialActionForGrowthHack:GrowthHackTypeWordOfMouth WithParams:@{@"shareMessage":[[campaignDetails valueForKeyPath:@"socialactions.shareMessage"]firstObject],@"socialActionId":[[campaignDetails valueForKeyPath:@"socialactions.socialActionId"]firstObject]} completion:^(BOOL success) {
                        NSLog(@"social sucess %d",success);
                    }];

```

Input Parameters:

shareMessage - The message that user has shared on social media.

socialActionId - User performed social action Id, this you will get from campaign Details.

##### STEP : 7

Record Conversion Event

```objc

[AppVirality saveConversionEvent:@{@"eventName":@"Transaction",@"transactionUnit":@"Rs",@"transactionValue":@"560",@"extrainfo":@"orderid:78F6YG"}completion:^(NSDictionary *conversionResult) {
NSLog(@"conversion result %@",conversionResult);
}];

```
Input Parameters:

eventName — Install, Signup, Transaction & Any defined Custom Events

transactionValue — Transaction amount

transactionUnit — Transaction currency unit

extrainfo — Custom Info which is stored across the event and will be provided on query of rewards. It is generally used to save transaction information which can be used to cross check later while rewarding. Extra Info is expected in encoded Uri format.

Output Parameters:

Returns true - On successful conversion i.e if this conversion event matches any of the reward rule configured on dashboard. 

##### STEP : 8

Get User Balance

```objc
[AppVirality getUserBalance:GrowthHackTypeWordOfMouthcompletion:^(NSDictionary *userInfo) {
NSLog(@" user balance %@",userInfo);
        }];
```

##### STEP : 9

Set User Details

```objc
[AppVirality setUserDetails:@{@"EmailId":@"mymail@test.com",@"AppUserName":@"CustomerName",@"ProfileImage":@"http://www.pic.com/profile.png",@"UserIdInstore":@"78903",@"city":@"Pune",@"state":@"Maharashtra",@"country":@"India",@"Phone":@"9876543210",@"isExistingUser":@"true"}completion:^(BOOL success) {
NSLog(@"user details %d",success);
        }];
```
Input Parameters:

EmailId — Email of the user.

AppUserName — First Name of the user, required to personalize the referral messages.

ProfileImage — User profile picture URL, required to personalize the referral messages.

