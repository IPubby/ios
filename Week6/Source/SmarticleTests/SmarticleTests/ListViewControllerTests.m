#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Article.h"
#import "ArticleCell.h"
#import "ArticleProvider.h"
#import "ListViewController.h"
#import "LoadingSpinnerView.h"

@interface ListViewController () <ArticleProviderDelegate>

#pragma mark - Private Properties

@property (nonatomic, strong) ArticleCell *articleCellForHeight;
@property (nonatomic, strong) LoadingSpinnerView *loadingSpinner;

@end

@interface ListViewControllerTests : XCTestCase

@property (nonatomic, strong) ListViewController *unitUnderTest;
@property (nonatomic, strong) id articleProviderMock;

@end

@implementation ListViewControllerTests

- (void)setUp
{
    [super setUp];
    
    id articleProviderMock = [OCMockObject niceMockForClass:[ArticleProvider class]];
    [[[articleProviderMock stub] andReturnValue:@(ArticleTypeMostViewed)] articleType];
    self.articleProviderMock = articleProviderMock;

    ListViewController *list = [[ListViewController alloc] init];
    list.articles = articleProviderMock;

    self.unitUnderTest = list;
}

- (void)tearDown
{
    self.unitUnderTest = nil;
    
    [super tearDown];
}

- (void)testViewLoaded
{
    XCTAssertNotNil(self.unitUnderTest.view, @"Should load view");
    XCTAssertNotNil(self.unitUnderTest.loadingSpinner, @"Should load loading spinner");
}

- (void)testCellForRowAtIndexPath
{
    Article *article = [[Article alloc] init];
    [[[self.articleProviderMock stub] andReturn:article] articleAtIndex:0];
    
    ArticleCell *cell = [[ArticleCell alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    id tableViewMock = [OCMockObject mockForClass:[UITableView class]];
    [[[tableViewMock expect] andReturn:cell] dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    id result = [self.unitUnderTest tableView:tableViewMock
                        cellForRowAtIndexPath:indexPath];
    
    XCTAssertEqualObjects(result, cell, @"Should have configured article cell");
    XCTAssertEqualObjects([result article], article, @"Should have set article on article cell");
}

- (void)testProviderDidLoadDataAtIndexPaths
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)];
    [self.unitUnderTest provider:self.articleProviderMock didLoadDataAtIndexes:indexSet];
    
    XCTAssertFalse([self.unitUnderTest.loadingSpinner isAnimating], @"Should stop loading spinner");
}

- (void)testProviderDidFailWithError
{
    [self.unitUnderTest provider:self.articleProviderMock didFailWithError:[NSError errorWithDomain:@"FakeErrorDomain" code:1 userInfo:nil]];
    
    XCTAssertFalse([self.unitUnderTest.loadingSpinner isAnimating], @"Should stop loading spinner");
}

@end
