#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UINavigationBar appearance].titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:17.0],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };

    return YES;
}

@end
