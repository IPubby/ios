#import <Foundation/Foundation.h>

@class Article;

/// A shared singleton for accessing articles from the New York Times API.
///
@interface ArticlesController : NSObject

#pragma mark - Class methods

/// Returns a shared singleton ArticlesController object.
///
/// The shared ArticlesController loads articles from the New York Times Most Popular API.
///
/// @see http://developer.nytimes.com/docs/most_popular_api/
///
/// @return
///     The singleton instance.
///
+ (ArticlesController *)sharedInstance;

#pragma mark - Instance methods

/// Adds an article to the set of favorites. Note that this method currently writes the favorites
/// array to disk after adding the specified article.
///
/// @param article
///     The article to save as a favorite.
///
- (void)addFavoriteArticle:(Article *)article;

/// Returns an array of the articles currently marked as favorites.
///
- (NSArray *)favoriteArticles;

/// Removes the specified article from the list of favorites. Note that this method currently writes
/// the favorites array to disk after removing the specified article.
///
/// @param article
///     The article to save to disk as a favorite.
///
- (void)removeFavoriteArticle:(Article *)article;

@end
