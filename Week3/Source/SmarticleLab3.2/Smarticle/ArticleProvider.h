#import <Foundation/Foundation.h>

@class Article;
@class ArticleProvider;

/// The resource type used to retrieve the most emailed articles from the API.
///
extern NSString * const ArticleProviderResourceTypeMostEmailed;

/// The resource type used to retrieve the most viewed articles from the API.
///
extern NSString * const ArticleProviderResourceTypeMostViewed;

/// The resource type used to retrieve the most shared articles from the API.
///
extern NSString * const ArticleProviderResourceTypeMostShared;

@protocol ArticleProviderDelegate <NSObject>

/// Called whenever the provider has loaded new articles at the given indexes.
///
/// @param provider
///     An article provider that loaded fresh data.
///
/// @param indexes
///     The indexes that were loaded.
///
- (void)provider:(ArticleProvider *)provider didLoadDataAtIndexes:(NSIndexSet *)indexes;


/// Called whenever the provider has encounters an error while loading data.
///
/// @param provider
///     An article provider that triggered an error.
///
/// @param error
///     The error that occurred.
///
- (void)provider:(ArticleProvider *)provider didFailWithError:(NSError *)error;

@end

@interface ArticleProvider : NSObject

/// A delegate that is called whenever new articles are loaded or when an error occurs.
///
@property (nonatomic, weak) id<ArticleProviderDelegate> delegate;

- (instancetype)initWithResourceType:(NSString *)resourceType;

/// Returns an article at the given index or nil if that article has not been loaded.  Calling this
/// method with an index that has not yet been loaded will trigger the next page of articles to load.
///
/// @param index
///     An integer representing the index of the article to be retrieved.
///
/// @return
///     An Article, populated with data from the web service.
///
- (Article *)articleAtIndex:(NSUInteger)index;

/// The total number of articles available for the provider's resource type.  This does not reflect
/// the number of articles that have actually been loaded by this provider thus far.
///
/// @return The number of articles avaiable as reported by the web service.
- (NSUInteger)numberOfArticles;

/// Reloads the provider's articles beginning at the first page of results.
///
- (void)reload;

@end
