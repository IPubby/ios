#import <XCTest/XCTest.h>

#import "AdventureCell.h"

@interface AdventureCellTests : XCTestCase

/// The cell under test.
///
@property (nonatomic, strong) AdventureCell *cell;

@end

@implementation AdventureCellTests

- (void)setUp
{
    [super setUp];
    
    UINib *adventureCellNib = [UINib nibWithNibName:@"AdventureCell" bundle:nil];
    NSArray *nibObjects = [adventureCellNib instantiateWithOwner:nil options:nil];
    
    self.cell = [nibObjects firstObject];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHasLabel
{
    XCTAssertNotNil(self.cell.entryLabel, @"Cell should have non-nil entry label");
}

@end
