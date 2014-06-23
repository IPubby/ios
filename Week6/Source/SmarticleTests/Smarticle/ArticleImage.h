#import <Foundation/Foundation.h>

/// Represents an image associated with an article.
///
@interface ArticleImage : NSObject <NSCoding>

#pragma mark - Properties

/// The caption for the image.
///
@property (nonatomic, copy) NSString *caption;

/// The height of the image in pixels.
///
@property (nonatomic, assign) NSInteger height;

/// The URL for the image file.
///
@property (nonatomic, copy) NSString *url;

/// The width of the image in pixels.
///
@property (nonatomic, assign) NSInteger width;

+ (ArticleImage *)imageForDictionary:(NSDictionary *)dictionary;

@end
