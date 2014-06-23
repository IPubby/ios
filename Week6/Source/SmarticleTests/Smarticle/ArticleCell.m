#import "ArticleCell.h"
#import "Article.h"

@interface ArticleCell ()

#pragma mark - IBOutlets

/// Label to display the abstract for the specified article.
///
@property (nonatomic, weak) IBOutlet UILabel *abstractLabel;

/// Displays a ★ if the article is a favorite.
///
@property (nonatomic, weak) IBOutlet UILabel *favoriteLabel;

/// Label for the title of the article.
///
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation ArticleCell

#pragma mark - article Property

- (void)setArticle:(Article *)article
{
    if (article != _article)
    {
        _article = article;

        self.titleLabel.text = article.title;
        self.abstractLabel.text = article.abstract;

        if (article.isFavorite == YES)
        {
            self.favoriteLabel.text = @"★";
        }
        else
        {
            self.favoriteLabel.text = @"";
        }
    }
}

@end
