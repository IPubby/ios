#import <XCTest/XCTest.h>

#import "ArticlesController.h"
#import "Article.h"

@interface ArticlesControllerTests : XCTestCase

@property (nonatomic, strong) NSString *temporaryFavoritesPath;

@property (nonatomic, strong) ArticlesController *unitUnderTest;

@end

@implementation ArticlesControllerTests

- (void)setUp
{
    [super setUp];

    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"favorites.plist"];
    self.temporaryFavoritesPath = path;
    
    self.unitUnderTest = [[ArticlesController alloc] initWithPath:path];
}

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:self.temporaryFavoritesPath error:nil];
    
    [super tearDown];
}

- (void)testAddFavoriteArticle
{
    Article *article = [[Article alloc] init];
    article.title = @"Breaking News";
    article.url = @"http://www.example.com/article.html";
    
    [self.unitUnderTest addFavoriteArticle:article];
    
    XCTAssertEqual(self.unitUnderTest.favoriteArticles.count, 1, @"Should have 1 favorite article.");
    XCTAssertTrue([self.unitUnderTest isFavoriteArticle:article], @"Article should be a favorite");
}

- (void)testRemoveFavoriteArticle
{
    Article *article = [[Article alloc] init];
    article.title = @"Breaking News";
    article.url = @"http://www.example.com/article.html";
    
    [self.unitUnderTest addFavoriteArticle:article];
    [self.unitUnderTest removeFavoriteArticle:article];
    
    XCTAssertEqual(self.unitUnderTest.favoriteArticles.count, 0, @"Should have 0 favorite articles.");
    XCTAssertFalse([self.unitUnderTest isFavoriteArticle:article], @"Article should not be a favorite");
}

@end
