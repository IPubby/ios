#import <XCTest/XCTest.h>

#import "Settings.h"

@interface SettingsTests : XCTestCase

@property (nonatomic, strong) Settings *unitUnderTest;

@end

@implementation SettingsTests

- (void)setUp
{
    [super setUp];
 
    self.unitUnderTest = [[Settings alloc] init];
}

- (void)tearDown
{
    self.unitUnderTest = nil;
    
    [super tearDown];
}

- (void)testColorForArticleType
{
    XCTAssertNotNil([self.unitUnderTest colorForArticleType:ArticleTypeMostEmailed], @"Should have non-nil most emailed color");
    XCTAssertNotNil([self.unitUnderTest colorForArticleType:ArticleTypeMostShared], @"Should have non-nil most shared color");
    XCTAssertNotNil([self.unitUnderTest colorForArticleType:ArticleTypeMostViewed], @"Should have non-nil most viewed color");
    XCTAssertNotNil([self.unitUnderTest colorForArticleType:ArticleTypeFavorites], @"Should have non-nil favorites color");
    
    XCTAssertThrows([self.unitUnderTest colorForArticleType:ArticleTypeUnknown], @"Should throw exception for unknown type");
}

@end
