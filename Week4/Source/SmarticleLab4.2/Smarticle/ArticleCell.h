#import <UIKit/UIKit.h>

@class Article;

/// A custom table view cell that displays information about an article.
///
@interface ArticleCell : UITableViewCell

/// The article that this cell should be configured to display.
///
@property (nonatomic, strong) Article *article;

@end
