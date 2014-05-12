#import <UIKit/UIKit.h>

#import "AdventureResponder.h"

@interface AdventureViewController : UIViewController

@property (nonatomic, weak) id<AdventureResponder> responder;

@end
