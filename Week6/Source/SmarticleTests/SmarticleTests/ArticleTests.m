#import <XCTest/XCTest.h>

#import "Article.h"

@interface ArticleTests : XCTestCase

@property (nonatomic, strong) id testJSON;

@end

@implementation ArticleTests

- (void)setUp
{
    [super setUp];

    NSURL *articlesURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"articles" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:articlesURL];
    
    self.testJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testArticlesForJSON
{
    NSArray *articles = [Article articlesForJSON:self.testJSON[@"results"]];
    
    XCTAssertNotNil(articles, @"Should have non-nil articles");
    XCTAssertEqual(articles.count, (NSUInteger)20, @"Should have 20 articles");
}

- (void)testArticleForDictionary
{
    NSDictionary *articleDictionary = @{@"abstract" : @"A bizarre turn of events.",
                                        @"byline" : @"by Bob Loblaw",
                                        @"published_date" : @"2013-12-15",
                                        @"section" : @"Business",
                                        @"source" : @"The New York Times",
                                        @"title" : @"Bob Loblaw Lobs Law Bomb",
                                        @"url" : @"http://www.example.com",
                                        @"media": @[@{@"type": @"image",
                                                      @"subtype": @"photo",
                                                      @"caption": @"“This is a concoction to justify the giving out of medication at unprecedented and unjustifiable levels,” Keith Conners, a psychologist and early advocate for recognition of A.D.H.D., said of the rising rates of diagnosis of the disorder.",
                                                      @"copyright": @"Karsten Moran for The New York Times",
                                                      @"media-metadata": @[@{@"url": @"http://graphics8.nytimes.com/images/2013/12/15/us/STIMULANT-A/STIMULANT-A-thumbStandard.jpg",
                                                                             @"format": @"Standard Thumbnail",
                                                                             @"height": @75,
                                                                             @"width": @75
                                                                             }]
                                                      }]
                                        };
    
    Article *article = [Article articleForDictionary:articleDictionary];
    
    XCTAssertNotNil(article.abstract, @"Should have non-nil abstract");
    XCTAssertNotNil(article.byline, @"Should have non-nil byline");
    XCTAssertNotNil(article.publishedDate, @"Should have non-nil publishedDate");
    XCTAssertNotNil(article.section, @"Should have non-nil section");
    XCTAssertNotNil(article.source, @"Should have non-nil source");
    XCTAssertNotNil(article.title, @"Should have non-nil title");
    XCTAssertNotNil(article.url, @"Should have non-nil url");
    XCTAssertNotNil(article.defaultImage, @"Should have non-nil defaultImage");
    
    XCTAssertNotNil(article.images, @"Should have non-nil images");
    XCTAssertEqual(article.images.count, (NSUInteger)1, @"Should have 1 image");
    for (ArticleImage *image in article.images)
    {
        XCTAssertNotNil(image.caption, @"Should have a non-nil caption.");
    }
}

- (void)testInitWithCoder
{
    ArticleImage *defaultImage = [[ArticleImage alloc] init];
    NSArray *images = @[[[ArticleImage alloc] init], [[ArticleImage alloc] init]];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [archiver encodeObject:@"test abstract" forKey:@"abstract"];
    [archiver encodeObject:@"test byline" forKey:@"byline"];
    [archiver encodeObject:defaultImage forKey:@"defaultImage"];
    [archiver encodeObject:images forKey:@"images"];
    [archiver encodeObject:@"10-11-99" forKey:@"publishedDate"];
    [archiver encodeObject:@"test section" forKey:@"section"];
    [archiver encodeObject:@"test source" forKey:@"source"];
    [archiver encodeObject:@"test title" forKey:@"title"];
    [archiver encodeObject:@"test url" forKey:@"url"];
    [archiver encodeBool:YES forKey:@"isFavorite"];
    
    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    Article *article = [[Article alloc] initWithCoder:unarchiver];
    
    XCTAssertEqualObjects(article.abstract, @"test abstract", @"Should have decoded abstract");
    XCTAssertEqualObjects(article.byline, @"test byline", @"Should have decoded byline");
    XCTAssertNotNil(article.defaultImage, @"Should have decoded default image");
    XCTAssertNotNil(article.images, @"Should have decoded images");
    XCTAssertEqualObjects(article.publishedDate, @"10-11-99", @"Should have decoded published date");
    XCTAssertEqualObjects(article.section, @"test section", @"Should have decoded section");
    XCTAssertEqualObjects(article.source, @"test source", @"Should have decoded source");
    XCTAssertEqualObjects(article.title, @"test title", @"Should have decoded title");
    XCTAssertEqualObjects(article.url, @"test url", @"Should have decoded url");
    XCTAssertEqual(article.isFavorite, YES, @"Should have decoded isFavorite");
}

- (void)testEncodeWithCoder
{
    ArticleImage *defaultImage = [[ArticleImage alloc] init];
    NSArray *images = @[[[ArticleImage alloc] init], [[ArticleImage alloc] init]];

    Article *article = [[Article alloc] init];
    
    article.abstract = @"test abstract";
    article.byline = @"test byline";
    article.defaultImage = defaultImage;
    article.images = images;
    article.publishedDate = @"10-11-99";
    article.section = @"test section";
    article.source = @"test source";
    article.title = @"test title";
    article.url = @"test url";
    article.isFavorite = YES;
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [article encodeWithCoder:archiver];
    
    [archiver finishEncoding];

    NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"abstract"], @"test abstract", @"Should have decoded abstract");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"byline"], @"test byline", @"Should have decoded byline");
    XCTAssertNotNil([aDecoder decodeObjectForKey:@"defaultImage"], @"Should have decoded default image");
    XCTAssertNotNil([aDecoder decodeObjectForKey:@"images"], @"Should have decoded images");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"publishedDate"], @"10-11-99", @"Should have decoded published date");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"section"], @"test section", @"Should have decoded section");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"source"], @"test source", @"Should have decoded source");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"title"], @"test title", @"Should have decoded title");
    XCTAssertEqualObjects([aDecoder decodeObjectForKey:@"url"], @"test url", @"Should have decoded url");
    XCTAssertEqual([aDecoder decodeBoolForKey:@"isFavorite"], YES, @"Should have decoded isFavorite");
}

- (void)testDefaultImage
{
    Article *article = [[Article alloc] init];

    ArticleImage *image1 = [[ArticleImage alloc] init];
    image1.url = @"http://www.nytimes.com/thumbStandard.jpg";
    
    ArticleImage *image2 = [[ArticleImage alloc] init];
    image2.url = @"http://www.example.com/thumbLarge.jpg";
    
    article.images = @[image1, image2];
    
    ArticleImage *defaultImage = article.defaultImage;

    XCTAssertEqualObjects(defaultImage.url, @"http://www.nytimes.com/tmagArticle.jpg", @"Should have converted large image url for default image");
    
}

@end
