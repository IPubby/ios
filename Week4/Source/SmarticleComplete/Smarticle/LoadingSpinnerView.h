#import <UIKit/UIKit.h>

@interface LoadingSpinnerView : UIView

/// The color of the bolts used in the animation.  Defaults to red.
///
@property (nonatomic, strong) UIColor *color;

/// Whether or not the animation is currently running.
///
@property (nonatomic, readonly, getter = isAnimating) BOOL animating;

/// Starts the animation.  Animation continues until stopAnimating is called.
///
- (void)startAnimating;

/// Stops the animation.  The animation ends with each half of the bolt animating out towards the
/// top and bottom of the screen.
///
- (void)stopAnimating;

@end
