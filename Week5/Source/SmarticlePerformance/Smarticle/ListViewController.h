#import <UIKit/UIKit.h>

/// Custom table view controller to display a list of articles.
///
@interface ListViewController : UITableViewController

/// Indicates the type of articles that will be displayed in the list and affects the color of the
/// nav bar.
///
@property (nonatomic, assign) ArticleType articleType;

@end
