#import "ArticlesController.h"
#import "Article.h"

#pragma mark - Constants

/// The filename to use for the persisted favorites archive.
///
static NSString * const ArticlesControllerFavoritesFilename = @"Favorites.plist";

/// The shared singleton instance, initialized once on the first call to sharedInstance.
///
static ArticlesController *ArticlesControllerSharedInstance;

#pragma mark - Private Interface

@interface ArticlesController ()

#pragma mark - Private Properites

@property (nonatomic, copy) NSString *favoritesFilePath;

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
        ArticlesControllerSharedInstance = [[ArticlesController alloc] initWithPath:[self defaultFavoritesFilePath]];
    });
    
    return ArticlesControllerSharedInstance;
}

+ (NSString *)defaultFavoritesFilePath
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [directories lastObject];
    filePath = [filePath stringByAppendingPathComponent:ArticlesControllerFavoritesFilename];
    return filePath;
}

#pragma mark - Init and Dealloc Methods

- (id)initWithPath:(NSString *)path
{
    self = [super init];

    if (self)
    {
        _favoritesFilePath = [path copy];
        _favorites = [NSMutableArray arrayWithArray:[self readFavoriteArticles]];
    }

    return self;
}

#pragma mark - Public Methods

- (void)addFavoriteArticle:(Article *)article
{
    article.isFavorite = YES;
    [self.favorites addObject:article];
    [self writeFavoriteArticles];
}

- (NSArray *)favoriteArticles
{
    return self.favorites;
}

- (void)removeFavoriteArticle:(Article *)article
{
    article.isFavorite = NO;

    Article *favorite = [self favoriteArticleWithURLString:article.url];

    if (favorite != nil)
    {
        [self.favorites removeObject:favorite];
        [self writeFavoriteArticles];
    }
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

- (BOOL)isFavoriteArticle:(Article *)article
{
    Article *favorite = [self favoriteArticleWithURLString:article.url];
    return favorite != nil;
}

- (NSArray *)readFavoriteArticles
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:self.favoritesFilePath];
}

- (void)writeFavoriteArticles
{
    [NSKeyedArchiver archiveRootObject:self.favorites toFile:self.favoritesFilePath];
}

@end
