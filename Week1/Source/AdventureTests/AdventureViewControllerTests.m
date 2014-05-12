#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AdventureViewController.h"

@interface AdventureViewControllerTests : XCTestCase

/// The view controller under test.
///
@property (nonatomic, strong) AdventureViewController *controller;

/// A mock object to use as the controller's responder.
///
@property (nonatomic, strong) OCMockObject *mockResponder;

@end

@implementation AdventureViewControllerTests

- (void)setUp
{
    [super setUp];
    
    self.controller = [[AdventureViewController alloc] init];
    XCTAssertNotNil(self.controller.view, @"View controller's view should be non-nil");
    
    id mockResponder = [OCMockObject mockForProtocol:@protocol(AdventureResponder)];
    self.controller.responder = mockResponder;

    self.mockResponder = mockResponder;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testOutletConnections
{
    XCTAssertNotNil([self.controller valueForKey:@"tableView"], @"Should have tableView outlet connected");
    XCTAssertNotNil([self.controller valueForKey:@"textField"], @"Should have textField outlet connected");
    XCTAssertNotNil([self.controller valueForKey:@"textFieldBottomSpace"], @"Should have textFieldBottomSpace connected");
}

- (void)testInit
{
    XCTAssertNotNil([self.controller valueForKey:@"entries"], @"Should have an entries array");
}

- (void)testKeyboardWillShowNotification
{
    [self.controller viewWillAppear:YES];
    
    NSValue *keyboardFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 320.0, 144.0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                        object:nil
                                                      userInfo:@{UIKeyboardFrameEndUserInfoKey: keyboardFrame}];
    
    NSLayoutConstraint *textFieldBottomSpace = [self.controller valueForKey:@"textFieldBottomSpace"];
    XCTAssert(textFieldBottomSpace.constant == -144.0, @"Text field should make room for the keyboard.");
}

- (void)testKeyboardWillHideNotification
{
    [self.controller viewWillAppear:YES];
    
    NSValue *keyboardFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 320.0, 144.0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                        object:nil
                                                      userInfo:@{UIKeyboardFrameBeginUserInfoKey: keyboardFrame}];
    
    NSLayoutConstraint *textFieldBottomSpace = [self.controller valueForKey:@"textFieldBottomSpace"];
    XCTAssert(textFieldBottomSpace.constant == 0.0, @"Text field should return to normal position.");
}

- (void)testTableViewShowsEntries
{
    NSMutableArray *entries = [self.controller valueForKey:@"entries"];
    
    [entries addObject:@"test message"];
    [entries addObject:@"test response"];
    
    UITableView *tableView = [self.controller valueForKey:@"tableView"];
    
    [tableView reloadData];
    
    XCTAssert([tableView numberOfRowsInSection:0] == 2, @"Should have two rows.");

    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *firstCell = [tableView cellForRowAtIndexPath:firstRow];
    XCTAssertNotNil(firstCell, @"Should return non-nil cell for first row");
    
    NSIndexPath *secondRow = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *secondCell = [tableView cellForRowAtIndexPath:secondRow];
    XCTAssertNotNil(secondCell, @"Should return non-nil cell for second row");
}

- (void)testTextFieldShouldReturn
{
    NSString *testMessage = @"test message";
    
    [[[self.mockResponder expect] andReturn:@"test response"] responseForInput:@"test message"];
    
    UITextField *field = [[UITextField alloc] init];
    field.text = testMessage;
    
    [self.controller performSelector:@selector(textFieldShouldReturn:) withObject:field];
    
    NSMutableArray *entries = [self.controller valueForKey:@"entries"];
    XCTAssert(entries.count == 2, @"Should have two entries.");
    
    [self.mockResponder verify];
}

@end
