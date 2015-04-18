### AppVirality iOS SDK Integration steps

Register your iOS Application at AppVirality.com and copy the AppKey from Dashboard.

<b>NOTE</b>: If you have already registered your Android Application and want to run the same referral campaign on iOS App, you need not register your iOS App again. You have to use the same Android AppKey for iOS App as well.

AppVirality iOS SDK supports iOS V6.0 and above.  Please contact support if you need support for lower versions.

##### STEP : 1

Download the latest iOS SDK from Github and drop the “includes” folder and “libAppVirality.a” file into your project root. 

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



