#import <UIKit/UIKit.h>

/// A custom table view cell that displays information about an article.
///
@interface ArticleCell : UITableViewCell

#pragma mark - IBOutlets

/// Label for the title of the article.
///
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
