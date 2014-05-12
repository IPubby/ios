#import <XCTest/XCTest.h>

#import "Adventure.h"
#import "Room.h"

@interface AdventureTests : XCTestCase

/// The adventure under test.
///
@property (nonatomic, strong) Adventure *adventure;

@end

@implementation AdventureTests

#pragma mark - Helper methods

- (void)assertResponses:(NSDictionary *)responses
{
    for (NSString *input in responses)
    {
        NSString *response = responses[input];
        XCTAssertEqualObjects([self.adventure responseForInput:input], response,
                              @"Response %@ not valid for input %@.", response, input);
    }
}

#pragma mark - Test setup and teardown

- (void)setUp
{
    [super setUp];
    
    self.adventure = [[Adventure alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Test methods

- (void)testInitCreatesRooms
{
    NSSet *rooms = [self.adventure valueForKey:@"rooms"];
    
    XCTAssertNotNil(rooms, @"Rooms should be non-nil.");
    XCTAssert(rooms.count > 0, @"Rooms should not be empty.");
    
    Room *currentRoom = [self.adventure valueForKey:@"currentRoom"];
    XCTAssertNotNil(currentRoom, @"Current room should not be nil.");
}

- (void)testWalking
{
    NSString *youCantGoThatWay = @"You can't go that way.";
    
    // Starting in the office
    
    [self assertResponses:@{@"walk north": youCantGoThatWay,
                            @"walk south": youCantGoThatWay,
                            @"walk west" : youCantGoThatWay}];

    // Walk east to the parts room.

    XCTAssertNotEqualObjects([self.adventure responseForInput:@"walk east"],
                          youCantGoThatWay,
                          @"Should be able to walk east from the office.");

    [self assertResponses:@{@"walk north": youCantGoThatWay,
                            @"walk east": youCantGoThatWay}];
    
    // Walk south to the assembly room.
    
    XCTAssertNotEqualObjects([self.adventure responseForInput:@"walk south"],
                             youCantGoThatWay,
                             @"Should be able to move south from the parts room.");

    [self assertResponses:@{@"walk south": youCantGoThatWay,
                            @"walk east": youCantGoThatWay}];
    

    // Walk west to the work shop

    XCTAssertNotEqualObjects([self.adventure responseForInput:@"walk west"],
                             youCantGoThatWay,
                             @"Should be able to move west from the parts room.");    
}

@end
