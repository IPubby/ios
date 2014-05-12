#import "Adventure.h"
#import "Room.h"

@interface Adventure()

/// All the rooms in the adventure
///
@property (nonatomic, strong) NSSet *rooms;

/// The current room.
///
@property (nonatomic, strong) Room *currentRoom;

//- (RoomDirection)directionForString:(NSString *)directionString;

@end

@implementation Adventure

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        //   ________________________
        //  |            |           |
        //  |   Office       Parts   |
        //  |____________|____  _____|
        //  |            |           |
        //  |  Workshop  |  Assembly |
        //  |________________________|
        //
        
        Room *office = [[Room alloc] initWithName:@"Office"];
        
        Room *partsRoom = [[Room alloc] initWithName:@"Parts room"];
        [partsRoom setWestEntranceTo:office];
        
        Room *assemblyRoom = [[Room alloc] initWithName:@"Assembly room"];
        [assemblyRoom setNorthEntranceTo:partsRoom];
        
        Room *workshop = [[Room alloc] initWithName:@"Workshop"];
        [workshop setEastEntranceTo:assemblyRoom];
        
        self.rooms = [NSSet setWithObjects:office, partsRoom, assemblyRoom, workshop, nil];
        
        // Start out in the office
        self.currentRoom = office;
    }
    
    return self;
}

- (NSString *)responseForInput:(NSString *)input
{
    NSArray *components = [input componentsSeparatedByString:@" "];
    
    if ([[components firstObject] isEqualToString:@"walk"])
    {
        if (components.count > 1)
        {
            NSString *normalizedDirection = [[components[1] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            RoomDirection walkingDirection = [Room directionForString:normalizedDirection];
            
            Room *room  = [self.currentRoom roomForDirection:walkingDirection];

            if (room)
            {
                self.currentRoom = room;
            }
            else
            {
                return @"You can't go that way.";
            }
        }
    }
    
    return [self.currentRoom description];
}

@end
