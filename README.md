# AppVirality-iOS-SDK

### AppVirality iOS SDK Integration steps

Register your iOS Application at AppVirality.com and copy the AppKey from Dashboard.

AppVirality iOS SDK supports iOS V6.0 and above.  Please contact support if you need support for lower versions.

#### STEP : 1

Download the latest iOS SDK from Github and drop the “includes” folder and “libAppVirality.a” file into your project root. 

#### STEP : 2

Import “AppVirality.h” the header file

```objc
#import "AppVirality.h"
```
#### STEP : 3

Initializing the AppVirality SDK by adding the following code in your -application:didFinishLaunchingWithOptions: method in AppDelegate file.

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AppVirality initWithApiKey:@"6e039a45b2af42789d82a41f005fb58b"];
    return YES;
}
```

