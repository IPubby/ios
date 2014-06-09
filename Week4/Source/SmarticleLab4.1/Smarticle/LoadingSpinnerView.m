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

        
        CGRect viewBounds = self.boltContainerView.bounds;
        CGPoint viewCenter = CGPointMake(CGRectGetMidX(viewBounds),
                                         CGRectGetMidY(viewBounds));
        
        self.boltTop.alpha = 0.0;
        self.boltTop.center = CGPointMake(viewCenter.x,
                                          0.0);
        
        self.boltBottom.alpha = 0.0;
        self.boltBottom.center = CGPointMake(viewCenter.x,
                                             viewBounds.size.height);
        
        [UIView animateWithDuration:BoltAppearanceAnimationDuration
        delay:0.0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^
        {
            self.boltTop.alpha = 1.0;
            self.boltTop.center = CGPointMake(viewCenter.x - 4, viewCenter.y - 12);
            
            self.boltBottom.alpha = 1.0;
            self.boltBottom.center = CGPointMake(viewCenter.x + 4, viewCenter.y + 12);
        }
        completion:^(BOOL finished)
        {
            [self startRotation];
        }];
    }
}

- (void)startRotation
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.5;
    animationGroup.repeatCount = INFINITY;
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.6 :0.1 :0.7 :1.3];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.beginTime = 1.0;
    rotationAnimation.duration = 0.5;
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(-2 * M_PI);
    rotationAnimation.timingFunction = timingFunction;
    
    animationGroup.animations = @[rotationAnimation];
    
    [self.boltContainerView.layer addAnimation:animationGroup forKey:@"spin"];
}

- (void)stopAnimating
{
    if ([self isAnimating])
    {
        self.animating = NO;

        [self.boltContainerView.layer removeAnimationForKey:@"spin"];

        NSTimeInterval animationDuration = -[self.startedAnimatingDate timeIntervalSinceNow];
        NSTimeInterval delay = 0.0;

        if (animationDuration < MinimumAnimationDuration)
        {
            delay = MinimumAnimationDuration - animationDuration;
        }

        [UIView animateWithDuration:BoltAppearanceAnimationDuration
        delay:delay
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^
        {
            self.boltContainerView.alpha = 0.0;
        }
        completion:^(BOOL finished)
        {
            [self.boltContainerView removeFromSuperview];
            self.boltContainerView = nil;
            
            [UIView animateWithDuration:ViewAppearanceAnimationDuration
            delay:0.0
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^
            {
                self.alpha = 0.0;
            }
            completion:^(BOOL finished)
            {
                self.hidden = YES;
                self.alpha = 1.0;
            }];
        }];
    }
}

@end
