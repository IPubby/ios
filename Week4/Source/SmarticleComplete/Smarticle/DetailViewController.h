#import <UIKit/UIKit.h>
#import "Article.h"

/// View controller to show the details for an article.
///
@interface DetailViewController : UIViewController

#pragma mark - Properties

/// The article to display details for.
///
@property (nonatomic, strong) Article *article;

@end
