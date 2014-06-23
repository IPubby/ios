#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ArticleProvider.h"
#import "MainViewController.h"
#import "ListViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mostViewedButton;
@property (weak, nonatomic) IBOutlet UIButton *mostEmailedButton;
@property (weak, nonatomic) IBOutlet UIButton *mostSharedButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@end

@interface MainViewControllerTests : XCTestCase

@property (nonatomic, strong) MainViewController *unitUnderTest;

@end

@implementation MainViewControllerTests

- (void)setUp
{
    [super setUp];

    MainViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.unitUnderTest = main;
    
    XCTAssertNotNil(self.unitUnderTest.view, @"Should have loaded view");
}

- (void)tearDown
{
    self.unitUnderTest = nil;
    
    [super tearDown];
}

- (void)testOutletConnections
{
    XCTAssertNotNil(self.unitUnderTest.titleLabel, @"Should have non-nil titleLabel");
    XCTAssertNotNil(self.unitUnderTest.mostEmailedButton, @"Should have non-nil mostEmailedButton");
    XCTAssertNotNil(self.unitUnderTest.mostViewedButton, @"Should have non-nil mostViewedButton");
    XCTAssertNotNil(self.unitUnderTest.mostSharedButton, @"Should have non-nil mostSharedButton");
    XCTAssertNotNil(self.unitUnderTest.favoritesButton, @"Should have non-nil favoritesButton");
}

- (void)testPrepareForMostViewedSegue
{
    id destinationMock = [OCMockObject mockForClass:[ListViewController class]];
    [[destinationMock expect] setTitle:@"Most Viewed"];
    [[destinationMock expect] setArticles:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj articleType] == ArticleTypeMostViewed;
    }]];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"" source:self.unitUnderTest destination:destinationMock performHandler:^{}];
    
    [self.unitUnderTest prepareForSegue:segue sender:self.unitUnderTest.mostViewedButton];
    
    [destinationMock verify];
}

- (void)testPrepareForMostSharedSegue
{
    id destinationMock = [OCMockObject mockForClass:[ListViewController class]];
    [[destinationMock expect] setTitle:@"Most Shared"];
    [[destinationMock expect] setArticles:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj articleType] == ArticleTypeMostShared;
    }]];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"" source:self.unitUnderTest destination:destinationMock performHandler:^{}];
    
    [self.unitUnderTest prepareForSegue:segue sender:self.unitUnderTest.mostSharedButton];
    
    [destinationMock verify];
}

- (void)testPrepareForMostEmailedSegue
{
    id destinationMock = [OCMockObject mockForClass:[ListViewController class]];
    [[destinationMock expect] setTitle:@"Most Emailed"];
    [[destinationMock expect] setArticles:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj articleType] == ArticleTypeMostEmailed;
    }]];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"" source:self.unitUnderTest destination:destinationMock performHandler:^{}];
    
    [self.unitUnderTest prepareForSegue:segue sender:self.unitUnderTest.mostEmailedButton];
    
    [destinationMock verify];
}

- (void)testPrepareForFavoritesSegue
{
    id destinationMock = [OCMockObject mockForClass:[ListViewController class]];
    [[destinationMock expect] setTitle:@"Favorites"];
    [[destinationMock expect] setArticles:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj articleType] == ArticleTypeFavorites;
    }]];
    
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"" source:self.unitUnderTest destination:destinationMock performHandler:^{}];
    
    [self.unitUnderTest prepareForSegue:segue sender:self.unitUnderTest.favoritesButton];
    
    [destinationMock verify];
}

@end
