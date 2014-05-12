#import "AppDelegate.h"
#import "AdventureViewController.h"
#import "Adventure.h"

@interface AppDelegate ()

@property (nonatomic, strong) id<AdventureResponder> adventureResponder;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    AdventureViewController *adventureViewController = [[AdventureViewController alloc] init];
    
    // 1. Create an instance of an object that conforms to AdventureResponder and assign it to responder.
    
    self.adventureResponder = [[Adventure alloc] init];
    
    // 2. Also assign it as the adventureViewController's responder.
    
    adventureViewController.responder = self.adventureResponder;

    // 3. Assigning the adventure view controller as our window's rootViewController makes it visible on screen.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:adventureViewController];
    self.window.rootViewController = navigationController;
    
    return YES;
}

@end
