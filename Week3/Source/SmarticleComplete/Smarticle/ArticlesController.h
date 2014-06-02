#import <Foundation/Foundation.h>

@class Article;

/// A block that handles the completion of the retrieval of articles.
///
/// A handler is used in conjunction with a request to retrieve articles.  Depending on the outcome
/// of the request, either a list of articles or an error will be passed as arguments to the handler.
///
/// @param articles
///     The list of articles that was retrieved or nil if the request failed.
///
/// @param numberOfResults
///     The total number of results, for use in pagination.
///
/// @param error
///     The error that occurred while retrieving articles, or nil if the request succeeded.
///
typedef void(^ArticlesControllerCompletionHandler)(NSArray *articles,
                                                   NSNumber *numberOfResults,
                                                   NSError *error);

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

/// Gets the most popular articles for a given resource type and offset.
///
/// Immediately begins retrieving the most popular articles from the New York Times API for a given
/// resource type and offset, then calls the provided completion handler.
///
/// @param resourceType
///     The resourceType to retreive, one of mostemailed, mostshared or mostviewed
///
/// @param offset
///     Positive integer representing the starting point of the results set, must be a multiple of
///     20. Pass 0 to retrieve the first page of results in order to determine the total number of
///     results.
///
/// @param completionHandler
///     The completion handler to call when the request to get articles has completed.
///
- (void)getArticlesForResourceType:(NSString *)resourceType
                            offset:(NSUInteger)offset
                 completionHandler:(ArticlesControllerCompletionHandler)completionHandler;

/// Removes the specified article from the list of favorites. Note that this method currently writes
/// the favorites array to disk after removing the specified article.
///
/// @param article
///     The article to save to disk as a favorite.
///
- (void)removeFavoriteArticle:(Article *)article;

@end
