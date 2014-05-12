#import <XCTest/XCTest.h>

#import "Room.h"

@interface RoomTests : XCTestCase

@property (nonatomic, strong) Room *room;

@end

@implementation RoomTests

- (void)setUp
{
    [super setUp];
    
    self.room = [[Room alloc] initWithName:@"Test room"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDirectionForString
{
    XCTAssert([Room directionForString:@"xyzzy"] == RoomDirectionInvalid, @"Direction should be invalid.");
    
    XCTAssert([Room directionForString:@"north"] == RoomDirectionNorth, @"Direction should be north.");
    XCTAssert([Room directionForString:@"south"] == RoomDirectionSouth, @"Direction should be north.");
    XCTAssert([Room directionForString:@"east"] == RoomDirectionEast, @"Direction should be north.");
    XCTAssert([Room directionForString:@"west"] == RoomDirectionWest, @"Direction should be north.");
}

- (void)testNewRoomHasNameAndEmptyRooms
{
    XCTAssert([self.room.name isEqualToString:@"Test room"], @"Room name should be 'Test room'.");
    XCTAssertNil([self.room roomForDirection:RoomDirectionNorth], @"Room should not have room to the north.");
    XCTAssertNil([self.room roomForDirection:RoomDirectionSouth], @"Room should not have room to the south.");
    XCTAssertNil([self.room roomForDirection:RoomDirectionEast], @"Room should not have room to the east.");
    XCTAssertNil([self.room roomForDirection:RoomDirectionWest], @"Room should not have room to the west.");
}

- (void)testSetNorthEntraceToRoom
{
    Room *northRoom = [[Room alloc] initWithName:@"North room"];
    [self.room setNorthEntranceTo:northRoom];
    
    XCTAssertEqual([self.room roomForDirection:RoomDirectionNorth], northRoom, @"Room should have room to the north.");
    XCTAssertEqual([northRoom roomForDirection:RoomDirectionSouth], self.room, @"Room should have room to the south.");
}

- (void)testSetEastEntraceToRoom
{
    Room *eastRoom = [[Room alloc] initWithName:@"East room"];
    [self.room setEastEntranceTo:eastRoom];
    
    XCTAssertEqual([self.room roomForDirection:RoomDirectionEast], eastRoom, @"Room should have room to the east.");
    XCTAssertEqual([eastRoom roomForDirection:RoomDirectionWest], self.room, @"Room should have room to the west.");
}

- (void)testSetWestEntraceToRoom
{
    Room *westRoom = [[Room alloc] initWithName:@"West room"];
    [self.room setWestEntranceTo:westRoom];
    
    XCTAssertEqual([self.room roomForDirection:RoomDirectionWest], westRoom, @"Room should have room to the west.");
    XCTAssertEqual([westRoom roomForDirection:RoomDirectionEast], self.room, @"Room should have room to the east.");
}

- (void)testSetSouthEntraceToRoom
{
    Room *southRoom = [[Room alloc] initWithName:@"South room"];
    [self.room setSouthEntranceTo:southRoom];
    
    XCTAssertEqual([self.room roomForDirection:RoomDirectionSouth], southRoom, @"Room should have room to the south.");
    XCTAssertEqual([southRoom roomForDirection:RoomDirectionNorth], self.room, @"Room should have room to the north.");
}


@end
