#import "ArticlesController.h"
#import "Article.h"

#pragma mark - Constants

/// The filename to use for the persisted favorites archive.
///
static NSString * const ArticlesControllerFavoritesFilename = @"Favorites.plist";

/// The API key to use for all requests made by this controller.
///
static NSString * const ArticlesControllerNYTimesAPIKey = @"00edfc4660e9ccd3d484598a6aafd603:11:68426625";

/// The base URI for all requests made by this controller.
///
static NSString * const ArticlesControllerNYTimesBaseURI = @"http://api.nytimes.com/svc/mostpopular/v2/";

/// The shared singleton instance, initialized once on the first call to sharedInstance.
///
static ArticlesController *ArticlesControllerSharedInstance;

#pragma mark - Private Interface

@interface ArticlesController ()

#pragma mark - Private Properites

/// List of favorite articles that the user has selected. The favorites array is persisted to disk
/// when favorites are added or removed via addFavoriteArticle: and removeFavoriteArticle: methods.
///
@property (nonatomic, strong) NSMutableArray *favorites;

#pragma mark - Private Methods

/// Returns an article from the favorites array that matches the specified URL.
///
/// @param URLString
///     The URL to search for of articles in the favorites array.
///
/// @return
///     The article from the favorites array with a URL that matches the specified string. If no
///     matching article is found, then nil is returned.
///
- (Article *)favoriteArticleWithURLString:(NSString *)URLString;

/// Returns the path for the file that contains favorite articles that have been persisted to disk.
///
- (NSString *)favoritesFilePath;

/// Indicates whether or not the specified article is in the list of favorites. This method compares
/// articles based on their URL property.
///
/// @param
///     Returns YES if the specified article's URL is a match for any of the articles in the
///     favorites array. Otherwise returns NO.
///
- (BOOL)isFavoriteArticle:(Article *)article;

/// Processes a successful response from a request to get articles.
///
/// Attempts to parse the response of a successful response containing a list of articles retrieved
/// from the API.
///
/// @param data
///     The data from the successful response.
///
/// @param completionHandler
///     The completion handler to call when handling is complete.
///
- (void)processArticlesWithData:(NSData *)data
              completionHandler:(ArticlesControllerCompletionHandler)completionHandler;

/// Reads the favorites array from disk via NSKeyedUnarchiver.
///
/// @return
///     An array of favorite articles that were stored to disk.
///
- (NSArray *)readFavoriteArticles;

/// Writes the favorites array to disk via NSKeyedArchiver.
///
- (void)writeFavoriteArticles;

@end

#pragma mark - Implementation

@implementation ArticlesController

+ (ArticlesController *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ArticlesControllerSharedInstance = [[ArticlesController alloc] init];
    });
    
    return ArticlesControllerSharedInstance;
}

#pragma mark - Init and Dealloc Methods

- (id)init
{
    self = [super init];

    if (self)
    {
        // Lab 3.2
        _favorites = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Public Methods

- (NSArray *)favoriteArticles
{
    return self.favorites;
}

- (void)getArticlesForResourceType:(NSString *)resourceType
                            offset:(NSUInteger)offset
                 completionHandler:(ArticlesControllerCompletionHandler)completionHandler
{
    static NSUInteger DefaultTimePeriod = 7;
    
    NSString *requestString = [ArticlesControllerNYTimesBaseURI stringByAppendingFormat:
                               @"%@/all-sections/%d.json?api-key=%@&offset=%d",
                               resourceType,
                               DefaultTimePeriod,
                               ArticlesControllerNYTimesAPIKey,
                               offset];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:url
                                  completionHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error)
    {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, @0, error);
            });
        }
        else
        {
            [self processArticlesWithData:data
                        completionHandler:completionHandler];
        }
    }];
    
    [task resume];
}

#pragma mark - Private methods

- (Article *)favoriteArticleWithURLString:(NSString *)URLString
{
    NSUInteger index = [self.favorites indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop)
    {
        Article *article = (Article *)object;
        return [article.url isEqualToString:URLString];
    }];

    if (index == NSNotFound)
    {
        return nil;
    }
    else
    {
        return [self.favorites objectAtIndex:index];
    }
}

- (NSString *)favoritesFilePath
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [directories lastObject];
    filePath = [filePath stringByAppendingPathComponent:ArticlesControllerFavoritesFilename];
    return filePath;
}

- (BOOL)isFavoriteArticle:(Article *)article
{
    Article *favorite = [self favoriteArticleWithURLString:article.url];
    return favorite != nil;
}

- (void)processArticlesWithData:(NSData *)data
              completionHandler:(ArticlesControllerCompletionHandler)completionHandler

{
    __block NSError *serializationError;
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:&serializationError];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (serializationError)
        {
            completionHandler(nil, @0, serializationError);
        }
        else
        {
            NSNumber *numResults = json[@"num_results"];
            NSArray *articles = [Article articlesForJSON:json];

            for (Article *article in articles)
            {
                article.isFavorite = [self isFavoriteArticle:article];
            }

            completionHandler(articles, numResults, nil);
        }
    });
}

#pragma mark - Lab 3.2

- (void)addFavoriteArticle:(Article *)article
{
    // Lab 3.2
}

- (void)removeFavoriteArticle:(Article *)article
{
    // Lab 3.2
}

- (NSArray *)readFavoriteArticles
{
    // Lab 3.2
    return self.favorites;
}

- (void)writeFavoriteArticles
{
    // Lab 3.2
}

@end
