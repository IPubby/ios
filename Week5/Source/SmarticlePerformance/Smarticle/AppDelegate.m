#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate ()

#pragma mark - Private Properties

/// Keeps a reference to our request for more background processing time.
///
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

/// A timer that will fire every so often so we can see if our app is running in the background.
///
@property (nonatomic, strong) NSTimer *timer;

#pragma mark - Private Methods

/// Requests background processing time from the OS.
///
/// @param application
///     A reference to our application provided by one of the UIApplicationDelegate callbacks when
///     this method is invoked.
///
- (void)startBackgroundTask:(UIApplication *)application;

/// Wraps up our background task an informs the OS that we're done processing.
///
- (void)endBackgroundTask:(UIApplication *)application;

/// Invoked by the timer when it fires to log a note that indicates our app is running in the bg.
///
/// @param timer
///     The timer that fired.
///
- (void)timerDidFire:(NSTimer *)timer;

@end

@implementation AppDelegate

#pragma mark - Private methods

- (void)startBackgroundTask:(UIApplication *)application
{
    NSLog(@"startBackgroundTask:");

    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^
    {
        [self endBackgroundTask:application];
    }];
}

- (void)endBackgroundTask:(UIApplication *)application
{
    NSLog(@"endBackgroundTask:");

    [application endBackgroundTask:self.backgroundTaskIdentifier];
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

- (void)timerDidFire:(NSTimer *)timer
{
    NSLog(@"timerDidFire:");
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:willFinishLaunchingWithOptions:");
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions:");

    [UINavigationBar appearance].titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:17.0],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive:");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive:");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");

//    if (self.timer != nil)
//    {
//        [self.timer invalidate];
//    }
//
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                  target:self
//                                                selector:@selector(timerDidFire:)
//                                                userInfo:nil
//                                                 repeats:YES];

//    [self startBackgroundTask:application];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
//    {
//        [self endBackgroundTask:application];
//    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground:");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate:");
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    NSLog(@"application:shouldSaveApplicationState:");

    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    NSLog(@"application:shouldRestoreApplicationState:");

    return YES;
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"application:didDecodeRestorableStateWithCoder:");
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"application:viewControllerWithRestorationIdentifierPath:coder:");

    NSString *viewControllerIdentifier = [identifierComponents lastObject];

    if ([viewControllerIdentifier isEqualToString:@"DetailViewController"] == YES)
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];

        return detailViewController;
    }
    else
    {
        return nil;
    }
}

@end
