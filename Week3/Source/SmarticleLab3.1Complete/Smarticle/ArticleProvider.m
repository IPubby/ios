#import "ArticleProvider.h"
#import "Article.h"

#pragma mark - Private constants

/// The API key to use for all requests made by this provider.
///
static NSString * const ArticleProviderNYTimesAPIKey = @"00edfc4660e9ccd3d484598a6aafd603:11:68426625";

/// The base URI for all requests made by this provider.
///
static NSString * const ArticleProviderNYTimesBaseURI = @"http://api.nytimes.com/svc/mostpopular/v2/";

static NSUInteger const ArticleProviderPageSize = 20;

#pragma mark - Public constants

NSString * const ArticleProviderResourceTypeMostEmailed = @"mostemailed";
NSString * const ArticleProviderResourceTypeMostViewed = @"mostviewed";
NSString * const ArticleProviderResourceTypeMostShared = @"mostshared";

#pragma mark - Private interface

@interface ArticleProvider ()

/// An array of articles loaded from the NY times most popular API.
///
@property (nonatomic, strong) NSMutableArray *articles;

/// The total number of articles available or 0 if articles have not yet successfully loaded.
///
@property (nonatomic, assign) NSUInteger articleCount;

/// The current offset, used to retrieve additional pages of results from the API.
///
@property (nonatomic, assign) NSUInteger offset;

/// Whether or not the provider is currently in the middle of loading data.
///
@property (nonatomic, assign) BOOL loading;

/// The resource type of articles to be retrieved.
///
@property (nonatomic, strong) NSString *resourceType;

/// Determines if a given response is valid.
///
/// @param response
///     An HTTP response object to be validated.
/// @param error
///     If an error occurs, upon return contains an NSError object that describes the problem.
///
/// @return YES if the response was accepted, NO otherwise.
///
- (BOOL)acceptsResponse:(NSHTTPURLResponse *)response
                  error:(NSError **)error;

/// Tells the receiver to finish loading and report the given error to its delegate.
///
/// @param error
///     An error that occurred while loading results.
///
- (void)finishLoadingWithError:(NSError *)error;

/// Tells the receiver to finish loading with the given results and offset.
///
/// @param json
///     A dictionary of JSON objects retrieved from the API.
/// @param offset
///     The offset used to retrieve the objects.
///
- (void)finishLoadingWithJSON:(NSDictionary *)json offset:(NSUInteger)offset;

/// Loads articles for the given offset and calls the delegate when finished.
///
/// @param offset
///     The offset from the start of the result set to load.
///
- (void)loadArticlesForOffset:(NSUInteger)offset;

/// Loads the next page of articles based on the current offset.
///
- (void)loadMoreArticles;

@end

@implementation ArticleProvider

#pragma mark - Public methods

- (instancetype)initWithResourceType:(NSString *)resourceType
{
    self = [super init];
    if (self)
    {
        _articles = [NSMutableArray array];
        _articleCount = 0;
        _loading = NO;
        _offset = 0;
        _resourceType = resourceType;
    }
    return self;
}

- (Article *)articleAtIndex:(NSUInteger)index
{
    if (index < self.articles.count)
    {
        return [self.articles objectAtIndex:index];
    }
    else
    {
        [self loadMoreArticles];
        return nil;
    }
}

- (NSUInteger)numberOfArticles
{
    return self.articleCount;
}

- (void)reload
{
    if (!self.loading)
    {
        self.loading = YES;
        
        [self.articles removeAllObjects];
        self.articleCount = 0;
        
        [self loadArticlesForOffset:0];
    }
}

#pragma mark - Private methods

- (BOOL)acceptsResponse:(NSHTTPURLResponse *)response
                  error:(NSError **)error
{
    NSUInteger statusCode = response.statusCode;
    
    if (statusCode == 200)
    {
        return YES;
    }
    else
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:statusCode],
                                   NSURLErrorFailingURLErrorKey: [response URL]};
        *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:userInfo];
        return NO;
    }
}

- (void)finishLoadingWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loading = NO;
        
        if ([self.delegate respondsToSelector:@selector(provider:didFailWithError:)])
        {
            [self.delegate provider:self didFailWithError:error];
        }
    });
}

- (void)finishLoadingWithJSON:(NSDictionary *)json offset:(NSUInteger)offset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loading = NO;
        self.offset = offset;
        
        NSNumber *numResults = json[@"num_results"];
        self.articleCount = [numResults unsignedIntegerValue];
        
        NSArray *resultsArray = json[@"results"];
        NSArray *articles = [Article articlesForJSON:resultsArray];
        [self.articles addObjectsFromArray:articles];
        
        NSIndexSet *articleIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(offset, ArticleProviderPageSize)];
        
        if ([self.delegate respondsToSelector:@selector(provider:didLoadDataAtIndexes:)])
        {
            [self.delegate provider:self didLoadDataAtIndexes:articleIndexes];
        }
    });
}

- (void)loadArticlesForOffset:(NSUInteger)offset
{
    NSString *requestString = [ArticleProviderNYTimesBaseURI stringByAppendingFormat:
                               @"%@/all-sections/7.json?api-key=%@&offset=%zd",
                               self.resourceType,
                               ArticleProviderNYTimesAPIKey,
                               offset];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error)
          {
              [self finishLoadingWithError:error];
              return;
          }
          
          NSError *responseError;
          if (![self acceptsResponse:(NSHTTPURLResponse *)response error:&responseError])
          {
              [self finishLoadingWithError:responseError];
              return;
          }
          
          // Serialize the data to JSON.
          id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&responseError];
          if (!json)
          {
              [self finishLoadingWithError:responseError];
              return;
          }
          
          // Success
          [self finishLoadingWithJSON:json
                               offset:offset];
          
      }] resume];
}

- (void)loadMoreArticles
{
    if (!self.loading)
    {
        self.loading = YES;
        
        NSUInteger nextOffset = self.offset + ArticleProviderPageSize;
        
        if (self.articleCount == 0 || nextOffset < self.articleCount)
        {
            [self loadArticlesForOffset:nextOffset];
        }
    }
}

@end
