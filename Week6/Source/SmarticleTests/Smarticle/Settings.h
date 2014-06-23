#import <Foundation/Foundation.h>

/// Enum for the different types of articles that Smarticle displays.
///
typedef enum : NSInteger {
    ArticleTypeUnknown = 0,
    ArticleTypeMostViewed,
    ArticleTypeMostEmailed,
    ArticleTypeMostShared,
    ArticleTypeFavorites
} ArticleType;

/// Global settings for the app.
///
@interface Settings : NSObject

#pragma mark - Class Methods

/// Returns the singleton instance of the Settings object.
///
+ (instancetype)sharedInstance;

#pragma mark - Instance Methods

/// Each article type in the app is color-coded. This method returns the color for the specified
/// article type. The colors are used for navigation bar, toolbar, and loading spinner colors.
///
/// @param articleType
///     The type of article to get the color for.
///
/// @return
///     The color for the specified article type.
///
- (UIColor *)colorForArticleType:(ArticleType)articleType;

@end
