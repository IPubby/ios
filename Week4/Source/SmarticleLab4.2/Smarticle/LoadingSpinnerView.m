#import "LoadingSpinnerView.h"
#import "LightningBoltView.h"

NSTimeInterval const ViewAppearanceAnimationDuration = 0.3;
NSTimeInterval const BoltAppearanceAnimationDuration = 0.4;
NSTimeInterval const MinimumAnimationDuration = 0.6;

@interface LoadingSpinnerView ()

/// Indicates whether or not the spinner is currently animating. Overrides the public declaration.
///
@property (nonatomic, readwrite, assign) BOOL animating;

/// A view that displays the top portion of the lightning bolt as it animates in from the top.
///
@property (nonatomic, strong) LightningBoltView *boltTop;

/// A view that displasy the bottom portion of the lightning bolt as it animates in from the bottom.
///
@property (nonatomic, strong) LightningBoltView *boltBottom;

/// A transparent view that contains the bolt's top and bottom so that they can be animated together
/// as a single view.
///
@property (nonatomic, strong) UIView *boltContainerView;

/// Indicates when the spinner started animating. We can use this to determine if the bolt has been
/// shown on screen long enough.
///
@property (nonatomic, strong) NSDate *startedAnimatingDate;

@end

@implementation LoadingSpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = [UIColor redColor];
        self.backgroundColor = [UIColor whiteColor];

        self.boltTop = [LightningBoltView boltWithImage:[UIImage imageNamed:@"loading-bolt-top"]
                                                  color:self.color];
        self.boltBottom = [LightningBoltView boltWithImage:[UIImage imageNamed:@"loading-bolt-bottom"]
                                                     color:self.color];

    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    if (_color != color)
    {
        _color = color;
        
        self.boltTop.color = color;
        self.boltBottom.color = color;
    }
}

- (void)startAnimating
{
    if (![self isAnimating])
    {
        self.startedAnimatingDate = [NSDate date];
        self.animating = YES;
        self.hidden = NO;
        
        _boltContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _boltContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
        | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        
        [_boltContainerView addSubview:_boltTop];
        [_boltContainerView addSubview:_boltBottom];
        
        [self addSubview:_boltContainerView];

        
        // TODO Move boltTop and boltBottom to their initial positions and make them transparent.
        
        // TODO Animate boltTop and boltBottom to their final central positions and opacity using BoltAppearanceAnimationDuration.
        
        // TODO Call startRotation when the animation completes
    }
}

- (void)startRotation
{
    // TODO Rotate boltContainerView by 360 degrees, pausing for 1.0 second between each rotation.
}

- (void)stopAnimating
{
    if ([self isAnimating])
    {
        self.animating = NO;

        // TODO Stop the rotation animation
        
        // TODO Fade the boltContainerView out with duration BoltAppearanceAnimationDuration
        
        // TODO After boltContainerView completes fading, fade self out with ViewAppearanceDuration.
        self.alpha = 0.0;
    }
}

@end
