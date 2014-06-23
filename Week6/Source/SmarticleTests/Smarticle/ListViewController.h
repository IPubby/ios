#import <UIKit/UIKit.h>

@class ArticleProvider;

/// Custom table view controller to display a list of articles.
///
@interface ListViewController : UITableViewController

/// Provides articles to display in the list.
///
@property (nonatomic, strong) ArticleProvider *articles;

@end
