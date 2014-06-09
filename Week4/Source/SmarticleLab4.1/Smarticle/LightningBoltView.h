#import <UIKit/UIKit.h>

/// A view that displays a colored lightning bolt image.
///
@interface LightningBoltView : UIView

/// Factory method that creats a new lightning bolt view with the given image and color.
///
/// @param image
///     A UIImage whose alpha channel is used to paint the shape of the lightning bolt.
///
/// @param color
///     A color used to fill in the shape defined by the image.
///
/// @return
///     An initialized lightning bolt view.
///
+ (instancetype)boltWithImage:(UIImage *)image
                        color:(UIColor *)color;

@property (nonatomic, strong) UIImage *boltImage;
@property (nonatomic, strong) UIColor *color;

@end
