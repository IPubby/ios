#import "LightningBoltView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LightningBoltView

+ (instancetype)boltWithImage:(UIImage *)image color:(UIColor *)color
{
    LightningBoltView *bolt = [[LightningBoltView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    bolt.boltImage = image;
    bolt.color = color;
    
    return bolt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        self.opaque = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, rect, self.boltImage.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillRect(context, rect);
}

@end
