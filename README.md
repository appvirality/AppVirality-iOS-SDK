### AppVirality iOS SDK Integration steps

Register your iOS application at AppVirality.com and copy the AppKey from dashboard.

<i>NOTE</i>: <b>Don't Register Again,</b> if you have already registered your Android Application and want to run the same referral campaign on iOS App as well. 

<i>NOTE</i>: AppVirality iOS SDK supports iPhone simulator 5S or higher & iPhone 4s device and higher. 

The same Android AppKey can be used for iOS app as well.

![Alt text](https://github.com/appvirality/appvirality-sdk-android/blob/master/images/App-key-obtaining.jpg?raw=true)

AppVirality iOS SDK supports iOS V6.0 and above.  Please contact us if you need support for lower versions.

##### STEP : 1

Download the latest iOS SDK from [here] (https://github.com/appvirality/AppVirality-iOS-SDK/archive/master.zip) and drop the “includes” folder and “libAppVirality.a” file into your project root. 

##### STEP : 2

Import “AppVirality.h” the header file

```objc
#import "AppVirality.h"
```
##### STEP : 3

###### Initialize

Initializing the AppVirality SDK has to be done at the very beginning of your App i.e. at  -application:didFinishLaunchingWithOptions: method in AppDelegate file.

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable cookie based attribution to achieve 100% attribution accuracy
    [AppVirality attributeUserBasedonCookie:@"YOUR-APP-KEY" OnCompletion:^(BOOL success, NSError *error) {
        // Init AppVirality SDK
        [AppVirality initWithApiKey:@"YOUR-APP-KEY" OnCompletion:^(NSDictionary *referrerDetails,NSError*error) {
            
            //NSLog(@"user key %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userkey"]);
            //NSLog(@"User has Referrer %@", referrerDetails);
        }];
    }];
    return YES;
}
```
Replace “YOUR_APP_KEY” with your App key from dashboard. You can get your App key from AppVirality Dashboard → App Details page.

##### STEP : 4

###### Getting Referrer Details

This is required if you want to show the welcome screen on the first App launch. You can get the referrer details by calling the below code block

```objc
[AppVirality getReferrerDetails:^(NSDictionary *referrerDetails, NSError *error) {
            NSLog(@"ref details %@",referrerDetails);
        }];
```
##### STEP : 5

###### Show Growth Hack

The following callback method will return the referral campaign details. Use the campaign details to show the referral screen to the App users.

```objc
[AppVirality showGrowthHack:growthHack completion:^(NSDictionary *campaignDetails,NSError*error) {
                NSLog(@"growth hack details %@",campaignDetails);
        }];
```
campaignDetails includes list of social actions configured on AppVirality Dashboard. Please use the array with name "socialactions" to get the social share messages and unique share links for each social action.


##### STEP : 6

###### Record Social Action

Call the below method after successful completion of the social action. i.e after sharing on social media. This records the user social action.

```objc
[AppVirality recordSocialActionForGrowthHack:GrowthHackTypeWordOfMouth WithParams:@{@"shareMessage":[[campaignDetails valueForKeyPath:@"socialactions.shareMessage"]firstObject],@"socialActionId":[[campaignDetails valueForKeyPath:@"socialactions.socialActionId"]firstObject]} completion:^(BOOL success,NSError*error) {
                        NSLog(@"social sucess %d",success);
                    }];

```

###### Input Parameters:

shareMessage - It is the message that the user has shared on social media.

socialActionId - It is the user performed social action id, which can be obtained from campaign details.

##### STEP : 7

###### Record Conversion Event

Before recording any conversion event, please make sure to update the user details(atleast EmailID) to AppVirality [SETP 9](https://github.com/appvirality/AppVirality-iOS-SDK/blob/master/README.md#step--9). User details are required to reward the user.

```objc

[AppVirality saveConversionEvent:@{@"eventName":@"Transaction",@"transactionUnit":@"Rs",@"transactionValue":@"560",@"extrainfo":@"orderid:78F6YG"} completion:^(NSDictionary *conversionResult,NSError *error) {
NSLog(@"conversion result %@",conversionResult);
}];

```
###### Input Parameters:

eventName — Install, Signup, Transaction & Any defined Custom Events

transactionValue — Amount of the transaction.

transactionUnit — Transaction currency unit

extrainfo — Custom Info which is stored across the event and will be provided on query of rewards. It is generally used to save transaction information which can be used to cross check later while rewarding. Extra Info is expected in encoded Uri format.

###### Output Parameters:

Returns true - On successful conversion i.e if this conversion event matches any of the reward rule configured on the dashboard. 

##### STEP : 8

###### Get User Balance

```objc
[AppVirality getUserBalance:self.growthHack completion:^(NSDictionary *userInfo,NSError*error) {
                self.userPoints = [(NSArray*)[userInfo valueForKey:@"userpoints"] firstObject];
                // List of friends installed through the referral link
                self.referredusers = [userInfo valueForKey:@"referredusers"];
                NSLog(@" user balance %@",userInfo);
        }];
```
###### Output  Parameters:

* <b>userpoints</b> — List of points
 * <b>total</b> — Total Rewards for that Campaign
 * <b>claimed</b> — Rewards claimed for that Campaign
 * <b>redeemable_balance</b> — Redeemable Balance i.e. rewards which met the review period and redemption cap. 
 * <b>underreview</b> — Rewards under review for that Campaign
 * <b>rewardunit</b> — Reward unit
 * <b>redemptionthreshold</b> — Redemption cap, it helps to let you know when to distribute the referrer reward.

##### STEP : 9

###### Set User Details

<b> NOTE:</b> Please set the user details before calling "saveConversionEvent" in step 7.

```objc

NSDictionary * userDetails = @{@"EmailId":@"mymail@test.com",@"AppUserName":@"CustomerName",@"ProfileImage":@"http://www.pics.com/profile.png",@"UserIdInstore":@"78903",@"city":@"Pune",@"state":@"Maharashtra",@"country":@"India",@"Phone":@"9876543210",@"isExistingUser":@"false",@"pushDeviceToken":@"YOUR-DEVICE-TOKEN"};

[AppVirality setUserDetails:userDetails Oncompletion:^(BOOL success, NSError *error) {
                NSLog(@"User Details update Status %d", success);
}];        
```
###### Input Parameters:

EmailId — Email id of the user.

AppUserName — First name of the user, required to personalize the referral messages.

ProfileImage — User profile picture URL, required to personalize the referral messages.

UserIdInstore — ID of the user in your App (helps to identify users on dashboard as you do in your app).

city — defines the city of the user.

country — defines the country of the user.

state — defines the state of the user location.

Phone — contact number of the user.

pushDeviceToken - Your device push token to receive push notifications.

isExistingUser — Set this as True, if you identify the user as existing user(this is useful if you don't want to reward existing users).

<b> NOTE: Set "isExistingUser" property only on first App launch i.e. only once. On subsequent launches please don't set this property. At any point of time if you set this property to "True" all the existing user rewards will be set to "Rejected" state.Hence please use this property carefully.</b>

<b>NOTE:</b>  Please use the [Sample Application](https://github.com/appvirality/AppVirality-iOS-SDK/tree/master/AVTest) to see the above callbacks in action.

### Testing Referral Program on iOS

In order to test the Referral program on iOS, the first step would be to register your iOS devices as test devices.

#### Register iOS device as Test Device

1) Add the key "AppViralityDebug" in your info.plist file and set the value "YES". 

2) Click on "Add Test Device" button on dashboard to keep it in listen mode.
(i.e. Select "Test Devices" item from dashboard navigator and click on "Add Test Device" button)

3) Execute "registerAsDebugDevice" callback method to register the device.

```objc
[AppVirality registerAsDebugDevice:^(BOOL success, NSError *error) {
        NSLog(@"Register Test Device Response: %d ", success);
    }];
```

OR

If you are using [Sample App](https://github.com/appvirality/AppVirality-iOS-SDK/tree/master/AVTest) provided by AppVirality, you an simply open the App on the device and shake it twice to add the device in Test Devices list.

4) Once you Add the device in Test Devices, follow the section "Let’s Start Real Testing" in the Testing guide  [provided here](https://github.com/appvirality/appvirality-sdk-android/wiki/Testing-Your-Referral-Programs#lets-start-real-testing)

<H3>Need more Customization:</H3>

Please have a look at our [Wiki page](https://github.com/appvirality/appvirality-sdk-android/wiki)

1. [Getting Started With Appvirality iOS SDK Integration](https://github.com/appvirality/AppVirality-iOS-SDK)
2. [AppVirality API for referral Growth Hack](https://github.com/appvirality/appvirality-sdk-android/wiki/AppVirality-API)
3. [Test Referral Program on iOS](https://github.com/appvirality/AppVirality-iOS-SDK/blob/master/README.md#testing-referral-program-on-ios)
4. [Using Custom Domain | Custom Share URL](https://github.com/appvirality/appvirality-sdk-android/wiki/Using-Custom-Domain)
5. [Optional] [To Whom and When to Show Growth Hack](https://github.com/appvirality/appvirality-sdk-android/wiki/To-Whom-and-When-to-Show-Growth-Hack)
6. [Optional] [Reward Notifications or Web-hook Configuration](https://github.com/appvirality/appvirality-sdk-android/wiki/Reward-Notifications)


