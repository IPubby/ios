#import <Foundation/Foundation.h>

/// Defines the directions for positioning adjacent rooms.
///
typedef enum : NSInteger {
    RoomDirectionInvalid = -1,
    RoomDirectionNorth = 0,
    RoomDirectionEast,
    RoomDirectionSouth,
    RoomDirectionWest
} RoomDirection;

/// Represents a room in the adventure. Rooms have a name and optional, adjacent rooms on their
/// north, east, south, and west sides.
///
@interface Room : NSObject

#pragma mark - Properties

/// The name of the room.
///
@property (nonatomic, strong) NSString *name;

#pragma mark - Class methods

/// Returns a direction for a given string.  The string must be all lowercase and must exactly match
/// the string representation of that direction.
///
/// If the string does not contain a valid direction, this method returns RoomDirectionInvalid.
///
/// @param string
///     The string to match.
///
/// @return
///     A RoomDirection representing the given string or RoomDirectionInvalid if no match was found.
///
+ (RoomDirection)directionForString:(NSString *)string;

#pragma mark - Instance methods

/// Creates a new instance of the class with the specified name.
///
/// @param name
///     The name of the new room.
///
- (id)initWithName:(NSString *)name;

/// This helper function checks for an adjacent room in the specified direction and returns one if
/// it exists. If no room exists in the specified direction, then nil is returned.
///
/// @param direction
///     The direction to search for an adjacent room.
///
/// @return
///     The adjacent room in the specified direction if one exists. Otherwise nil.
///
- (Room *)roomForDirection:(RoomDirection)direction;

/// Sets the room to the north. This method also updates the specified room to set the current room
/// to its south.
///
/// @param room
///     The room to the north of this room. This room will be updated to indicate that the receiver
///     is to its south.
///
- (void)setNorthEntranceTo:(Room *)room;

/// Sets the room to the east. This method also updates the specified room to set the current room
/// to its west.
///
/// @param room
///     The room to the east of this room. This room will be updated to indicate that the receiver
///     is to its west.
///
- (void)setEastEntranceTo:(Room *)room;

/// Sets the room to the south. This method also updates the specified room to set the current room
/// to its north.
///
/// @param room
///     The room to the south of this room. This room will be updated to indicate that the receiver
///     is to its north.
///
- (void)setSouthEntranceTo:(Room *)room;

/// Sets the room to the west. This method also updates the specified room to set the current room
/// to its east.
///
/// @param room
///     The room to the west of this room. This room will be updated to indicate that the receiver
///     is to its east.
///
- (void)setWestEntranceTo:(Room *)room;

@end
