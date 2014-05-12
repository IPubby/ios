#import <Foundation/Foundation.h>

@protocol AdventureResponder <NSObject>
@required

- (NSString *)responseForInput:(NSString *)input;

@end
